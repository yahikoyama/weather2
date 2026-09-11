# ============================================
# sync_html.ps1  (差分チェック＋Pages再ビルド強制＋index_org.html から生成)
# ============================================

# 設定ファイルのパス
$configPath = "C:\weather\config\sync.json"

# JSON 読み込み
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

# パス・リポジトリ設定
$htmlLocalPath  = "C:\Users\winserverroot\OneDrive\weather_report_now.html"
$indexOrgPath   = "C:\weather\output\index_org.html"   # ★ テンプレート
$repo = "yahikoyama/weather2"
$branch = "main"

$htmlUrl  = "https://api.github.com/repos/$repo/contents/weather_report_now.html"
$indexUrl = "https://api.github.com/repos/$repo/contents/index.html"

# ローカルのHTMLファイル存在チェック
if (-not (Test-Path $htmlLocalPath)) {
    Write-Host "HTMLファイルが見つかりません: $htmlLocalPath" -ForegroundColor Red
    exit 1
}

# ① ローカル内容読み込み
$htmlRaw = Get-Content $htmlLocalPath -Raw -Encoding UTF8
$localBytes = [System.Text.Encoding]::UTF8.GetBytes($htmlRaw)
$localBase64 = [Convert]::ToBase64String($localBytes)

# ② GitHub の既存ファイル取得
$existing = $null
try {
    $existing = Invoke-RestMethod -Uri $htmlUrl -Method Get -Headers @{Authorization = "token $token"}
} catch {
    Write-Host "GitHub 上に既存ファイルなし（新規作成扱い）" -ForegroundColor Yellow
}

# ③ 差分チェック
if ($existing -and $existing.content -eq $localBase64) {
    Write-Host "=== 判定: 内容が同じため weather_report_now.html は更新しません ===" -ForegroundColor Yellow
} else {
    Write-Host "=== 判定: 内容が異なるため GitHub を更新します ===" -ForegroundColor Green

    # ④ SHA
    $sha = $existing.sha

    # ⑤ PUT 送信内容
    $body = @{
        message = "Update weather_report_now.html"
        content = $localBase64
        branch  = $branch
    }

    if ($sha) {
        $body.sha = $sha
    }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    # ⑥ weather_report_now.html をアップロード
    $response = Invoke-RestMethod -Uri $htmlUrl -Method Put -Headers @{Authorization = "token $token"} -Body $jsonBody -ContentType "application/json"

    Write-Host "=== weather_report_now.html 更新完了 ===" -ForegroundColor Green
}

# ============================================
# ⑦ GitHub Pages の再ビルドを強制するため index_org.html → index.html を生成
# ============================================

if (-not (Test-Path $indexOrgPath)) {
    Write-Host "index_org.html がありません。Pages再ビルドはスキップします。" -ForegroundColor Yellow
    exit 0
}

# index_org.html を読み込む
$indexContent = Get-Content $indexOrgPath -Raw -Encoding UTF8

# rebuild コメントを抽出
$rebuildPattern = "<!-- rebuild .*?-->"
$matches = [regex]::Matches($indexContent, $rebuildPattern)

# 最大保持数
$maxKeep = 3

if ($matches.Count -gt $maxKeep) {
    $removeCount = $matches.Count - $maxKeep
    for ($i = 0; $i -lt $removeCount; $i++) {
        $old = $matches[$i].Value
        $indexContent = $indexContent.Replace($old, "")
    }
}

# 新しい rebuild コメントを追加
$newComment = "<!-- rebuild $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -->"
$indexContent += "`n$newComment"

# GitHub アップロード用 Base64 生成
$indexBytes = [System.Text.Encoding]::UTF8.GetBytes($indexContent)
$indexBase64 = [Convert]::ToBase64String($indexBytes)

# GitHub の index.html を取得
$indexExisting = $null
try {
    $indexExisting = Invoke-RestMethod -Uri $indexUrl -Method Get -Headers @{Authorization = "token $token"}
} catch {
    Write-Host "GitHub 上に index.html がありません（新規作成扱い）" -ForegroundColor Yellow
}

$indexSha = $indexExisting.sha

$indexBody = @{
    message = "Trigger GitHub Pages rebuild $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    content = $indexBase64
    branch  = $branch
}

if ($indexSha) {
    $indexBody.sha = $indexSha
}

$jsonIndexBody = $indexBody | ConvertTo-Json -Depth 10

# index.html をアップロード
$indexResponse = Invoke-RestMethod -Uri $indexUrl -Method Put -Headers @{Authorization = "token $token"} -Body $jsonIndexBody -ContentType "application/json"

Write-Host "=== GitHub Pages 再ビルド用 index.html 更新完了（index_org.html を元に生成） ===" -ForegroundColor Green

Write-Host "=== 完了 ===" -ForegroundColor Green
