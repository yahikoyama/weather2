# ================================
# auto_check_weather_update.ps1
# GitHub Pages の weather_report_now.html を監視し、
# 取得時間が指定時間以上古ければ Task Scheduler を実行する
# ================================

# ====== パラメータ（ここだけ変更すればOK） ======
# 何時間以上古かったら Task Scheduler を実行するか
$MaxHours = 5   # ← 監視時間をここで設定
# ================================================

# GitHub Pages の URL
$Url = "https://yahikoyama.github.io/weather2/weather_report_now.html"

# HTML を取得
try {
    $html = Invoke-WebRequest -Uri $Url -UseBasicParsing
} catch {
    # Write-Host " HTML を取得できませんでした。"
    exit
}

# HTML 内の「取得時間」を抽出（日本語版 & 英語版）
$patternJP = "取得時間[:：]\s*([0-9\-:\s]+)"
$patternEN = "Acquisition Time[:：]\s*([0-9\-:\s]+)"

$matchJP = [regex]::Match($html.Content, $patternJP)
$matchEN = [regex]::Match($html.Content, $patternEN)

if ($matchJP.Success) {
    $timeString = $matchJP.Groups[1].Value.Trim()
} elseif ($matchEN.Success) {
    $timeString = $matchEN.Groups[1].Value.Trim()
} else {
    # Write-Host " 取得時間が見つかりませんでした。"
    exit
}

# 日付として変換
try {
    $acquiredTime = [DateTime]::Parse($timeString)
} catch {
    # Write-Host "日付の解析に失敗しました。"
    exit
}

# 現在時刻
$now = Get-Date

# 時間差
$diffHours = ($now - $acquiredTime).TotalHours

# 指定時間以上なら Task Scheduler を実行
if ($diffHours -ge $MaxHours) {

    try {
        Start-ScheduledTask -TaskName "export_jp_latest_sync_html"
        # Write-Host "Task Scheduler を実行しました。"
    } catch {
        # Write-Host " Task Scheduler の実行に失敗しました。"
    }

} else {
    # Write-Host "更新は最新です。"
}
