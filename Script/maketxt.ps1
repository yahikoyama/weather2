# ====== 設定部分（ここを書き換えるだけ） ======
$inputFolder  = "C:\Weather\output"     # a.txt があるフォルダ
$outputFolder = "C:\Users\winserverroot\OneDrive"    # b.txt を出力するフォルダ

$inputFile  = Join-Path $inputFolder  "jp_result.txt"
$outputFile = Join-Path $outputFolder "jp_result_mail.txt"
# ===============================================
# ★ 全角幅を考慮した文字幅計算関数
function Get-DisplayWidth($text) {
    $width = 0
    foreach ($c in $text.ToCharArray()) {
        if ([System.Text.Encoding]::GetEncoding("Shift_JIS").GetByteCount($c) -eq 2) {
            $width += 2   # 全角
        } else {
            $width += 1   # 半角
        }
    }
    return $width
}

# ★ 指定幅に合わせてパディングする関数
function Pad-Display($text, $targetWidth) {
    $current = Get-DisplayWidth $text
    $pad = $targetWidth - $current
    if ($pad -lt 0) { $pad = 0 }
    return $text + (" " * $pad)
}


# ====== 読み込み ======
$lines = Get-Content -Path $inputFile -Encoding UTF8
$outLines = @()


# ====== 取得時間 ======
$timeLine = $lines[0]
$time = $timeLine -replace '^取得時間JST\s*', ''
$outLines += "取得時間 JST: $time"
$outLines += ""


# ====== セクション位置 ======
$jpIndex    = $lines.IndexOf('【国内（JP）】')
$notjpIndex = $lines.IndexOf('【海外（NOTJP）】')


# ==========================
#   国内（JP）
# ==========================
$outLines += '【国内（JP）】'
$outLines += '地名               温度(℃)   湿度(%)   天気'
$outLines += '------------------------------------------------------'

foreach ($i in ($jpIndex + 2) .. ($notjpIndex - 2)) {

    $line = $lines[$i].Trim()
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $parts = $line.Split(',').ForEach{ $_.Trim() } | Where-Object { $_ -ne '' }

    $name    = Pad-Display $parts[0] 14
    $temp    = "{0,6:N2}" -f [double]$parts[1]
    $humid   = "{0,6}"    -f [int]$parts[2]
    $weather = Pad-Display $parts[3] 10

    $outLines += "$name  $temp   $humid   $weather"
}

$outLines += ""


# ==========================
#   海外（NOTJP）
# ==========================
$outLines += '【海外（NOTJP）】'
$outLines += '地名                       温度(℃)   湿度(%)   天気          国'
$outLines += '----------------------------------------------------------------------------'

foreach ($i in ($notjpIndex + 2) .. ($lines.Count - 1)) {

    $line = $lines[$i].Trim()
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $parts = $line.Split(',').ForEach{ $_.Trim() } | Where-Object { $_ -ne '' }

    $name    = Pad-Display $parts[0] 26
    $temp    = "{0,6:N2}" -f [double]$parts[1]
    $humid   = "{0,6}"    -f [int]$parts[2]
    $weather = Pad-Display $parts[3] 12
    $country = $parts[4]

    $outLines += "$name  $temp   $humid   $weather  $country"
}


# ====== 出力 ======
$outLines | Set-Content -Path $outputFile -Encoding UTF8

# ====== 履歴フォルダへ日付付きコピー ======
$historyFolder = "C:\Users\winserverroot\OneDrive\Historical"

# フォルダが無ければ作成
if (-not (Test-Path $historyFolder)) {
    New-Item -ItemType Directory -Path $historyFolder | Out-Null
}

# yyyymmdd 形式の日付文字列
$today = (Get-Date).ToString("yyyyMMdd")

# コピー先ファイル名
$historyFile = Join-Path $historyFolder ("_{0}.txt" -f $today)

# コピー実行
Copy-Item -Path $outputFile -Destination $historyFile -Force