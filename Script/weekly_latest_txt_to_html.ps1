# ============================================
# 最新週 TXT → HTML 生成（固定幅パース完全版）
# ============================================

$historyFolder = "C:\Users\winserverroot\OneDrive\Historical"
$htmlFolder    = "C:\Users\winserverroot\OneDrive\Historical\html"

if (-not (Test-Path $htmlFolder)) {
    New-Item -ItemType Directory -Path $htmlFolder | Out-Null
}

$files = Get-ChildItem -Path $historyFolder -Filter "weekly_*.txt"
if ($files.Count -eq 0) { exit }

$weeklyList = foreach ($f in $files) {
    if ($f.BaseName -match "weekly_(\d{8})_(\d{8})") {
        [PSCustomObject]@{
            File     = $f.FullName
            FromDate = [datetime]::ParseExact($matches[1], "yyyyMMdd", $null)
            ToDate   = [datetime]::ParseExact($matches[2], "yyyyMMdd", $null)
        }
    }
}

$latest = $weeklyList | Sort-Object ToDate -Descending | Select-Object -First 1

$txtPath     = $latest.File
$fromDateStr = $latest.FromDate.ToString("yyyyMMdd")
$toDateStr   = $latest.ToDate.ToString("yyyyMMdd")

$htmlPath = Join-Path $htmlFolder ("weekly_{0}_{1}.html" -f $fromDateStr, $toDateStr)
if (Test-Path $htmlPath) { exit }

$lines = Get-Content $txtPath

$jpStart  = ($lines | Select-String "【国内（JP）】").LineNumber
$notStart = ($lines | Select-String "【海外（NOT JP）】").LineNumber

$jpData    = $lines[($jpStart + 3) .. ($notStart - 2)]
$notjpData = $lines[($notStart + 3) .. ($lines.Count - 1)]

function Get-ComfortColor($level) {
    switch -Wildcard ($level) {
        "*寒くてたまらない*" { return "#d0e7ff" }
        "*寒い*"             { return "#e3f2fd" }
        "*肌寒い*"           { return "#f0f8ff" }
        "*何も感じない*"     { return "#ffffff" }
        "*快適*"             { return "#e8ffe8" }
        "*不快感出始め*"     { return "#fff4e5" }
        "*半数が不快*"       { return "#ffe8cc" }
        "*全員不快*"         { return "#ffd6d6" }
        default              { return "#ffffff" }
    }
}

# ============================================
# HTML ヒアドキュメント（行頭必須）
# ============================================

$html = @"
<!DOCTYPE html>
<html lang='ja'>
<head>
<meta charset='UTF-8'>
<title>Weekly $fromDateStr-$toDateStr</title>
<style>
body { font-family:'Helvetica Neue',Arial,Meiryo;background:#f5f7fa;padding:30px; }
.container { max-width:1000px;margin:0 auto;background:#fff;padding:25px 40px;border-radius:8px;
             box-shadow:0 4px 15px rgba(0,0,0,0.05); }
h1 { font-size:24px;color:#2c3e50;border-bottom:2px solid #3498db;padding-bottom:10px; }
h2 { font-size:18px;color:#34495e;margin-top:30px;border-left:4px solid #3498db;padding-left:8px; }
table { width:100%;border-collapse:collapse;margin-bottom:20px;font-size:14px; }
th,td { padding:10px 12px;border-bottom:1px solid #e2e8f0; }
th { background:#f8fafc;color:#475569;font-weight:600; }
.num { text-align:right;font-variant-numeric:tabular-nums; }
</style>
</head>
<body>
<div class='container'>
<h1>Weekly 平均気温・湿度レポート（$fromDateStr〜$toDateStr）</h1>
"@

# ============================================
# 国内（JP）固定幅パース（5列）
# ============================================

$html += "<h2>国内（JP）</h2><table><thead><tr>"
$html += "<th>地名</th><th class='num'>AvgTemp</th><th class='num'>AvgHum</th><th class='num'>DI</th><th>評価</th>"
$html += "</tr></thead><tbody>"

# City(15) Temp(10) Hum(10) DI(12) Level(残り)
$jpRegex = '^(.{15})\s+(.{10})\s+(.{10})\s+(\S+)\s+(.+)$'

foreach ($line in $jpData) {
    if ($line.Trim() -eq "") { continue }

    if ($line -match $jpRegex) {
        $city  = $matches[1].Trim()
        $temp  = $matches[2].Trim()
        $hum   = $matches[3].Trim()
        $di    = $matches[4].Trim()     # 数値だけ
        $level = $matches[5].Trim()     # 評価だけ

        $bg = Get-ComfortColor $level

        $html += "<tr style='background:$bg;'><td>$city</td><td class='num'>$temp</td><td class='num'>$hum</td><td class='num'>$di</td><td>$level</td></tr>"
    }
}

$html += "</tbody></table>"

# ============================================
# 海外（NOT JP）固定幅パース（6列）
# ============================================

$html += "<h2>海外（NOT JP）</h2><table><thead><tr>"
$html += "<th>地名</th><th>国</th><th class='num'>AvgTemp</th><th class='num'>AvgHum</th><th class='num'>DI</th><th>評価</th>"
$html += "</tr></thead><tbody>"

# City(15) Country(3) Temp(10) Hum(10) DI(数値) Level(残り)
$notjpRegex = '^(.{15})\s+(.{3})\s+(.{10})\s+(.{10})\s+(\S+)\s+(.+)$'

foreach ($line in $notjpData) {
    if ($line.Trim() -eq "") { continue }

    if ($line -match $notjpRegex) {
        $city    = $matches[1].Trim()
        $country = $matches[2].Trim()
        $temp    = $matches[3].Trim()
        $hum     = $matches[4].Trim()
        $di      = $matches[5].Trim()     # 数値だけ
        $level   = $matches[6].Trim()     # 評価だけ

        $bg = Get-ComfortColor $level

        $html += "<tr style='background:$bg;'><td>$city</td><td>$country</td><td class='num'>$temp</td><td class='num'>$hum</td><td class='num'>$di</td><td>$level</td></tr>"
    }
}

$html += "</tbody></table></div></body></html>"

$html | Out-File -FilePath $htmlPath -Encoding UTF8

Write-Host "HTML generated: $htmlPath"
