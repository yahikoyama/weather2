# ============================================
# ローカルにある historical_YYYYMMDD.html のうち、
# GitHub に存在しないものだけアップロードする
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
$githubFolder = "Historical"

# ローカルフォルダ
$localFolder = "C:\Users\winserverroot\OneDrive\Historical\html"

# ============================================
# GitHub の Historical フォルダのファイル一覧を取得
# ============================================

$apiUrl = "https://api.github.com/repos/$repo/contents/$githubFolder"

try {
    $githubFiles = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{Authorization = "token $token"}
} catch {
    Write-Host "GitHub の Historical フォルダを取得できませんでした。" -ForegroundColor Red
    exit 1
}

# GitHub にある historical_xxx.html の一覧
$githubHistorical = $githubFiles | Where-Object { $_.name -match "^historical_\d{8}\.html$" } |
                    Select-Object -ExpandProperty name

# ============================================
# ローカルの historical_xxx.html を取得
# ============================================

$localHistoricalFiles = Get-ChildItem -Path $localFolder -Filter "historical_*.html"

if ($localHistoricalFiles.Count -eq 0) {
    Write-Host "ローカルに historical_*.html がありません。" -ForegroundColor Yellow
    exit
}

# ============================================
# GitHub に無いファイルだけ抽出
# ============================================

$missingFiles = @()

foreach ($file in $localHistoricalFiles) {
    if ($githubHistorical -notcontains $file.Name) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -eq 0) {
    Write-Host "GitHub に無い historical ファイルはありません。" -ForegroundColor Green
    exit
}

Write-Host "GitHub に無いファイル数: $($missingFiles.Count)" -ForegroundColor Cyan

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

    # 新規作成なので SHA は不要
    $body = @{
        message = "Add $remotePath $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        content = $base64
        branch  = $branch
    }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    # PUT 送信
    $response = Invoke-RestMethod -Uri $url -Method Put -Headers @{Authorization = "token $token"} -Body $jsonBody -ContentType "application/json"

    Write-Host "アップロード完了: $remotePath" -ForegroundColor Green
}

# ============================================
# GitHub に無い historical_xxx.html をアップロード
# ============================================

foreach ($file in $missingFiles) {
    $remotePath = "$githubFolder/$($file.Name)"
    Upload-ToGitHub -localPath $file.FullName -remotePath $remotePath
}

Write-Host "=== 差分アップロード完了 ===" -ForegroundColor Green
