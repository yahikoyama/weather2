# ================================
# historidal_html_daily.ps1（完全版）
# ================================

function HtmlEncode {
    param([string]$text)
    $text = $text -replace '&', '&amp;'
    $text = $text -replace '<', '&lt;'
    $text = $text -replace '>', '&gt;'
    $text = $text -replace '"', '&quot;'
    $text = $text -replace "'", '&#39;'
    return $text
}

function ReadFileSafe {
    param([string]$path)

    try { return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8) } catch {}
    try { return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::GetEncoding("shift_jis")) } catch {}

    try {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        if ($bytes.Length -ge 3 -and
            $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
            return [System.Text.Encoding]::UTF8.GetString($bytes)
        }
        return [System.Text.Encoding]::GetEncoding("shift_jis").GetString($bytes)
    } catch {
        Write-Warning "読み込み失敗: $path"
        return ""
    }
}

# ★ US 固定の国コード辞書
$manualCountryMap = @{
    "ウットキアグビク（バロウ）" = "US"
    "ホノルル（ハワイ）"         = "US"
}

# -----------------------------------------
# Daily → 国コード辞書作成 + テーブル整形
# -----------------------------------------
function ConvertDailyToHtmlTable {
    param([string]$content)

    $lines = $content -split "`r?`n"

    $jpRows     = @()
    $worldRows  = @()
    $countryMap = @{}   # weekly 用の国コード辞書

    foreach ($line in $lines) {

        if ($line -match "^\s*(\S+)\s+([\d\.]+)\s+([\d\.]+)\s+(.+?)(?:\s+(US|GL|SJ|NO|CA|RU|MN|AU|PE|BR|MY|CN|KR))?\s+([\d\.]+)\s+(.+)$") {

            $place   = $matches[1]
            $temp    = $matches[2]
            $hum     = $matches[3]
            $weather = $matches[4]
            $country = $matches[5]
            $di      = $matches[6]
            $eval    = $matches[7]

            # ★ daily に国コードがない場合でも US 固定を適用
            if (-not $country -and $manualCountryMap.ContainsKey($place)) {
                $country = $manualCountryMap[$place]
            }

            $row = @{
                place   = $place
                temp    = $temp
                hum     = $hum
                weather = $weather
                country = $country
                di      = $di
                eval    = $eval
            }

            if ($country) {
                $worldRows += $row
                $countryMap[$place] = $country   # weekly 用辞書にも登録
            } else {
                $jpRows += $row
            }
        }
    }

    return @{
        jpTable    = $jpRows
        worldTable = $worldRows
        countryMap = $countryMap
    }
}

# -----------------------------------------
# Weekly → 国コード付与して整形
# -----------------------------------------
function ConvertWeeklyToHtmlTable {
    param(
        [string]$content,
        [hashtable]$countryMap
    )

    $lines = $content -split "`r?`n"

    $jpRows    = @()
    $worldRows = @()

    $mode = ""

    foreach ($line in $lines) {

        if ($line -match "【国内") { $mode = "JP";     continue }
        if ($line -match "【海外") { $mode = "WORLD";  continue }

        if ($line -match "^\s*(.+?)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)\s+(.+)$") {

            $place = $matches[1]
            $temp  = $matches[2]
            $hum   = $matches[3]
            $di    = $matches[4]
            $eval  = $matches[5]

            # ★ weekly 側でも US 固定を適用
            $country = $null
            if ($countryMap.ContainsKey($place)) {
                $country = $countryMap[$place]
            } elseif ($manualCountryMap.ContainsKey($place)) {
                $country = $manualCountryMap[$place]
            }

            $row = @{
                place   = $place
                country = $country
                temp    = $temp
                hum     = $hum
                di      = $di
                eval    = $eval
            }

            if ($mode -eq "JP") {
                $jpRows += $row
            } elseif ($mode -eq "WORLD") {
                $worldRows += $row
            }
        }
    }

    return @{
        jpTable    = $jpRows
        worldTable = $worldRows
    }
}

# ================================
# Part2：Daily HTML 出力
# ================================

$baseDir = "C:\Users\winserverroot\OneDrive\Historical"
$outDir  = Join-Path $baseDir "html"

if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}

$dailyFiles = Get-ChildItem -Path $baseDir -Filter "jp_result_mail_*.txt" | Sort-Object Name

foreach ($file in $dailyFiles) {

    if ($file.BaseName -match "jp_result_mail_(\d{8})") {
        $date = $matches[1]
    } else { continue }

    $outFile = Join-Path $outDir ("historical_{0}.html" -f $date)
    if (Test-Path $outFile) { continue }

    $content = ReadFileSafe $file.FullName
    if ([string]::IsNullOrWhiteSpace($content)) { continue }

    $tables = ConvertDailyToHtmlTable $content

    $jpHtml = ""
    foreach ($r in $tables.jpTable) {
        $jpHtml += "<tr><td>$($r.place)</td><td class='num'>$($r.temp)</td><td class='num'>$($r.hum)</td><td>$($r.weather)</td><td class='num'>$($r.di)</td><td>$($r.eval)</td></tr>"
    }

    $worldHtml = ""
    foreach ($r in $tables.worldTable) {
        $worldHtml += "<tr><td>$($r.place)</td><td>$($r.country)</td><td class='num'>$($r.temp)</td><td class='num'>$($r.hum)</td><td>$($r.weather)</td><td class='num'>$($r.di)</td><td>$($r.eval)</td></tr>"
    }

    $html = @"
<!DOCTYPE html>
<html lang='ja'>
<head>
<meta charset='UTF-8'>
<title>Historical $date</title>
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
<h1>Daily 気象レポート（$date）</h1>

<h2>国内（JP）</h2>
<table>
<thead>
<tr>
<th>地名</th><th class='num'>温度</th><th class='num'>湿度</th><th>天気</th><th class='num'>不快指数</th><th>評価</th>
</tr>
</thead>
<tbody>
$jpHtml
</tbody>
</table>

<h2>海外（NOT JP）</h2>
<table>
<thead>
<tr>
<th>地名</th><th>国</th><th class='num'>温度</th><th class='num'>湿度</th><th>天気</th><th class='num'>不快指数</th><th>評価</th>
</tr>
</thead>
<tbody>
$worldHtml
</tbody>
</table>

</div>
</body>
</html>
"@

    $html | Set-Content -Path $outFile -Encoding UTF8
}

# ================================
# Part3：Weekly HTML 出力（国コード付与版）
# ================================

$weeklyFiles = Get-ChildItem -Path $baseDir -Filter "weekly_*.txt" | Sort-Object Name

foreach ($file in $weeklyFiles) {

    if ($file.BaseName -match "weekly_(\d{8})_(\d{8})") {
        $start = $matches[1]
        $end   = $matches[2]
    } else { continue }

    $outFile = Join-Path $outDir ("weekly_{0}_{1}.html" -f $start, $end)
    if (Test-Path $outFile) { continue }

    $content = ReadFileSafe $file.FullName
    if ([string]::IsNullOrWhiteSpace($content)) { continue }

    # daily の国コード辞書を取得
    $dailyFile = Get-ChildItem -Path $baseDir -Filter "jp_result_mail_$start.txt" -ErrorAction SilentlyContinue
    if (-not $dailyFile) { continue }

    $dailyTables = ConvertDailyToHtmlTable (ReadFileSafe $dailyFile.FullName)
    $countryMap  = $dailyTables.countryMap

    $tables = ConvertWeeklyToHtmlTable $content $countryMap

    $jpHtml = ""
    foreach ($r in $tables.jpTable) {
        $jpHtml += "<tr><td>$($r.place)</td><td class='num'>$($r.temp)</td><td class='num'>$($r.hum)</td><td class='num'>$($r.di)</td><td>$($r.eval)</td></tr>"
    }

    $worldHtml = ""
    foreach ($r in $tables.worldTable) {
        $worldHtml += "<tr><td>$($r.place)</td><td>$($r.country)</td><td class='num'>$($r.temp)</td><td class='num'>$($r.hum)</td><td class='num'>$($r.di)</td><td>$($r.eval)</td></tr>"
    }

    $html = @"
<!DOCTYPE html>
<html lang='ja'>
<head>
<meta charset='UTF-8'>
<title>Weekly $start-$end</title>
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
<h1>Weekly 平均気温・湿度レポート（$start〜$end）</h1>

<h2>国内（JP）</h2>
<table>
<thead>
<tr>
<th>地名</th><th class='num'>AvgTemp</th><th class='num'>AvgHum</th><th class='num'>DI</th><th>評価</th>
</tr>
</thead>
<tbody>
$jpHtml
</tbody>
</table>

<h2>海外（NOT JP）</h2>
<table>
<thead>
<tr>
<th>地名</th><th>国</th><th class='num'>AvgTemp</th><th class='num'>AvgHum</th><th class='num'>DI</th><th>評価</th>
</tr>
</thead>
<tbody>
$worldHtml
</tbody>
</table>

</div>
</body>
</html>
"@

    $html | Set-Content -Path $outFile -Encoding UTF8
}
