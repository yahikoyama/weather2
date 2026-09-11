# ==================================================
# sync_html_global_ru.ps1
# ロシア語版HTML生成 + GitHubアップロード（完全版）
# ==================================================

$DictFile = "C:\weather\config\dictionary_ru.json"
$ConfigFile = "C:\weather\config\sync.json"

if (-not (Test-Path $DictFile)) { Write-Error "$DictFile が見つかりません。"; exit 1 }
if (-not (Test-Path $ConfigFile)) { Write-Error "$ConfigFile が見つかりません。"; exit 1 }

$Dict = Get-Content -Path $DictFile -Raw -Encoding UTF8 | ConvertFrom-Json
$Config = Get-Content -Path $ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json

$Token = $Config.token
$Repo   = "yahikoyama/weather2"
$Branch = "main"

$InputFile  = "C:\Users\winserverroot\OneDrive\weather_report_now.html"
$OutputFile = "C:\Users\winserverroot\OneDrive\weather_report_now_ru.html"

if (-not (Test-Path $InputFile)) {
    Write-Error "$InputFile が見つかりません。"
    exit 1
}

$HtmlContent = Get-Content -Path $InputFile -Raw -Encoding UTF8

Write-Host "ロシア語翻訳中..." -ForegroundColor Cyan

# -----------------------------
# 地名
# -----------------------------
foreach ($jp in $Dict.place.PSObject.Properties.Name) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.place.$jp)
}

# -----------------------------
# 天気（長い語 → 短い語）
# -----------------------------
$weatherKeys = $Dict.weather.PSObject.Properties.Name | Sort-Object { $_.Length } -Descending
foreach ($jp in $weatherKeys) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.weather.$jp)
}

# -----------------------------
# 評価（長い語 → 短い語）
# -----------------------------
$feelingKeys = $Dict.feeling.PSObject.Properties.Name | Sort-Object { $_.Length } -Descending
foreach ($jp in $feelingKeys) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.feeling.$jp)
}

# -----------------------------
# 見出し
# -----------------------------
foreach ($jp in $Dict.labels.PSObject.Properties.Name) {
    $HtmlContent = $HtmlContent.Replace($jp, $Dict.labels.$jp)
}

# -----------------------------
# <title> の「レポート」をロシア語へ
# -----------------------------
$HtmlContent = $HtmlContent.Replace("レポート", "Отчёт")

# -----------------------------
# 保存
# -----------------------------
$HtmlContent | Set-Content -Path $OutputFile -Encoding UTF8

if (-not (Test-Path $OutputFile)) {
    Write-Error "ロシア語版HTMLが保存されていません。: $OutputFile"
    exit 1
}

Write-Host "ロシア語版HTMLをローカル保存しました。" -ForegroundColor Green

# -----------------------------
# GitHub アップロード
# -----------------------------
Write-Host "GitHub にアップロード中..." -ForegroundColor Cyan

$GitUrl = "https://api.github.com/repos/$Repo/contents/weather_report_now_ru.html"

$Raw = Get-Content $OutputFile -Raw -Encoding UTF8
$ContentBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Raw))

$sha = $null
try {
    $existing = Invoke-RestMethod -Uri $GitUrl -Method Get -Headers @{ Authorization = "Bearer $Token" }
    $sha = $existing.sha
} catch {}

$Body = @{
    message = "Update weather_report_now_ru.html"
    content = $ContentBase64
    branch  = $Branch
}

if ($sha) { $Body.sha = $sha }

$jsonBody = $Body | ConvertTo-Json

try {
    Invoke-RestMethod -Uri $GitUrl -Method Put -Headers @{ Authorization = "Bearer $Token" } -Body $jsonBody -ContentType "application/json"
    Write-Host "GitHub アップロード完了！" -ForegroundColor Green
}
catch {
    Write-Error "GitHub アップロードでエラー: $_"
    exit 1
}

Write-Host "ロシア語版処理 完了！" -ForegroundColor Green
