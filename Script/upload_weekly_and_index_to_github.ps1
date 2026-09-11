# ============================================
# GitHub に index.html と最新 weekly をアップロード
# ============================================

# 設定ファイル（token）
$configPath = "C:\weather\config\sync.json"

if (-not (Test-Path $configPath)) {
    Write-Host "設定ファイルがありません: $configPath" -ForegroundColor Red
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json
$token  = $config.token

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "token が設定されていません。" -ForegroundColor Red
    exit 1
}

# GitHub リポジトリ設定
$repo   = "yahikoyama/weather2"
$branch = "main"

# ローカルファイルの場所
$localFolder = "C:\Users\winserverroot\OneDrive\Historical\html"
$indexLocal  = Join-Path $localFolder "index.html"

# ============================================
# 最新 weekly HTML を取得
# ============================================

$weeklyFiles = Get-ChildItem -Path $localFolder -Filter "weekly_*.html"

if ($weeklyFiles.Count -eq 0) {
    Write-Host "weekly HTML が見つかりません。" -ForegroundColor Red
    exit 1
}

$weeklyList = foreach ($f in $weeklyFiles) {
    if ($f.BaseName -match "weekly_(\d{8})_(\d{8})") {
        [PSCustomObject]@{
            FilePath = $f.FullName
            FileName = $f.Name
            FromDate = [datetime]::ParseExact($matches[1], "yyyyMMdd", $null)
            ToDate   = [datetime]::ParseExact($matches[2], "yyyyMMdd", $null)
        }
    }
}

$latest = $weeklyList | Sort-Object ToDate -Descending | Select-Object -First 1

Write-Host "最新 weekly: $($latest.FileName)" -ForegroundColor Cyan

# ============================================
# GitHub アップロード関数
# ============================================

function Upload-ToGitHub($localPath, $remotePath) {

    Write-Host "アップロード開始: $remotePath" -ForegroundColor Yellow

    $url = "https://api.github.com/repos/$repo/contents/$remotePath"

    # ローカルファイル読み込み
    $raw = Get-Content $localPath -Raw -Encoding UTF8
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)
    $base64 = [Convert]::ToBase64String($bytes)

    # 既存ファイルの SHA を取得
    $existing = $null
    try {
        $existing = Invoke-RestMethod -Uri $url -Method Get -Headers @{Authorization = "token $token"}
    } catch {
        Write-Host "GitHub 上に既存ファイルなし（新規作成）" -ForegroundColor Green
    }

    $body = @{
        message = "Update $remotePath $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        content = $base64
        branch  = $branch
    }

    if ($existing.sha) {
        $body.sha = $existing.sha
    }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    # PUT 送信
    $response = Invoke-RestMethod -Uri $url -Method Put -Headers @{Authorization = "token $token"} -Body $jsonBody -ContentType "application/json"

    Write-Host "アップロード完了: $remotePath" -ForegroundColor Green
}

# ============================================
# index.html をアップロード
# ============================================

Upload-ToGitHub -localPath $indexLocal -remotePath "Historical/index.html"

# ============================================
# 最新 weekly をアップロード
# ============================================

Upload-ToGitHub -localPath $latest.FilePath -remotePath ("Historical/" + $latest.FileName)

Write-Host "=== 完了 ===" -ForegroundColor Green
