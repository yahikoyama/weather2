# ==========================================
# Full Historical Comfortable Region Dataset
# Generate-FullComfortDataset.ps1
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

$LocalCsvFile = Join-Path $LocalCsvDir "all_weekly_comfortable_region.csv"

# --- ③ GitHub Pages 設定 ---
$RepoPath = "C:\Users\winserverroot\weather2"

$RepoCsvDir = Join-Path $RepoPath "CSV"

if (!(Test-Path $RepoCsvDir)) {
    New-Item -ItemType Directory -Path $RepoCsvDir | Out-Null
}

$RepoCsvFile = Join-Path $RepoCsvDir "all_weekly_comfortable_region.csv"

# --- ④ SQL ---
$query = @"
SELECT
    Ranking,
    FromDate,
    ToDate,
    CityCode,
    CityEn,
    CountryCode,
    AvgT,
    AvgH,
    HeatIndex,
    WetBulb,
    WBGT,
    DiscomfortIndex,
    ComfortScore,
    UpdatedAt
FROM dbo.ComfortableRegionWeekly
ORDER BY
    FromDate DESC,
    Ranking ASC;
"@

# --- ⑤ SQL実行 ---
Write-Host ""
Write-Host "Generating Full Historical Dataset..."
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
cd $RepoPath

git pull

git add CSV/all_weekly_comfortable_region.csv

git commit -m "Update full comfortable region dataset"

git push origin main

# --- ⑨ 完了 ---
Write-Host ""
Write-Host "Completed."
Write-Host ""
Write-Host "Published URL:"
Write-Host "https://yahikoyama.github.io/weather2/CSV/all_weekly_comfortable_region.csv"