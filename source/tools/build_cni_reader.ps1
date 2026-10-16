param([string]$OutputFile,[string]$CniBin='C:\CNI\Ncone\CnData\Bin')
$ErrorActionPreference='Stop'
$source=Split-Path -Parent $PSScriptRoot
if(-not $OutputFile){$OutputFile=Join-Path (Split-Path -Parent $source) 'app\CniTelemetry.exe'}
$compileArgs=@('/nologo','/platform:x86','/target:exe',('/out:'+$OutputFile))
foreach($reference in @('SharedAxCs.dll','ServDtmCs.dll','ScambioPlcCs.dll','CnAccessCs.dll')){$compileArgs+=('/reference:'+(Join-Path $CniBin $reference))}
$compileArgs+=(Join-Path $source 'CniEndpoint.cs')
$compileArgs+=(Join-Path $source 'CniTelemetry.cs')
& 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe' @compileArgs
if($LASTEXITCODE -ne 0){throw 'CNI reader compilation failed'}
