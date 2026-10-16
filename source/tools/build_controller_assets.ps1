param([string]$QtBin='C:\Qt\6.8.3\msvc2022_64\bin')
$ErrorActionPreference='Stop'
$workspace=(Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$project=Join-Path $workspace 'outputs\SolidSimNative'
$helper=Join-Path $workspace 'work\native-build\OptimizeControllerMeshes.exe'
if(-not (Test-Path -LiteralPath $helper)){throw 'Build the OptimizeControllerMeshes CMake target first.'}
$previousLocation=Get-Location
$previousPythonPath=$env:PYTHONPATH
$previousPath=$env:PATH
$previousEncoding=$env:PYTHONIOENCODING
function Invoke-Checked([string]$executable,[string[]]$arguments) {
    & $executable @arguments
    if($LASTEXITCODE -ne 0){throw "$executable failed with exit code $LASTEXITCODE"}
}
try {
    Set-Location -LiteralPath $workspace
    $env:PYTHONIOENCODING='utf-8'
    $env:PYTHONPATH=(Join-Path $project 'work\mesh-tools')+';'+$previousPythonPath
    $env:PATH=$QtBin+';'+$previousPath
    Invoke-Checked 'python' @((Join-Path $PSScriptRoot 'prepare_vigor.py'))
    $catalog=Join-Path $project 'assets\VigorCatalog.glb'
    Invoke-Checked 'python' @((Join-Path $PSScriptRoot 'merge_controller_groups.py'),$catalog,$catalog,'.35','true')
    Invoke-Checked 'python' @((Join-Path $PSScriptRoot 'clean_bracket.py'))
    Invoke-Checked (Join-Path $QtBin 'balsam.exe') @('-o',(Join-Path $project 'assets\catalog'),$catalog)
    Invoke-Checked (Join-Path $QtBin 'balsam.exe') @('-o',(Join-Path $project 'assets\catalog\cleanedstatic'),(Join-Path $workspace 'work\CleanStatic.glb'))
    Invoke-Checked 'python' @((Join-Path $PSScriptRoot 'bind_vigor.py'))
    Invoke-Checked 'python' @((Join-Path $PSScriptRoot 'simplify_vigor.py'))
    Invoke-Checked $helper @((Join-Path $project 'assets\catalog\VigorLite.qml'))
} finally {
    Set-Location -LiteralPath $previousLocation.Path
    $env:PYTHONPATH=$previousPythonPath
    $env:PATH=$previousPath
    $env:PYTHONIOENCODING=$previousEncoding
}
