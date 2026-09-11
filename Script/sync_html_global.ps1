# ==================================================
# sync_html_global.ps1
# 完全オフライン翻訳 + GitHubアップロード（最終版）
# ==================================================

# -----------------------------
# 1. 設定ファイル読み込み
# -----------------------------
$DictFile = "C:\weather\config\dictionary_daily.json"
$ConfigFile = "C:\weather\config\sync.json"

if (-not (Test-Path $DictFile)) { Write-Error "$DictFile が見つかりません。"; exit 1 }
if (-not (Test-Path $ConfigFile)) { Write-Error "$ConfigFile が見つかりません。"; exit 1 }

$Dict = Get-Content -Path $DictFile -Raw -Encoding UTF8 | ConvertFrom-Json
$Config = Get-Content -Path $ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json

# sync.json は token のみ
$Token = $Config.token

# GitHub 固定設定
$Repo   = "yahikoyama/weather2"
$Branch = "main"

# -----------------------------
# 2. 入力HTML読み込み
# -----------------------------
$InputFile  = "C:\Users\winserverroot\OneDrive\weather_report_now.html"
$OutputFile = "C:\Users\winserverroot\OneDrive\weather_report_now_en.html"

if (-not (Test-Path $InputFile)) {
    Write-Error "$InputFile が見つかりません。"
    exit 1
}

$HtmlContent = Get-Content -Path $InputFile -Raw -Encoding UTF8

Write-Host "辞書を使って翻訳中..." -ForegroundColor Cyan

# ==================================================
# 3〜6. 辞書置換（長い語 → 短い語）
# ==================================================

# 地名
foreach ($jp in ($Dict.place.PSObject.Properties.Name | Sort-Object Length -Descending)) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.place.$jp)
}

# 天気
foreach ($jp in ($Dict.weather.PSObject.Properties.Name | Sort-Object Length -Descending)) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.weather.$jp)
}

# 評価
foreach ($jp in ($Dict.feeling.PSObject.Properties.Name | Sort-Object Length -Descending)) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.feeling.$jp)
}

# 見出し
foreach ($jp in ($Dict.labels.PSObject.Properties.Name | Sort-Object Length -Descending)) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.labels.$jp)
}

# -----------------------------
# 6. <title> の「レポート」を英語へ
# -----------------------------
$HtmlContent = $HtmlContent.Replace("レポート", "Report")

# -----------------------------
# 7. 英語版HTMLをローカル保存
# -----------------------------
$HtmlContent | Set-Content -Path $OutputFile -Encoding UTF8

if (-not (Test-Path $OutputFile)) {
    Write-Error "英語版HTMLが保存されていません。パスを確認してください: $OutputFile"
    exit 1
}

Write-Host "英語版HTMLをローカルに保存しました。" -ForegroundColor Green

# -----------------------------
# 8. GitHub にアップロード
# -----------------------------
Write-Host "GitHub にアップロード中..." -ForegroundColor Cyan

$GitUrl = "https://api.github.com/repos/$Repo/contents/weather_report_now_en.html"

# Base64 エンコード
$Raw = Get-Content $OutputFile -Raw -Encoding UTF8
$ContentBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Raw))

# 既存ファイルの SHA を取得
$sha = $null
try {
    $existing = Invoke-RestMethod -Uri $GitUrl -Method Get -Headers @{ Authorization = "Bearer $Token" }
    $sha = $existing.sha
} catch {
    # 新規作成の場合は sha = null のまま
}

# PUT ボディ
$Body = @{
    message = "Update weather_report_now_en.html"
    content = $ContentBase64
    branch  = $Branch
}

if ($sha) {
    $Body.sha = $sha
}

$jsonBody = $Body | ConvertTo-Json

# アップロード実行
try {
    Invoke-RestMethod -Uri $GitUrl -Method Put -Headers @{ Authorization = "Bearer $Token" } -Body $jsonBody -ContentType "application/json"
    Write-Host "GitHub にアップロード完了！" -ForegroundColor Green
}
catch {
    Write-Error "GitHub アップロードでエラー: $_"
    exit 1
}

Write-Host "すべて完了しました！" -ForegroundColor Green
