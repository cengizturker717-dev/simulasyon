param([Parameter(Mandatory=$true)][string]$MachineRoot,[Parameter(Mandatory=$true)][string]$RecoveryRoot)
. (Join-Path $PSScriptRoot 'DailyMigration.ps1')
$MachineRoot=[IO.Path]::GetFullPath($MachineRoot).TrimEnd('\')
$system=Join-Path $MachineRoot 'Tools\KesimSureleriYedekleme'
try {
    if ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value -ne 'S-1-5-18') {throw 'Gecis Windows SYSTEM goreviyle calismali'}
    $result=Invoke-DailyMigration $MachineRoot $RecoveryRoot
    $taskName='POYRAZ_KesimSureleri_KorumaliYedek'
    $worker=Join-Path $system 'DailyWorker.ps1'
    $action=New-ScheduledTaskAction -Execute (Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe') -Argument ('-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "'+$worker+'"')
    $startup=New-ScheduledTaskTrigger -AtStartup
    $repeat=New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration (New-TimeSpan -Days 3650)
    $principal=New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
    $settings=New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 5)
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger @($startup,$repeat) -Principal $principal -Settings $settings -Description 'Kesim kayitlarini yalniz tarihli gunluk dosyalara yedekler.' -Force | Out-Null
    $process=Start-Process -FilePath (Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe') -ArgumentList @('-NoProfile','-NonInteractive','-ExecutionPolicy','Bypass','-File',('"'+$worker+'"')) -WindowStyle Hidden -PassThru
    $handle=$process.Handle; $process.WaitForExit()
    if ($process.ExitCode -ne 0) {throw 'Yeni gunluk yedekleme ilk kontrolu basarisiz; eski dosyalar silinmedi.'}
    Complete-DailyCleanup $MachineRoot
    Write-AtomicJson (Join-Path $system 'install-result.json') ([ordered]@{Success=$true;Records=$result.Records;RecoveryFolder=$result.RecoveryFolder;CompletedUtc=[datetime]::UtcNow.ToString('o')})
    exit 0
} catch {
    Write-AtomicJson (Join-Path $system 'install-result.json') ([ordered]@{Success=$false;Error=$_.Exception.Message})
    exit 1
}
