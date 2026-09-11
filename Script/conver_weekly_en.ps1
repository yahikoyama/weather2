# ==========================================
# conver_weekly_en.ps1（完全版）
# ==========================================

$srcDir   = "C:\Users\winserverroot\OneDrive\Historical\html"
$dstDir   = "C:\Users\winserverroot\OneDrive\Historical_en"
$dictPath = "C:\weather\config\dictionary.json"
$syncPath = "C:\weather\config\sync.json"

# GitHub 設定
$repo         = "yahikoyama/weather2"
$branch       = "main"
$githubFolder = "Historical_en"

# token 読み込み
$sync  = Get-Content $syncPath -Raw | ConvertFrom-Json
$token = $sync.token

# 出力フォルダがなければ作成
if (-not (Test-Path $dstDir)) {
    New-Item -Path $dstDir -ItemType Directory -Force | Out-Null
}

# 辞書読み込み（UTF-8）
$dictBytes = [System.IO.File]::ReadAllBytes($dictPath)
$dictText  = [System.Text.Encoding]::UTF8.GetString($dictBytes)
$dict      = $dictText | ConvertFrom-Json

$placeMap   = $dict.place
$weatherMap = $dict.weather
$feelingMap = $dict.feeling
$labelMap   = $dict.labels

# ------------------------------------------
# HTML 内の日本語を辞書で英語化＋ヘッダー左寄せ
# ------------------------------------------
function ConvertHtmlToEnglish {
    param([string]$content)

    foreach ($jp in $labelMap.PSObject.Properties.Name) {
        $content = $content -replace [regex]::Escape($jp), $labelMap.$jp
    }
    foreach ($jp in $feelingMap.PSObject.Properties.Name) {
        $content = $content -replace [regex]::Escape($jp), $feelingMap.$jp
    }
    foreach ($jp in $weatherMap.PSObject.Properties.Name) {
        $content = $content -replace [regex]::Escape($jp), $weatherMap.$jp
    }
    foreach ($jp in $placeMap.PSObject.Properties.Name) {
        $content = $content -replace [regex]::Escape($jp), $placeMap.$jp
    }

    # Location / Evaluation ヘッダーだけ左寄せ
    $content = $content -replace "<th>Location</th>",   "<th class='left'>Location</th>"
    $content = $content -replace "<th>Evaluation</th>", "<th class='left'>Evaluation</th>"

    return $content
}

# ------------------------------------------
# GitHub アップロード関数
# ------------------------------------------
function Upload-ToGitHub {
    param(
        [string]$localPath,
        [string]$remotePath
    )

    $url = "https://api.github.com/repos/$repo/contents/$remotePath"
    $sha = $null

    try {
        $existing = Invoke-RestMethod -Uri $url -Method Get -Headers @{ Authorization = "token $token" }
        $sha = $existing.sha
    } catch {
        # 新規の場合は 404 になるので無視
    }

    $raw    = Get-Content $localPath -Raw -Encoding UTF8
    $bytes  = [System.Text.Encoding]::UTF8.GetBytes($raw)
    $base64 = [Convert]::ToBase64String($bytes)

    $body = @{
        message = "Update $remotePath $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        content = $base64
        branch  = $branch
    }
    if ($sha) { $body.sha = $sha }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    Invoke-RestMethod -Uri $url -Method Put -Headers @{ Authorization = "token $token" } -Body $jsonBody -ContentType "application/json"
}

# ------------------------------------------
# weekly 英語版生成（20260706 以降）
# ------------------------------------------
$weeklyFiles = Get-ChildItem -Path $srcDir -Filter "weekly_*.html" |
               Where-Object {
                   $_.BaseName -match "weekly_(\d{8})_(\d{8})" -and
                   [int]$matches[1] -ge 20260706
               } |
               Sort-Object Name

foreach ($file in $weeklyFiles) {

    $outFile = Join-Path $dstDir $file.Name

    $content   = Get-Content $file.FullName -Raw -Encoding UTF8
    $contentEn = ConvertHtmlToEnglish $content

    $contentEn | Set-Content -Path $outFile -Encoding UTF8

    $remotePath = "$githubFolder/$($file.Name)"
    Upload-ToGitHub -localPath $outFile -remotePath $remotePath
}

Write-Host "英語 weekly の生成と GitHub アップロードが完了しました。" -ForegroundColor Green

# ------------------------------------------
# index.html 英語版生成（最新が一番上）
# ------------------------------------------

$indexOut = Join-Path $dstDir "index.html"

# ToDate（2つ目の日付）で降順ソート
$weeklyFilesSorted = $weeklyFiles | Sort-Object {
    if ($_.BaseName -match "weekly_(\d{8})_(\d{8})") {
        [datetime]::ParseExact($matches[2], "yyyyMMdd", $null)
    }
} -Descending

$weeklyListHtml = ""
foreach ($file in $weeklyFilesSorted) {
    $weeklyListHtml += "<li><a href='$($file.Name)'>$($file.Name)</a></li>`n"
}

$indexHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Historical Weather Reports (EN)</title>
<style>
body { font-family: Arial, Meiryo; background:#f5f7fa; padding:30px; }
.container { max-width:900px; margin:0 auto; background:#fff; padding:25px 40px;
             border-radius:8px; box-shadow:0 4px 15px rgba(0,0,0,0.05); }
h1 { font-size:24px; color:#2c3e50; border-bottom:2px solid #3498db; padding-bottom:10px; }
h2 { font-size:18px; color:#34495e; margin-top:30px; border-left:4px solid #3498db; padding-left:8px; }
ul { list-style-type:none; padding-left:0; }
li { margin:6px 0; }
a { color:#3498db; text-decoration:none; }
a:hover { text-decoration:underline; }

/* Location / Evaluation 左寄せ用 */
.left { text-align:left; }

/* 数値列は右寄せ */
.num { text-align:right; font-variant-numeric:tabular-nums; }

</style>
</head>
<body>
<div class="container">

<h1>Historical Weather Reports (English)</h1>

<h2>Weekly Reports</h2>
<ul>
$weeklyListHtml
</ul>

</div>
</body>
</html>
"@

$indexHtml | Set-Content -Path $indexOut -Encoding UTF8
Upload-ToGitHub -localPath $indexOut -remotePath "$githubFolder/index.html"

Write-Host "英語版 index.html の生成と GitHub アップロードが完了しました。" -ForegroundColor Green
