# convert_to_html.ps1
# 靖典専用・weather2 完全対応版（列数判定＋ヘッダー除外）

$dirPath = "C:\Users\winserverroot\OneDrive"
$file1 = Join-Path $dirPath "jp_result_latest.txt"
$file2 = Join-Path $dirPath "jp_result_mail.txt"
$outputFile = Join-Path $dirPath "weather_report_now.html"

# 使用する入力ファイルを決定
$inputFile = ""

if (Test-Path $file1) {
    if (Test-Path $file2) {
        $time1 = (Get-Item $file1).LastWriteTime
        $time2 = (Get-Item $file2).LastWriteTime
        
        if ($time1 -ge $time2) {
            $inputFile = $file1
            Write-Host "最新の '$file1' を使用します。" -ForegroundColor Cyan
        } else {
            $inputFile = $file2
            Write-Host "最新の '$file2' を使用します。" -ForegroundColor Cyan
        }
    } else {
        $inputFile = $file1
        Write-Host "'$file2' が見つからないため、'$file1' を使用します。" -ForegroundColor Yellow
    }
} elseif (Test-Path $file2) {
    $inputFile = $file2
    Write-Host "'$file1' が見つからないため、'$file2' を使用します。" -ForegroundColor Yellow
} else {
    Write-Error "入力ファイルがどちらも見つかりません。"
    exit
}

# ファイル内容の読み込み
$content = Get-Content $inputFile -Encoding UTF8

# 取得時間の抽出
$timestamp = ($content | Select-String "取得時間").Line

# データパース関数（列数で国内/海外を判定）
function Parse-WeatherData($lines, $startIndex) {

    $jpList = New-Object System.Collections.Generic.List[PSObject]
    $globalList = New-Object System.Collections.Generic.List[PSObject]

    for ($i = $startIndex; $i -lt $lines.Count; $i++) {

        $line = $lines[$i].Trim()

        if ($line -eq "" -or $line.StartsWith("【") -or $line.StartsWith("-")) {
            continue
        }

        # ▼ ヘッダー行の除外
        if ($line -match "温度" -or $line -match "湿度" -or $line -match "不快指数") {
            continue
        }

        # 分割（スペース・タブ・全角スペース対応）
        $parts = $line -split '[\s\u00a0]+' | Where-Object { $_ -ne "" }

        # 国内（6列）
        if ($parts.Count -eq 6) {
            $jpList.Add([PSCustomObject]@{
                Place      = $parts[0]
                Temp       = $parts[1]
                Humidity   = $parts[2]
                Weather    = $parts[3]
                Discomfort = $parts[4]
                Eval       = $parts[5]
                Country    = "-"
            })
        }

        # 海外（7列以上）
        elseif ($parts.Count -ge 7) {
            $globalList.Add([PSCustomObject]@{
                Place      = $parts[0]
                Temp       = $parts[1]
                Humidity   = $parts[2]
                Weather    = $parts[3]
                Country    = $parts[4]
                Discomfort = $parts[5]
                Eval       = ($parts[6..($parts.Count-1)] -join " ")
            })
        }
    }

    return @{ JP = $jpList; GLOBAL = $globalList }
}

# セクション位置の特定
$jpStartIndex = ($content | Select-String "【国内（JP）】").LineNumber
$notJpStartIndex = ($content | Select-String "【海外（NOTJP）】").LineNumber

$parsedJP = Parse-WeatherData $content ($jpStartIndex)
$parsedGlobal = Parse-WeatherData $content ($notJpStartIndex)

$jpData = $parsedJP.JP
$notJpData = $parsedGlobal.GLOBAL

# HTML行生成
function Get-HtmlRows ($dataList, $isGlobal) {
    $html = ""
    foreach ($row in $dataList) {

        $bgClass = ""
        if ([double]$row.Discomfort -ge 75) { $bgClass = "class='row-hot'" }
        elseif ([double]$row.Discomfort -le 50) { $bgClass = "class='row-cold'" }

        $html += "<tr $bgClass>"
        $html += "<td>$($row.Place)</td>"
        $html += "<td class='num'>$($row.Temp)</td>"
        $html += "<td class='num'>$($row.Humidity)%</td>"
        $html += "<td>$($row.Weather)</td>"

        if ($isGlobal) {
            $html += "<td class='center'>$($row.Country)</td>"
        }

        $html += "<td class='num'>$($row.Discomfort)</td>"
        $html += "<td>$($row.Eval)</td>"
        $html += "</tr>`n"
    }
    return $html
}

$jpRows = Get-HtmlRows $jpData $false
$notJpRows = Get-HtmlRows $notJpData $true

# HTMLテンプレート
$htmlContent = @"
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>天気・不快指数レポート</title>
<style>
body {
    font-family: 'Helvetica Neue', Arial, 'Hiragino Kaku Gothic ProN', 'Hiragino Sans', Meiryo, sans-serif;
    background-color: #f5f7fa;
    color: #333;
    margin: 0;
    padding: 30px;
}
.container {
    max-width: 1000px;
    margin: 0 auto;
    background: #ffffff;
    padding: 25px 40px 40px 40px;
    border-radius: 8px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
}
h1 {
    font-size: 24px;
    color: #2c3e50;
    border-bottom: 2px solid #3498db;
    padding-bottom: 10px;
    margin-bottom: 5px;
}
.timestamp {
    font-size: 13px;
    color: #7f8c8d;
    margin-bottom: 30px;
    text-align: right;
}
h2 {
    font-size: 18px;
    color: #34495e;
    margin-top: 30px;
    margin-bottom: 15px;
    padding-left: 8px;
    border-left: 4px solid #3498db;
}
table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    font-size: 14px;
}
th, td {
    padding: 10px 12px;
    text-align: left;
    border-bottom: 1px solid #e2e8f0;
}
th {
    background-color: #f8fafc;
    color: #475569;
    font-weight: 600;
}
tr:hover {
    background-color: #f8fafc;
}
.num {
    text-align: right;
    font-variant-numeric: tabular-nums;
}
.center {
    text-align: center;
}
.row-hot {
    background-color: #fff5f5;
}
.row-cold {
    background-color: #f0f7ff;
}
</style>
</head>
<body>
<div class="container">
<h1>気象・不快指数 観測レポート</h1>
<div class="timestamp">$timestamp</div>

<h2>国内（JP）</h2>
<table>
<thead>
<tr>
<th>地名</th>
<th class="num">温度(℃)</th>
<th class="num">湿度(%)</th>
<th>天気</th>
<th class="num">不快指数</th>
<th>評価</th>
</tr>
</thead>
<tbody>
$jpRows
</tbody>
</table>

<h2>海外（NOTJP）</h2>
<table>
<thead>
<tr>
<th>地名</th>
<th class="num">温度(℃)</th>
<th class="num">湿度(%)</th>
<th>天気</th>
<th class="center">国</th>
<th class="num">不快指数</th>
<th>評価</th>
</tr>
</thead>
<tbody>
$notJpRows
</tbody>
</table>

</div>
</body>
</html>
"@

# OneDrive のロック対策として WriteAllText を使用
[System.IO.File]::WriteAllText($outputFile, $htmlContent, [System.Text.Encoding]::UTF8)

Write-Host "HTMLファイルが正常に作成されました: $outputFile" -ForegroundColor Green
