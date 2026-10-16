param([Parameter(Mandatory=$true)][string]$MachineRoot)
$ErrorActionPreference='Stop'
try {
    $identity=[Security.Principal.WindowsIdentity]::GetCurrent()
    $principal=New-Object Security.Principal.WindowsPrincipal($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {throw 'Gunluk yedekleme kurulumu icin Windows yonetici izni gerekli.'}
    $MachineRoot=[IO.Path]::GetFullPath($MachineRoot).TrimEnd('\')
    if (-not (Test-Path -LiteralPath (Join-Path $MachineRoot 'Dati')) -or -not (Test-Path -LiteralPath (Join-Path $MachineRoot 'Log'))) {throw 'Gecerli makine data klasoru secilmedi.'}
    if (-not (Test-Path -LiteralPath (Join-Path $MachineRoot 'Log\KesimSureleri_Ham.log')) -and -not (Test-Path -LiteralPath (Join-Path $MachineRoot 'Log\KesimSureleri.log'))) {throw 'Kesim suresi kaydi bulunamadi; CNI dosyalarinda degisiklik yapilmadi.'}
    $system=Join-Path $MachineRoot 'Tools\KesimSureleriYedekleme'
    New-Item -ItemType Directory -Path $system -Force | Out-Null
    . (Join-Path $PSScriptRoot 'DailyMigration.ps1')
    Set-DailyPermissions $system $true $true
    $taskName='POYRAZ_KesimSureleri_KorumaliYedek'
    $old=Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    $wasEnabled=$old -and $old.State -ne 'Disabled'
    $recovery=Join-Path $env:ProgramData 'POYRAZ\Vigor\YedeklemeGecisi'
    New-Item -ItemType Directory -Path $recovery -Force | Out-Null
    if ($old) {
        Export-ScheduledTask -TaskName $taskName | Set-Content -LiteralPath (Join-Path $system 'previous-task.xml') -Encoding UTF8
        Disable-ScheduledTask -TaskName $taskName | Out-Null
        Stop-ScheduledTask -TaskName $taskName
        $deadline=(Get-Date).AddSeconds(30)
        while ((Get-ScheduledTask -TaskName $taskName).State -eq 'Running') {if ((Get-Date) -gt $deadline) {throw 'Onceki yedekleme durmadi'}; Start-Sleep -Milliseconds 250}
    }
    foreach ($name in @('DailyCore.ps1','DailyWorker.ps1','DailyMigration.ps1','DailyApply.ps1')) {
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination (Join-Path $system $name) -Force
        Set-DailyPermissions (Join-Path $system $name) $false $true
    }
    $resultPath=Join-Path $system 'install-result.json'
    if (Test-Path -LiteralPath $resultPath) {Remove-Item -LiteralPath $resultPath -Force}
    $temporary='POYRAZ_KesimSureleri_Gecis_'+[guid]::NewGuid().ToString('N')
    $action=New-ScheduledTaskAction -Execute (Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe') -Argument ('-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "'+(Join-Path $system 'DailyApply.ps1')+'" -MachineRoot "'+$MachineRoot+'" -RecoveryRoot "'+$recovery+'"')
    $taskPrincipal=New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
    $settings=New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 5)
    Register-ScheduledTask -TaskName $temporary -Action $action -Principal $taskPrincipal -Settings $settings | Out-Null
    try {
        Start-ScheduledTask -TaskName $temporary
        $deadline=(Get-Date).AddMinutes(4)
        do {Start-Sleep -Milliseconds 500; $info=Get-ScheduledTaskInfo -TaskName $temporary; $task=Get-ScheduledTask -TaskName $temporary} while (($task.State -eq 'Running' -or -not (Test-Path -LiteralPath $resultPath)) -and (Get-Date) -lt $deadline)
        if ($task.State -eq 'Running' -or -not (Test-Path -LiteralPath $resultPath)) {throw 'Gunluk yedekleme gecisi tamamlanamadi. Eski kayitlar korunuyor.'}
        $result=Get-Content -LiteralPath $resultPath -Raw | ConvertFrom-Json
        if (-not $result.Success) {throw $result.Error}
        Write-Host ('Gunluk yedekleme kuruldu. Korunan kayit: '+$result.Records)
    } finally {Unregister-ScheduledTask -TaskName $temporary -Confirm:$false -ErrorAction SilentlyContinue}
    exit 0
} catch {
    if (Get-Variable wasEnabled -ErrorAction SilentlyContinue) {
        if ($wasEnabled) {Enable-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue | Out-Null}
    }
    Write-Error $_ -ErrorAction Continue
    exit 1
}
