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
$onedrivePath = "C:\Users\winserverroot\OneDrive\Historical"
$repo = "yahikoyama/weather2"
$branch = "main"
$apiBase = "https://api.github.com/repos/$repo/contents/Historical"

# ① GitHub の Historical フォルダ一覧を取得
$githubFiles = @{}
try {
    $items = Invoke-RestMethod -Uri $apiBase -Method Get -Headers @{Authorization = "token $token"}
    foreach ($item in $items) {
        if ($item.type -eq "file") {
            $githubFiles[$item.name] = $true
        }
    }
    Write-Host "GitHub file list loaded." -ForegroundColor Green
}
catch {
    Write-Host "GitHub の Historical フォルダが存在しないため、新規作成します。" -ForegroundColor Yellow
}

# ② ローカルのファイル一覧取得
$localFiles = Get-ChildItem -Path $onedrivePath -Recurse -File

foreach ($file in $localFiles) {

    $relativePath = $file.FullName.Replace($onedrivePath, "").TrimStart("\")
    $fileName = [System.IO.Path]::GetFileName($relativePath)
    $uploadUrl = "$apiBase/$relativePath"

    # ③ GitHub に同名ファイルがあるかチェック
    if ($githubFiles.ContainsKey($fileName)) {
        Write-Host "Skip (exists on GitHub): $relativePath" -ForegroundColor Yellow
        continue
    }

    # ④ 新規ファイルだけアップロード
    $content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file.FullName))

    $body = @{
        message = "Upload $relativePath"
        content = $content
        branch  = $branch
    } | ConvertTo-Json

    try {
        Invoke-RestMethod -Uri $uploadUrl -Method Put -Headers @{Authorization = "token $token"} -Body $body
        Write-Host "Uploaded: $relativePath" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Failed: $relativePath" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

Write-Host "Sync completed (only new files uploaded)." -ForegroundColor Green
