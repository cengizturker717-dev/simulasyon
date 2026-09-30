param([Parameter(Mandatory=$true)][string]$Executable, [Parameter(Mandatory=$true)][string]$FixtureDirectory)
$ErrorActionPreference='Stop'
$Executable=(Resolve-Path -LiteralPath $Executable).Path
$fixtureRoot=[IO.Path]::GetFullPath($FixtureDirectory)
New-Item -ItemType Directory -Path "$fixtureRoot/User/Prog" -Force | Out-Null
$valid="[PARAMETRI01]`nN3 LX=2800 LY=2100 LZ=18`nN6 P_LBL_N=0`n[CONTORNATURA01]`nN9 X100 Y200 L=PON`nN12 G1 X120 Y220`nN15 L=POFF"
$cases=@(
    @{Name='valid';Text=$valid;Exit=0},
    @{Name='arc-rejected';Text=$valid.Replace('G1','G2');Exit=40},
    @{Name='macro-rejected';Text=$valid.Replace('L=PON','L=UNKNOWN');Exit=40},
    @{Name='expression-rejected';Text=$valid.Replace('X120','XVAR');Exit=40},
    @{Name='range-rejected';Text=$valid.Replace('X120','X9000');Exit=40},
    @{Name='label-count-rejected';Text=$valid.Replace('P_LBL_N=0','P_LBL_N=1');Exit=40}
)
foreach($case in $cases) {
    [IO.File]::WriteAllText("$fixtureRoot/User/Prog/test.pcni",$case.Text)
    $process=Start-Process -FilePath $Executable -ArgumentList @('--pcni-test','--machine-data',('"'+$fixtureRoot+'"')) -WindowStyle Hidden -Wait -PassThru
    if($process.ExitCode -ne $case.Exit) {throw "$($case.Name): unexpected exit $($process.ExitCode)"}
    Write-Output "PASS $($case.Name)"
}
