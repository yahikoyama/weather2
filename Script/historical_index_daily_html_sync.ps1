# ============================================
# index_daily.html だけ GitHub にアップロードする完全版
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

# index_daily.html のローカルパス
$indexDailyLocal = "C:\Users\winserverroot\OneDrive\Historical\html\index_daily.html"

# GitHub 上のパス
$indexDailyUrl = "https://api.github.com/repos/$repo/contents/Historical/index_daily.html"

# -----------------------------------------
# ローカル index_daily.html の存在チェック
# -----------------------------------------
if (-not (Test-Path $indexDailyLocal)) {
    Write-Host "index_daily.html が見つかりません: $indexDailyLocal" -ForegroundColor Red
    exit 1
}

# -----------------------------------------
# ローカル index_daily.html を読み込み
# -----------------------------------------
$raw = Get-Content $indexDailyLocal -Raw -Encoding UTF8
$bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)
$base64 = [Convert]::ToBase64String($bytes)

# -----------------------------------------
# GitHub の既存ファイル取得
# -----------------------------------------
$existing = $null
try {
    $existing = Invoke-RestMethod -Uri $indexDailyUrl -Method Get -Headers @{Authorization = "token $token"}
} catch {
    Write-Host "GitHub 上に index_daily.html がありません（新規作成扱い）" -ForegroundColor Yellow
}

# -----------------------------------------
# 差分チェック
# -----------------------------------------
if ($existing -and $existing.content -eq $base64) {
    Write-Host "=== index_daily.html: 内容が同じため更新しません ===" -ForegroundColor Yellow
    exit 0
}

Write-Host "=== index_daily.html: GitHub を更新します ===" -ForegroundColor Green

# -----------------------------------------
# PUT 送信内容
# -----------------------------------------
$body = @{
    message = "Update index_daily.html"
    content = $base64
    branch  = $branch
}

if ($existing.sha) {
    $body.sha = $existing.sha
}

$jsonBody = $body | ConvertTo-Json -Depth 10

# -----------------------------------------
# GitHub にアップロード
# -----------------------------------------
$response = Invoke-RestMethod -Uri $indexDailyUrl -Method Put -Headers @{Authorization = "token $token"} -Body $jsonBody -ContentType "application/json"

Write-Host "=== index_daily.html 更新完了 ===" -ForegroundColor Green
Write-Host "=== 完了 ===" -ForegroundColor Green
