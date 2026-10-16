param([string]$MachineRoot)
. (Join-Path $PSScriptRoot 'DailyCore.ps1')
if (-not $MachineRoot) { $MachineRoot=Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }
$MachineRoot=[IO.Path]::GetFullPath($MachineRoot).TrimEnd('\')
$systemRoot=Join-Path $MachineRoot 'Tools\KesimSureleriYedekleme'
$dailyRoot=Join-Path $MachineRoot 'Kesim Sureleri\Gunluk'
$liveLog=Join-Path $MachineRoot 'Log\KesimSureleri.log'
$rawLog=Join-Path $MachineRoot 'Log\KesimSureleri_Ham.log'
try {
    if (-not (Test-Path -LiteralPath $systemRoot) -or -not (Test-Path -LiteralPath $dailyRoot)) { throw 'Gunluk yedekleme kurulumu eksik' }
    Complete-CutTransaction $systemRoot $MachineRoot
    $source=if (Test-Path -LiteralPath $rawLog) {$rawLog} else {$liveLog}
    if (-not (Test-Path -LiteralPath $source)) { exit 0 }
    $bytes=Read-SharedBytes $source
    $statePath=Join-Path $systemRoot 'state.json'
    $state=if (Test-Path -LiteralPath $statePath) {Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json} else {$null}
    $offset=[long]0
    $reset=$true
    if ($state -and $state.FormatVersion -eq 3 -and $state.SourcePath -eq $source -and $state.Offset -le $bytes.LongLength) {
        $prefix=New-Object byte[] ([int]$state.Offset)
        [Array]::Copy($bytes,0,$prefix,0,$prefix.Length)
        if ((Get-BytesHash $prefix) -eq $state.PrefixSha256) {$offset=[long]$state.Offset; $reset=$false}
    }
    $end=$bytes.Length
    while ($end -gt $offset -and $bytes[$end-1] -ne 10) {$end--}
    if ($end -eq $offset) {exit 0}
    $new=New-Object byte[] ([int]($end-$offset))
    [Array]::Copy($bytes,[int]$offset,$new,0,$new.Length)
    $records=@(Convert-CutBytes $new)
    $operations=New-Object 'Collections.Generic.List[object]'
    $dailyRecords=if ($reset) {@(Get-DailyRecords $dailyRoot)} else {@()}
    $newDaily=if ($reset) {@(Get-MissingRecords $records $dailyRecords)} else {$records}
    foreach ($group in ($newDaily | Group-Object Date)) {
        Add-RecordOperations $operations (Join-Path $dailyRoot ('KesimSureleri_'+$group.Name+'.log')) @($group.Group)
    }
    if ($source -eq $rawLog) {
        $newLive=if ($reset) {
            $existing=if (Test-Path -LiteralPath $liveLog) {@(Convert-CutBytes (Read-SharedBytes $liveLog))} else {@()}
            @(Get-MissingRecords $records $existing)
        } else {$records}
        Add-RecordOperations $operations $liveLog @($newLive)
    }
    $prefix=New-Object byte[] $end
    [Array]::Copy($bytes,0,$prefix,0,$end)
    $next=[ordered]@{FormatVersion=3;SourcePath=$source;Offset=$end;PrefixSha256=(Get-BytesHash $prefix);LastRunUtc=[datetime]::UtcNow.ToString('o')}
    Write-AtomicJson (Join-Path $systemRoot 'pending.json') ([ordered]@{Operations=@($operations.ToArray());State=$next})
    Complete-CutTransaction $systemRoot $MachineRoot
    exit 0
} catch {
    $line='{0:o} - {1}{2}' -f [datetime]::Now,$_.Exception.Message,[Environment]::NewLine
    [IO.File]::AppendAllText((Join-Path $MachineRoot 'Log\KesimSureleriYedeklemeHatasi.log'),$line,$script:Utf8)
    exit 1
}
