param([Parameter(Mandatory=$true)][string]$Output)
$ErrorActionPreference='Stop'
$compiler="$env:WINDIR\Microsoft.NET\Framework\v4.0.30319\csc.exe"
$cniBin='C:\CNI\Ncone\CnData\Bin'
$source=(Resolve-Path -LiteralPath "$PSScriptRoot\..\CniTelemetry.cs").Path
$arguments=@('/nologo','/platform:x86',('/out:'+([IO.Path]::GetFullPath($Output))))
foreach($assembly in @('SharedAxCs.dll','ServDtmCs.dll','ScambioPlcCs.dll')) {
    $path=Join-Path $cniBin $assembly
    if(!(Test-Path -LiteralPath $path)) {throw "CNI assembly not found: $assembly"}
    $arguments+=('/r:'+$path)
}
& $compiler @arguments $source
if($LASTEXITCODE -ne 0){throw 'Telemetry build failed'}
