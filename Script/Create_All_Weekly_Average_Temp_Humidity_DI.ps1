# ==========================================
# Full Historical Average Temp/Humidity/DI Dataset
# Generate-AllWeeklyAverageTempHumidityDI.ps1
# ==========================================

# --- ① dbconfig.json を読み込み ---
$dbconfPath = "C:\weather\config\dbconfig.json"
$dbconf = Get-Content $dbconfPath | ConvertFrom-Json

$SqlServer = $dbconf.Server
$Database  = $dbconf.Database
$User      = $dbconf.User
$Password  = $dbconf.Password

# --- ② 出力パス設定 ---
$LocalCsvDir = "C:\weather\CSV"

if (!(Test-Path $LocalCsvDir)) {
    New-Item -ItemType Directory -Path $LocalCsvDir | Out-Null
}

$LocalCsvFile = Join-Path $LocalCsvDir "all_weekly_average_temp_humidity_di.csv"

# --- ③ GitHub Pages 設定 ---
$RepoPath = "C:\Users\winserverroot\weather2"

$RepoCsvDir = Join-Path $RepoPath "CSV"

if (!(Test-Path $RepoCsvDir)) {
    New-Item -ItemType Directory -Path $RepoCsvDir | Out-Null
}

$RepoCsvFile = Join-Path $RepoCsvDir "all_weekly_average_temp_humidity_di.csv"

# --- ④ SQL ---
$query = @"
SELECT
    CONVERT(varchar(10), W.FromDate, 23) AS FromDate,
    CONVERT(varchar(10), W.ToDate, 23) AS ToDate,
    W.CityCode,
    C.CityEn,
    C.CountryCode,
    W.AvgTemperature,
    W.AvgHumidity,
    W.DiscomfortIndex,
    CASE
        WHEN W.ComfortLevel = N'寒くてたまらない' THEN 'Extremely Cold'
        WHEN W.ComfortLevel = N'寒い' THEN 'Cold'
        WHEN W.ComfortLevel = N'肌寒い' THEN 'Cold'
        WHEN W.ComfortLevel = N'肌' THEN 'Cold'
        WHEN W.ComfortLevel = N'何も感じない' THEN 'Neutral'
        WHEN W.ComfortLevel = N'快適' THEN 'Comfortable'
        WHEN W.ComfortLevel = N'不快感出始め' THEN 'Slightly Uncomfortable'
        WHEN W.ComfortLevel = N'半数が不快' THEN 'Half Feel Uncomfortable'
        WHEN W.ComfortLevel = N'全員不快' THEN 'Everyone Feels Uncomfortable'
        ELSE W.ComfortLevel
    END AS ComfortLevelEn,
    W.Term
FROM dbo.WeeklyWeatherSummary W
INNER JOIN dbo.CityMaster C
    ON W.CityCode = C.CityCode
ORDER BY
    W.FromDate DESC,
    W.AvgTemperature ASC,
    C.CityEn ASC;
"@

# --- ⑤ SQL実行 ---
Write-Host ""
Write-Host "Generating Full Historical Average Temp/Humidity/DI Dataset..."
Write-Host ""

$data = Invoke-Sqlcmd `
            -ServerInstance $SqlServer `
            -Database $Database `
            -Username $User `
            -Password $Password `
            -Query $query

# --- ⑥ CSV出力 ---
$data | Export-Csv `
            -Path $LocalCsvFile `
            -NoTypeInformation `
            -Encoding UTF8

Write-Host "Local CSV Created:"
Write-Host $LocalCsvFile

# --- ⑦ GitHub用フォルダへコピー ---
Copy-Item `
    $LocalCsvFile `
    $RepoCsvFile `
    -Force

Write-Host ""
Write-Host "Copied to Repository:"
Write-Host $RepoCsvFile

# --- ⑧ GitHub Push ---
Set-Location $RepoPath

git pull

git add CSV/all_weekly_average_temp_humidity_di.csv

git commit -m "Update all weekly average temp humidity di dataset"

git push origin main

# --- ⑨ 完了 ---
Write-Host ""
Write-Host "Completed."
Write-Host ""
Write-Host "Published URL:"
Write-Host "https://yahikoyama.github.io/weather2/CSV/all_weekly_average_temp_humidity_di.csv"