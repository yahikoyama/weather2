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
$localPath = "C:\weather\DBBackup"
$repo = "yahikoyama/weather2"
$branch = "main"
$apiBase = "https://api.github.com/repos/$repo/contents/DBBackup"

# ① GitHub の DBBackup フォルダ一覧を取得
$githubFiles = @{}
try {
    $items = Invoke-RestMethod -Uri $apiBase -Method Get -Headers @{Authorization = "token $token"}
    foreach ($item in $items) {
        if ($item.type -eq "file") {
            $githubFiles[$item.name] = $item.sha
        }
    }
    Write-Host "GitHub DBBackup file list loaded." -ForegroundColor Green
}
catch {
    Write-Host "GitHub の DBBackup フォルダが存在しないため、新規作成します。" -ForegroundColor Yellow
}

# ② ローカルのバックアップファイル一覧取得
$localFiles = Get-ChildItem -Path $localPath -File
$localFileNames = $localFiles.Name

# ③ GitHub にあってローカルに無いファイルを削除
foreach ($githubFile in $githubFiles.Keys) {
    if ($localFileNames -notcontains $githubFile) {

        $deleteUrl = "$apiBase/$githubFile"

        $body = @{
            message = "Delete $githubFile (not in local)"
            sha     = $githubFiles[$githubFile]
            branch  = $branch
        } | ConvertTo-Json

        try {
            Invoke-RestMethod -Uri $deleteUrl -Method Delete -Headers @{Authorization = "token $token"} -Body $body
            Write-Host "Deleted from GitHub: $githubFile" -ForegroundColor Magenta
        }
        catch {
            Write-Host "Failed to delete: $githubFile" -ForegroundColor Red
            Write-Host $_.Exception.Message
        }
    }
}

# ④ ローカルにあって GitHub に無いファイルをアップロード
foreach ($file in $localFiles) {

    $fileName = $file.Name
    $uploadUrl = "$apiBase/$fileName"

    if ($githubFiles.ContainsKey($fileName)) {
        Write-Host "Skip (exists on GitHub): $fileName" -ForegroundColor Yellow
        continue
    }

    $content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file.FullName))

    $body = @{
        message = "Upload $fileName"
        content = $content
        branch  = $branch
    } | ConvertTo-Json

    try {
        Invoke-RestMethod -Uri $uploadUrl -Method Put -Headers @{Authorization = "token $token"} -Body $body
        Write-Host "Uploaded: $fileName" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Failed: $fileName" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

Write-Host "DBBackup sync completed (full sync: delete + upload)." -ForegroundColor Green
