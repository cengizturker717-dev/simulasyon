param([switch]$LimitToTwoCpus)
$ErrorActionPreference='Stop'
$appPath=Join-Path $PSScriptRoot 'app\SolidSimNative.exe'
$reportPath=Join-Path $PSScriptRoot 'Kontrol-Testi-Sonucu.txt'
$machiningPath=Join-Path $PSScriptRoot 'Isleme-Testi-Sonucu.txt'
$stockPath=Join-Path $PSScriptRoot 'Kesim-Performansi.txt'
$report=[Collections.Generic.List[string]]::new()
$report.Add('SOLIDSIM NATIVE KONTROL BILGISAYARI TESTI')
$report.Add('Tarih: '+(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
$oldBackend=$env:QSG_RHI_BACKEND
$results=@()
$resultCode=2
function Run-App([string[]]$arguments) {
    $process=Start-Process -FilePath $appPath -ArgumentList $arguments -PassThru
    if($LimitToTwoCpus -and -not $process.HasExited) {
        $available=$process.ProcessorAffinity.ToInt64()
        [long]$selected=0
        $count=0
        for($bit=0;$bit -lt 62 -and $count -lt 2;$bit++) {
            [long]$mask=[long]1 -shl $bit
            if($available -band $mask){$selected=$selected -bor $mask;$count++}
        }
        $process.ProcessorAffinity=[IntPtr]$selected
    }
    $process.WaitForExit()
    return $process.ExitCode
}
function Read-Metrics($path) {
    $values=@{}
    foreach($line in Get-Content -LiteralPath $path) {
        $key,$value=$line -split '=',2
        if($value){$values[$key]=[double]::Parse($value,[Globalization.CultureInfo]::InvariantCulture)}
    }
    return $values
}
try {
    if(-not (Test-Path -LiteralPath $appPath)){throw 'Uygulama bulunamadi.'}
    Write-Host '[1/8] Program mantigi kontrol ediliyor...'
    if($LimitToTwoCpus){$report.Add('Yerel stres testi: uygulama iki mantiksal islemciye sinirli.')}
    $logic=Run-App -arguments @('--self-test')
    $report.Add('Program testi: '+$logic)
    Write-Host '[2/8] Kesim modeli kontrol ediliyor...'
    $stock=Run-App -arguments @('--stock-test')
    $report.Add('Kesim modeli testi: '+$stock)
    Write-Host '[3/8] Plaka, PRF / Z / ZI ve matkap cevrimleri kontrol ediliyor...'
    $machining=Run-App -arguments @('--machining-test',('"'+$machiningPath+'"'))
    $report.Add('Program isleme testi: '+$machining)
    if(Test-Path -LiteralPath $machiningPath){$report.AddRange([string[]](Get-Content -LiteralPath $machiningPath))}
    Write-Host '[4/8] Tam boy plaka ve kesim yuzeyi dogrulaniyor...'
    $surface=Run-App -arguments @('--stock-performance-test',('"'+$stockPath+'"'))
    $report.Add('Kesim yuzeyi / yuk testi: '+$surface)
    if(Test-Path -LiteralPath $stockPath){$report.AddRange([string[]](Get-Content -LiteralPath $stockPath))}
    $step=5
    foreach($backend in @('d3d11','opengl')) {
        $runs=@()
        foreach($cutting in @($false,$true)) {
            Write-Host "[$step/8] $backend hareket / kesim=$cutting olculuyor. Pencereyi kapatmayin..."
            $step++
            $path=Join-Path $env:TEMP ('SolidSim-'+[guid]::NewGuid().ToString('N')+'.txt')
            $env:QSG_RHI_BACKEND=$backend
            $arguments=@('--benchmark',('"'+$path+'"'))
            if($cutting){$arguments+='--benchmark-stock'}
            try {
                $code=Run-App -arguments $arguments
                $report.Add('')
                $report.Add("Surucu=$backend kesim=$cutting kod=$code")
                if($code -eq 0 -and (Test-Path -LiteralPath $path)) {
                    $metrics=Read-Metrics $path
                    $report.AddRange([string[]](Get-Content -LiteralPath $path))
                    $runs+=,$metrics
                }
            } finally {
                if(Test-Path -LiteralPath $path){Remove-Item -LiteralPath $path}
            }
        }
        if($runs.Count -eq 2) {
            $fps=[math]::Min($runs[0].avg_fps,$runs[1].avg_fps)
            $p95=[math]::Max($runs[0].p95_ms,$runs[1].p95_ms)
            $stalls=[math]::Max($runs[0].frames_over_100ms/$runs[0].frames,$runs[1].frames_over_100ms/$runs[1].frames)
            $results+=@{backend=$backend;fps=$fps;p95=$p95;stalls=$stalls;compatible=($fps -ge 24 -and $p95 -le 75 -and $stalls -le .02)}
        }
    }
    # Prefer frame-time stability when compatible backends are within 5% in
    # throughput; a tiny FPS difference can be normal measurement variation.
    $compatible=@($results | Where-Object {$_.compatible})
    if($compatible.Count -gt 0) {
        $fastest=($compatible | Sort-Object @{Expression={$_.fps};Descending=$true} | Select-Object -First 1).fps
        $best=$compatible | Where-Object {$_.fps -ge $fastest*.95} |
            Sort-Object @{Expression={$_.p95};Descending=$false},@{Expression={$_.stalls};Descending=$false},@{Expression={$_.fps};Descending=$true} |
            Select-Object -First 1
    } else {
        $best=$results | Sort-Object @{Expression={$_.fps};Descending=$true},@{Expression={$_.p95};Descending=$false} | Select-Object -First 1
    }
    $report.Add('')
    if($best) {
        Set-Content -LiteralPath (Join-Path $PSScriptRoot 'render-backend.txt') -Encoding Ascii -Value $best.backend
        $report.Add('Secilen surucu: '+$best.backend)
        $report.Add('Hareket ve kesimde en dusuk FPS: '+$best.fps.ToString('F2',[Globalization.CultureInfo]::InvariantCulture))
        $report.Add('Hareket ve kesimde en yuksek p95 ms: '+$best.p95.ToString('F2',[Globalization.CultureInfo]::InvariantCulture))
    }
    if($logic -ne 0 -or $stock -ne 0 -or $machining -ne 0 -or $surface -ne 0 -or -not $best) {
        $report.Add('SONUC: BASARISIZ - program veya kesim testlerinden biri gecemedi.')
    } elseif($best.fps -ge 24 -and $best.p95 -le 75 -and $best.stalls -le .02) {
        $report.Add('SONUC: UYUMLU - hareket ve kesim yukunde performans yeterli.')
        $resultCode=0
    } elseif($best.fps -ge 12) {
        $report.Add('SONUC: SINIRDA - bu bilgisayarda akicilik hedefi saglanamadi.')
        $resultCode=1
    } else {
        $report.Add('SONUC: YETERSIZ - bu ekran surucusu ile akicilik hedefi saglanamadi.')
    }
} catch {
    $report.Add('SONUC: BASARISIZ - '+$_.Exception.Message)
} finally {
    $env:QSG_RHI_BACKEND=$oldBackend
    [IO.File]::WriteAllLines($reportPath,$report,[Text.UTF8Encoding]::new($false))
}
Get-Content -LiteralPath $reportPath
Write-Host ('Sonuc dosyasi: '+$reportPath)
exit $resultCode
