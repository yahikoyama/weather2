# ============================================
# historical_sync.ps1
# Historical txt → html 生成 → GitHub Historical フォルダへアップロード
# ============================================

# 設定ファイル
$configPath = "C:\weather\config\sync.json"

if (-not (Test-Path $configPath)) {
    Write-Host "設定ファイルが見つかりません: $configPath" -ForegroundColor Red
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json
$token = $config.token

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "設定ファイルに token がありません。" -ForegroundColor Red
    exit 1
}

# GitHub リポジトリ設定
$repo   = "yahikoyama/weather2"
$branch = "main"

# ローカルパス
$baseDir = "C:\Users\winserverroot\OneDrive\Historical"
$outDir  = Join-Path $baseDir "html"

# 出力フォルダが無ければ作成
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}

# -----------------------------------------
# HTML エンコード関数
# -----------------------------------------
function HtmlEncode {
    param([string]$text)

    $text = $text -replace '&', '&amp;'
    $text = $text -replace '<', '&lt;'
    $text = $text -replace '>', '&gt;'
    $text = $text -replace '"', '&quot;'
    $text = $text -replace "'", '&#39;'

    return $text
}

# -----------------------------------------
# OneDrive ロック対策付き読み込み
# -----------------------------------------
function ReadFileSafe {
    param([string]$path)

    try { return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8) } catch {}
    try { return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::GetEncoding("shift_jis")) } catch {}

    try {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        return [System.Text.Encoding]::UTF8.GetString($bytes)
    } catch {
        Write-Warning "読み込み失敗: $path"
        return ""
    }
}

# -----------------------------------------
# Historical txt → html 生成
# -----------------------------------------
$srcFiles = Get-ChildItem -Path $baseDir -Filter "jp_result_mail_*.txt"

foreach ($file in $srcFiles) {

    if ($file.BaseName -match "jp_result_mail_(\d{8})") {
        $date = $matches[1]
    } else {
        Write-Warning "日付抽出できません: $($file.Name)"
        continue
    }

    $outFile = Join-Path $outDir ("historical_{0}.html" -f $date)

    # 既にローカル HTML があるなら生成スキップ
    if (Test-Path $outFile) {
        Write-Host "ローカル HTML 既存のため生成スキップ: $outFile"
    } else {
        $content = ReadFileSafe $file.FullName

        if ([string]::IsNullOrWhiteSpace($content)) {
            Write-Warning "内容が空のためスキップ: $($file.Name)"
            continue
        }

        $encoded = HtmlEncode $content

        $html = @"
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Historical $date</title>
    <style>
        body {
            font-family: Consolas, "Meiryo", sans-serif;
            white-space: pre-wrap;
            line-height: 1.5;
            margin: 20px;
        }
    </style>
</head>
<body>
$encoded
</body>
</html>
"@

        $html | Set-Content -Path $outFile -Encoding UTF8
        Write-Host "ローカル HTML 生成完了: $outFile"
    }

    # -----------------------------------------
    # GitHub Historical フォルダへアップロード
    # -----------------------------------------
    $githubPath = "Historical/historical_$date.html"
    $githubUrl  = "https://api.github.com/repos/$repo/contents/$githubPath"

    # ローカル HTML を Base64 化
    $htmlRaw = Get-Content $outFile -Raw -Encoding UTF8
    $bytes   = [System.Text.Encoding]::UTF8.GetBytes($htmlRaw)
    $base64  = [Convert]::ToBase64String($bytes)

    # GitHub の既存ファイル取得
    $existing = $null
    try {
        $existing = Invoke-RestMethod -Uri $githubUrl -Method Get -Headers @{Authorization = "token $token"}
    } catch {
        Write-Host "GitHub 上に historical_$date.html はありません（新規作成扱い）" -ForegroundColor Yellow
    }

    # 差分チェック
    if ($existing -and $existing.content -eq $base64) {
        Write-Host "=== GitHub 判定: 内容が同じためアップロードしません ===" -ForegroundColor Yellow
        continue
    }

    Write-Host "=== GitHub 判定: 内容が異なるためアップロードします ===" -ForegroundColor Green

    $sha = $existing.sha

    $body = @{
        message = "Upload historical_$date.html"
        content = $base64
        branch  = $branch
    }

    if ($sha) {
        $body.sha = $sha
    }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    # PUT アップロード
    $response = Invoke-RestMethod -Uri $githubUrl -Method Put -Headers @{Authorization = "token $token"} -Body $jsonBody -ContentType "application/json"

    Write-Host "=== GitHub Historical フォルダへアップロード完了: historical_$date.html ===" -ForegroundColor Green
}

Write-Host "=== Historical 全処理完了 ===" -ForegroundColor Green
