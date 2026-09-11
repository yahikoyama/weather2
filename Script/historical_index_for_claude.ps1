# 設定ファイルのパス
$configPath = "C:\weather\config\sync.json"

# JSON 読み込み
if (-not (Test-Path $configPath)) {
    Write-Host "設定ファイルが見つかりません: $configPath" -ForegroundColor Red
    exit 1
}

$config = Get-Content $configPath | ConvertFrom-Json
$token = $config.token

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "設定ファイルに token がありません。" -ForegroundColor Red
    exit 1
}

# パス設定
$localPath = "C:\Users\winserverroot\OneDrive\Historical"
$repo = "yahikoyama/weather2"
$branch = "main"
$apiBase = "https://api.github.com/repos/$repo/contents"

# ① Historical のローカルファイル一覧を取得
$localFiles = Get-ChildItem -Path $localPath -File

# ② JSON インデックスを作成
$index = @{
    files = @()
}

foreach ($file in $localFiles) {

    # 日付抽出（ファイル名に YYYYMMDD が含まれている前提）
    $date = $null
    if ($file.Name -match "\d{8}") {
        $dateRaw = $matches[0]
        $date = "{0}-{1}-{2}" -f $dateRaw.Substring(0,4), $dateRaw.Substring(4,2), $dateRaw.Substring(6,2)
    }

    $index.files += @{
        name = $file.Name
        date = $date
        path = "Historical/$($file.Name)"
    }
}

$json = $index | ConvertTo-Json -Depth 10

# ③ JSON を Base64 に変換
$content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($json))

# ④ GitHub 上の Historical_index.json の存在チェック（ルート）
$indexUrl = "$apiBase/Historical_index.json"
$sha = $null

try {
    $existing = Invoke-RestMethod -Uri $indexUrl -Method Get -Headers @{Authorization = "token $token"}
    $sha = $existing.sha
} catch {
    # 新規作成なので sha は null のまま
}

# ⑤ GitHub にアップロード（新規 or 上書き）
$body = @{
    message = "Update Historical_index.json"
    content = $content
    branch  = $branch
}

if ($sha) {
    $body.sha = $sha
}

$jsonBody = $body | ConvertTo-Json

Invoke-RestMethod -Uri $indexUrl -Method Put -Headers @{Authorization = "token $token"} -Body $jsonBody

Write-Host "Historical_index.json updated on GitHub (root)." -ForegroundColor Green
