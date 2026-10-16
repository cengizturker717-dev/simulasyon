. (Join-Path $PSScriptRoot 'DailyCore.ps1')

function Set-DailyPermissions([string]$Path,[bool]$Directory,[bool]$Maintenance) {
    $acl = if ($Directory) {New-Object Security.AccessControl.DirectorySecurity} else {New-Object Security.AccessControl.FileSecurity}
    $acl.SetAccessRuleProtection($true,$false)
    $inheritance = if ($Directory) {[Security.AccessControl.InheritanceFlags]'ContainerInherit,ObjectInherit'} else {[Security.AccessControl.InheritanceFlags]::None}
    foreach ($entry in @(@('S-1-5-18','FullControl'),@('S-1-5-32-544',$(if ($Maintenance) {'FullControl'} else {'ReadAndExecute'})),@('S-1-5-32-545','ReadAndExecute'))) {
        $sid=New-Object Security.Principal.SecurityIdentifier($entry[0])
        $rule=New-Object Security.AccessControl.FileSystemAccessRule($sid,[Security.AccessControl.FileSystemRights]$entry[1],$inheritance,[Security.AccessControl.PropagationFlags]::None,[Security.AccessControl.AccessControlType]::Allow)
        $acl.AddAccessRule($rule)
    }
    Set-Acl -LiteralPath $Path -AclObject $acl
}
function Get-CompleteCutBytes([byte[]]$Bytes) {
    $end=$Bytes.Length
    while ($end -gt 0 -and $Bytes[$end-1] -ne 10) {$end--}
    $complete=New-Object byte[] $end
    [Array]::Copy($Bytes,0,$complete,0,$end)
    return ,$complete
}
function Invoke-DailyMigration([string]$MachineRoot,[string]$RecoveryRoot,[bool]$ProtectArchive=$true) {
    $MachineRoot=[IO.Path]::GetFullPath($MachineRoot).TrimEnd('\')
    $archive=Join-Path $MachineRoot 'Kesim Sureleri'
    $daily=Join-Path $archive 'Gunluk'
    $system=Join-Path $MachineRoot 'Tools\KesimSureleriYedekleme'
    $raw=Join-Path $MachineRoot 'Log\KesimSureleri_Ham.log'
    $live=Join-Path $MachineRoot 'Log\KesimSureleri.log'
    if (-not (Test-Path -LiteralPath (Join-Path $MachineRoot 'Log')) -or (-not (Test-Path -LiteralPath $raw) -and -not (Test-Path -LiteralPath $live))) {throw 'Bu klasorde kesim suresi kaynagi bulunamadi; hicbir dosya temizlenmedi.'}
    New-Item -ItemType Directory -Path $system,$daily -Force | Out-Null
    Complete-CutTransaction $system $MachineRoot
    $source=if (Test-Path -LiteralPath $raw) {$raw} else {$live}
    $sourceBytes=Get-CompleteCutBytes (Read-SharedBytes $source)
    $sources=New-Object 'Collections.Generic.List[object]'
    $sources.Add(@(Get-DailyRecords $daily))
    foreach ($path in @((Join-Path $archive 'KesimSureleri_SaltOkunur.log'),$live)) {
        if (Test-Path -LiteralPath $path) {$sources.Add(@(Convert-CutBytes (Read-SharedBytes $path)))}
    }
    $sources.Add(@(Convert-CutBytes $sourceBytes))
    $combined=New-Object 'Collections.Generic.List[object]'
    foreach ($records in $sources) {
        foreach ($missing in @(Get-MissingRecords @($records) @($combined.ToArray()))) {$combined.Add($missing)}
    }
    # A one-time recovery copy is separate from the daily cut archive.
    $recovery=Join-Path $RecoveryRoot ((Split-Path -Leaf $MachineRoot)+'_'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
    New-Item -ItemType Directory -Path $recovery -Force | Out-Null
    if (Test-Path -LiteralPath $archive) {Copy-Item -LiteralPath $archive -Destination (Join-Path $recovery 'Kesim Sureleri') -Recurse -Force}
    foreach ($path in @($raw,$live)) {if (Test-Path -LiteralPath $path) {Copy-Item -LiteralPath $path -Destination $recovery -Force}}
    $operations=New-Object 'Collections.Generic.List[object]'
    foreach ($group in ($combined.ToArray() | Group-Object Date)) {
        $path=Join-Path $daily ('KesimSureleri_'+$group.Name+'.log')
        $existing=if (Test-Path -LiteralPath $path) {@(Convert-CutBytes (Read-SharedBytes $path))} else {@()}
        Add-RecordOperations $operations $path @(Get-MissingRecords @($group.Group) $existing)
    }
    if ($source -eq $raw) {
        $existing=if (Test-Path -LiteralPath $live) {@(Convert-CutBytes (Read-SharedBytes $live))} else {@()}
        Add-RecordOperations $operations $live @(Get-MissingRecords @(Convert-CutBytes $sourceBytes) $existing)
    }
    $state=[ordered]@{FormatVersion=3;SourcePath=$source;Offset=$sourceBytes.LongLength;PrefixSha256=(Get-BytesHash $sourceBytes);LastRunUtc=[datetime]::UtcNow.ToString('o')}
    Write-AtomicJson (Join-Path $system 'pending.json') ([ordered]@{Operations=@($operations.ToArray());State=$state})
    Complete-CutTransaction $system $MachineRoot
    $after=@(Get-DailyRecords $daily)
    if (@(Get-MissingRecords @($combined.ToArray()) $after).Count -ne 0) {throw 'Gecmis kayitlarin gunluk arsiv dogrulamasi basarisiz; eski dosyalar korunuyor.'}
    Write-AtomicJson (Join-Path $system 'migration.json') ([ordered]@{Version=1;CompletedUtc=[datetime]::UtcNow.ToString('o');PreservedRecords=$combined.Count;RecoveryFolder=$recovery})
    return [pscustomobject]@{MachineRoot=$MachineRoot;Records=$combined.Count;RecoveryFolder=$recovery}
}
function Complete-DailyCleanup([string]$MachineRoot,[bool]$ProtectArchive=$true) {
    $MachineRoot=[IO.Path]::GetFullPath($MachineRoot).TrimEnd('\')
    $archive=Join-Path $MachineRoot 'Kesim Sureleri'
    $daily=Join-Path $archive 'Gunluk'
    $system=Join-Path $MachineRoot 'Tools\KesimSureleriYedekleme'
    if (-not (Test-Path -LiteralPath (Join-Path $system 'migration.json'))) {throw 'Dogrulanmis gecis bulunamadi; temizlik yapilmadi'}
    # Only the known previous backup files are retired. Never recurse-delete
    # the archive, unknown user files, machine data, HMI or PLC files.
    $retired=@('Kesim Süreleri Yedekleme Kaldır.bat','Kesim Süreleri Yedekleme.bat','KesimSureleri_SaltOkunur.log','KesimSureleriYedekle.ps1','KORUMA_KALDIR.ps1','KORUMA_KUR.ps1','KORUMA_KURULUMU.txt','KURULUM_BILGISI.txt','Mudahale_Uyarilari.log','salt_okunur_aktif.marker','yedek_durum.json')
    foreach ($name in $retired) {
        $path=Join-Path $archive $name
        if (Test-Path -LiteralPath $path -PathType Leaf) {Remove-Item -LiteralPath $path -Force}
    }
    foreach ($file in (Get-ChildItem -LiteralPath $daily -Filter 'KesimSureleri_????-??-??.log' -File)) {
        if ($file.Length -eq 0) {Remove-Item -LiteralPath $file.FullName -Force}
    }
    if ($ProtectArchive) {
        Set-DailyPermissions $archive $true $false
        Set-DailyPermissions $daily $true $false
        foreach ($file in (Get-ChildItem -LiteralPath $daily -File)) {Set-DailyPermissions $file.FullName $false $false}
        Set-DailyPermissions $system $true $true
        foreach ($file in (Get-ChildItem -LiteralPath $system -File)) {Set-DailyPermissions $file.FullName $false $true}
    }
}
