# ============================================
# historical_sitemap_sync.ps1（GitHub仕様完全準拠版）
# ============================================

function HtmlEncode {
    param([string]$text)
    $text = $text -replace '&', '&amp;'
    $text = $text -replace '<', '&lt;'
    $text = $text -replace '>', '&gt;'
    $text = $text -replace '"', '&quot;'
    $text = $text -replace "'", '&#39;'
    return $text
}

# --------------------------------------------
# GitHub Token 読み込み
# --------------------------------------------
$configPath = "C:\weather\config\sync.json"
$config = Get-Content -Raw $configPath | ConvertFrom-Json
$token = $config.token

# GitHub 情報
$repoOwner = "yahikoyama"
$repoName  = "weather2"
$branch    = "main"
$targetPath = "sitemap.xml"

# ローカルフォルダ
$baseDir = "C:\Users\winserverroot\OneDrive\Historical"
$htmlDir = Join-Path $baseDir "html"
$sitemapPath = Join-Path $htmlDir "sitemap.xml"

# --------------------------------------------
# weekly_*.txt → weekly_*.html
# --------------------------------------------
$weeklyTxtFiles = Get-ChildItem -Path $baseDir -Filter "weekly_*.txt"

foreach ($file in $weeklyTxtFiles) {
    if ($file.BaseName -match "weekly_(\d{8})_(\d{8})") {
        $start = $matches[1]
        $end   = $matches[2]
    } else { continue }

    $outFile = Join-Path $htmlDir ("weekly_{0}_{1}.html" -f $start, $end)
    if (Test-Path $outFile) { continue }

    $content = Get-Content -Path $file.FullName -Raw
    $encoded = HtmlEncode $content

@"
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>Weekly $start-$end</title>
<style>
body { font-family: Consolas, "Meiryo", sans-serif; white-space: pre-wrap; line-height: 1.5; margin: 20px; }
</style>
</head>
<body>
$encoded
</body>
</html>
"@ | Set-Content -Path $outFile -Encoding UTF8
}

# --------------------------------------------
# historical_*.html + weekly_*.html をソート
# --------------------------------------------
$historicalFiles = Get-ChildItem -Path $htmlDir -Filter "historical_*.html"
$weeklyFiles     = Get-ChildItem -Path $htmlDir -Filter "weekly_*.html"

$allEntries = @()

foreach ($file in $historicalFiles) {
    if ($file.BaseName -match "historical_(\d{8})") {
        $allEntries += [PSCustomObject]@{
            Type = "historical"
            File = $file
            SortKey = $matches[1]
        }
    }
}

foreach ($file in $weeklyFiles) {
    if ($file.BaseName -match "weekly_(\d{8})_(\d{8})") {
        $allEntries += [PSCustomObject]@{
            Type = "weekly"
            File = $file
            SortKey = $matches[1]
        }
    }
}

$sortedEntries = $allEntries | Sort-Object SortKey

# --------------------------------------------
# sitemap.xml 生成
# --------------------------------------------
$baseUrl = "https://yahikoyama.github.io/weather2"

$xml = @()
$xml += '<?xml version="1.0" encoding="UTF-8"?>'
$xml += '<urlset xmlns="http://sitemaps.org">'
$xml += '  <url>'
$xml += "    <loc>$baseUrl/</loc>"
$xml += '    <priority>1.0</priority>'
$xml += '  </url>'

foreach ($entry in $sortedEntries) {
    $name = $entry.File.Name
    $url  = "$baseUrl/Historical/$name"
    $priority = if ($entry.Type -eq "weekly") { "0.6" } else { "0.5" }

    $xml += '  <url>'
    $xml += "    <loc>$url</loc>"
    $xml += "    <priority>$priority</priority>"
    $xml += '  </url>'
}

$xml += '</urlset>'

$xml | Set-Content -Path $sitemapPath -Encoding UTF8

Write-Host "ローカル sitemap.xml（ソート済み）を生成しました。" -ForegroundColor Cyan

# --------------------------------------------
# OneDrive対策：ローカルに一時コピーしてから読み込む
# --------------------------------------------
$tempPath = "C:\weather\temp_sitemap.xml"
Copy-Item $sitemapPath $tempPath -Force

$localContent = Get-Content $tempPath -Raw

if (-not $localContent) {
    Write-Host "ローカル sitemap.xml の読み込みに失敗しました。" -ForegroundColor Red
    exit 1
}

# --------------------------------------------
# GitHub の sitemap.xml を取得
# --------------------------------------------
$apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/contents/$targetPath?ref=$branch"

try {
    $remote = Invoke-RestMethod -Uri $apiUrl -Headers @{ Authorization = "token $token" }
    $remoteBase64 = $remote.content
    $remoteSha    = $remote.sha
    Write-Host "GitHub 上の sitemap.xml を取得しました。" -ForegroundColor Cyan
}
catch {
    Write-Host "GitHub 上に sitemap.xml が存在しません（新規作成）。" -ForegroundColor Yellow
    $remoteBase64 = ""
    $remoteSha    = $null
}

# --------------------------------------------
# 差分チェック（Base64比較 → 最も確実）
# --------------------------------------------
$localBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($localContent))

if ($localBase64 -eq $remoteBase64) {
    Write-Host "差分なし → アップロード不要" -ForegroundColor Green
    exit 0
}

Write-Host "差分あり → GitHub にアップロードします" -ForegroundColor Magenta

# --------------------------------------------
# PUT アップロード（SHA 必須 → GitHub仕様）
# --------------------------------------------
$body = @{
    message = "update sitemap.xml"
    content = $localBase64
    branch  = $branch
}

if ($remoteSha) {
    $body.sha = $remoteSha
}

$json = $body | ConvertTo-Json -Depth 10

$result = Invoke-RestMethod -Uri $apiUrl -Method PUT -Headers @{ Authorization = "token $token" } -Body $json

Write-Host "=== GitHub へ sitemap.xml をアップロード完了 ===" -ForegroundColor Green
Write-Host "URL: https://github.com/$repoOwner/$repoName/blob/$branch/$targetPath"

# --------------------------------------------
# weekly HTML を GitHub の Historical/ にアップロード
# --------------------------------------------
Write-Host "weekly HTML を GitHub にアップロードします..." -ForegroundColor Cyan

$weeklyHtmlFiles = Get-ChildItem -Path $htmlDir -Filter "weekly_*.html"

foreach ($file in $weeklyHtmlFiles) {

    $fileName = $file.Name
    $githubPath = "Historical/$fileName"
    $apiUrlWeekly = "https://api.github.com/repos/$repoOwner/$repoName/contents/$githubPath?ref=$branch"

    # ローカルファイル読み込み
    $contentRaw = Get-Content -Path $file.FullName -Raw
    $contentBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($contentRaw))

    # GitHub 上のファイル確認
    $remoteShaWeekly = $null
    try {
        $remoteWeekly = Invoke-RestMethod -Uri $apiUrlWeekly -Headers @{ Authorization = "token $token" }
        $remoteShaWeekly = $remoteWeekly.sha
        Write-Host "$fileName は GitHub 上に存在 → 更新します" -ForegroundColor Yellow
    }
    catch {
        Write-Host "$fileName は GitHub 上に存在しません → 新規作成します" -ForegroundColor Magenta
    }

    # PUT ボディ
    $bodyWeekly = @{
        message = "update $fileName"
        content = $contentBase64
        branch  = $branch
    }

    if ($remoteShaWeekly) {
        $bodyWeekly.sha = $remoteShaWeekly
    }

    $jsonWeekly = $bodyWeekly | ConvertTo-Json -Depth 10

    # アップロード
    $resultWeekly = Invoke-RestMethod -Uri $apiUrlWeekly -Method PUT -Headers @{ Authorization = "token $token" } -Body $jsonWeekly

    Write-Host "$fileName をアップロードしました。" -ForegroundColor Green
}

Write-Host "=== weekly HTML の GitHub アップロード完了 ===" -ForegroundColor Cyan
