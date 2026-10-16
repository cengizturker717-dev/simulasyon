Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
$script:Utf8 = New-Object Text.UTF8Encoding($false)

function Get-BytesHash([byte[]]$Bytes) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($Bytes))).Replace('-', '') }
    finally { $sha.Dispose() }
}
function Read-SharedBytes([string]$Path) {
    $stream = New-Object IO.FileStream($Path,[IO.FileMode]::Open,[IO.FileAccess]::Read,([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete))
    $copy = New-Object IO.MemoryStream
    try { $stream.CopyTo($copy); return ,$copy.ToArray() }
    finally { $copy.Dispose(); $stream.Dispose() }
}
function Write-AtomicJson([string]$Path, $Value) {
    $temp = $Path + '.tmp'
    [IO.File]::WriteAllText($temp,($Value | ConvertTo-Json -Depth 12),$script:Utf8)
    if ([IO.File]::Exists($Path)) { [IO.File]::Replace($temp,$Path,$null) }
    else { [IO.File]::Move($temp,$Path) }
}
function Convert-CutLine([string]$Line) {
    $value = $Line.Trim().TrimStart([char]0xfeff)
    if ([string]::IsNullOrWhiteSpace($value)) { return $null }
    $match = [regex]::Match($value,'^(?<date>\d{4}/\d{2}/\d{2}) \d{2}:\d{2}:\d{2}\.\d{3} - PROGRAM ADI=(?<program>.+?) \| BASLAMA SAATI=(?<start>\d{2}:\d{2}:\d{2}) \| BITIS SAATI=(?<end>\d{2}:\d{2}:\d{2}) \| SURE=(?<duration>\d+:\d{2})$')
    if ($match.Success) {
        $text = '{0} | PROGRAM ADI={1} | BASLAMA SAATI={2} | BITIS SAATI={3} | SURE={4}' -f $match.Groups['date'].Value,$match.Groups['program'].Value,$match.Groups['start'].Value,$match.Groups['end'].Value,$match.Groups['duration'].Value
    } else {
        $match = [regex]::Match($value,'^(?<date>\d{4}/\d{2}/\d{2}) \d{2}:\d{2}:\d{2}\.\d{3} - PROGRAM=(?<program>.*?); SATIR=\d+; (?:BASLANGIC=(?<start>\d{2}:\d{2}:\d{2}); )?SURE=(?<minutes>\d+) dk (?<seconds>\d+) sn(?:; BITIS=(?<end>\d{2}:\d{2}:\d{2}))?$')
        if ($match.Success) {
            $start = if ($match.Groups['start'].Success) { $match.Groups['start'].Value } else { '--:--:--' }
            $finish = if ($match.Groups['end'].Success) { $match.Groups['end'].Value } else { '--:--:--' }
            $duration = '{0}:{1:00}' -f [int]$match.Groups['minutes'].Value,[int]$match.Groups['seconds'].Value
            $text = '{0} | PROGRAM ADI={1} | BASLAMA SAATI={2} | BITIS SAATI={3} | SURE={4}' -f $match.Groups['date'].Value,$match.Groups['program'].Value,$start,$finish,$duration
        } else {
            $match = [regex]::Match($value,'^(?<date>\d{4}/\d{2}/\d{2}) \d{2}:\d{2}:\d{2}\.\d{3} - (?<message>.+)$')
            $text = if ($match.Success) { $match.Groups['date'].Value+' | '+$match.Groups['message'].Value } else { $value }
        }
    }
    $date = [regex]::Match($text,'^(?<date>\d{4}/\d{2}/\d{2}) \| ')
    if (-not $date.Success) { throw ('Tarihi taninamayan kesim kaydi; kaynak korunuyor: '+$text) }
    $parsed = [datetime]::MinValue
    if (-not [datetime]::TryParseExact($date.Groups['date'].Value,'yyyy/MM/dd',[Globalization.CultureInfo]::InvariantCulture,[Globalization.DateTimeStyles]::None,[ref]$parsed)) { throw 'Gecersiz kesim tarihi' }
    return [pscustomobject]@{ Date=$parsed.ToString('yyyy-MM-dd'); Text=$text }
}
function Convert-CutBytes([byte[]]$Bytes) {
    foreach ($line in ($script:Utf8.GetString($Bytes) -split "`r?`n")) {
        $record = Convert-CutLine $line
        if ($null -ne $record) { $record }
    }
}
function Get-RecordCounts($Records) {
    $counts = New-Object 'Collections.Generic.Dictionary[string,int]' ([StringComparer]::Ordinal)
    foreach ($record in $Records) {
        if ($counts.ContainsKey($record.Text)) { $counts[$record.Text]++ } else { $counts.Add($record.Text,1) }
    }
    return ,$counts
}
function Get-MissingRecords($Records, $Existing) {
    $available = Get-RecordCounts $Existing
    foreach ($record in $Records) {
        if ($available.ContainsKey($record.Text) -and $available[$record.Text] -gt 0) { $available[$record.Text]-- }
        else { $record }
    }
}
function Get-DailyRecords([string]$DailyRoot) {
    if (Test-Path -LiteralPath $DailyRoot) {
        foreach ($file in (Get-ChildItem -LiteralPath $DailyRoot -Filter 'KesimSureleri_????-??-??.log' -File | Sort-Object Name)) {
            Convert-CutBytes (Read-SharedBytes $file.FullName)
        }
    }
}
function Add-RecordOperations($Operations, [string]$Path, $Records) {
    if ($Records.Count -eq 0) { return }
    $bytes = if (Test-Path -LiteralPath $Path) { Read-SharedBytes $Path } else { [byte[]]@() }
    $prefix = if ($bytes.Length -gt 0 -and $bytes[-1] -ne 10) { [Environment]::NewLine } else { '' }
    $text = $prefix+(($Records | ForEach-Object {$_.Text}) -join [Environment]::NewLine)+[Environment]::NewLine
    $Operations.Add([pscustomobject]@{Path=$Path;OriginalLength=$bytes.LongLength;OriginalHash=(Get-BytesHash $bytes);Data=[Convert]::ToBase64String($script:Utf8.GetBytes($text))})
}
function Complete-CutTransaction([string]$SystemRoot, [string]$MachineRoot) {
    $pendingPath = Join-Path $SystemRoot 'pending.json'
    if (-not (Test-Path -LiteralPath $pendingPath)) { return }
    $pending = Get-Content -LiteralPath $pendingPath -Raw | ConvertFrom-Json
    $dailyRoot = Join-Path $MachineRoot 'Kesim Sureleri\Gunluk'
    $liveLog = Join-Path $MachineRoot 'Log\KesimSureleri.log'
    foreach ($operation in $pending.Operations) {
        $path = [IO.Path]::GetFullPath([string]$operation.Path)
        $parent = [IO.Path]::GetDirectoryName($path)
        if ($path -ne $liveLog -and ($parent -ne $dailyRoot -or [IO.Path]::GetFileName($path) -notmatch '^KesimSureleri_\d{4}-\d{2}-\d{2}\.log$')) { throw 'Beklenmeyen yedek hedefi' }
        $data = [Convert]::FromBase64String($operation.Data)
        $stream = New-Object IO.FileStream($path,[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::Read)
        try {
            $oldLength = [long]$operation.OriginalLength
            $written = $stream.Length-$oldLength
            if ($written -lt 0 -or $written -gt $data.LongLength) { throw ('Yedek hedefi beklenmedik sekilde degisti: '+$path) }
            $prefix = New-Object byte[] ([int]$oldLength)
            $read = 0
            while ($read -lt $prefix.Length) { $n=$stream.Read($prefix,$read,$prefix.Length-$read); if ($n -eq 0) {throw 'Eksik hedef okuma'}; $read+=$n }
            if ((Get-BytesHash $prefix) -ne $operation.OriginalHash) { throw 'Yedegin eski kayitlari degistirilmis' }
            for ($i=0; $i -lt $written; $i++) { if ($stream.ReadByte() -ne $data[$i]) { throw 'Tamamlanmamis yazma beklenen kayitla uyusmuyor' } }
            $stream.Position=$stream.Length
            $stream.Write($data,[int]$written,$data.Length-[int]$written)
            $stream.Flush($true)
        } finally { $stream.Dispose() }
    }
    Write-AtomicJson (Join-Path $SystemRoot 'state.json') $pending.State
    Remove-Item -LiteralPath $pendingPath -Force
}
