# ==========================================
# Weekly Comfortable Region Ranking Generator
# Generate-WeeklyComfortReport.ps1
# ==========================================

# --- ① dbconfig.json を読み込み ---
$dbconfPath = "C:\weather\config\dbconfig.json"
$dbconf = Get-Content $dbconfPath | ConvertFrom-Json

$SqlServer = $dbconf.Server
$Database  = $dbconf.Database
$User      = $dbconf.User
$Password  = $dbconf.Password

# --- ② 出力パス設定 ---
$OutputHtmlFixed = "C:\weather\output\weekly_comfortable_region.html"
$OneDriveDir     = "C:\Users\winserverroot\OneDrive\weekly_comfortable_region"

# GitHub Pages のローカルクローン
$RepoPath        = "C:\Users\winserverroot\weather2"

# weekly フォルダのパス
$RepoWeeklyDir   = Join-Path $RepoPath "weekly_comfortable_region"

# weekly フォルダがなければ作成
if (!(Test-Path $RepoWeeklyDir)) {
    New-Item -ItemType Directory -Path $RepoWeeklyDir | Out-Null
}

# --- ③ 最新週のデータ取得 ---
$query = @"
SELECT Ranking, FromDate, ToDate, CityEn, CountryCode,
       AvgT, AvgH, HeatIndex, WetBulb, WBGT, DiscomfortIndex, ComfortScore
FROM ComfortableRegionWeekly
WHERE FromDate = (SELECT MAX(FromDate) FROM ComfortableRegionWeekly)
ORDER BY Ranking;
"@

$data = Invoke-Sqlcmd -ServerInstance $SqlServer `
                      -Database $Database `
                      -Username $User `
                      -Password $Password `
                      -Query $query

# --- ④ 日付入りファイル名を生成 ---
$from = (Get-Date $data[0].FromDate).ToString("yyyyMMdd")
$to   = (Get-Date $data[0].ToDate).ToString("yyyyMMdd")

$FileName = "weekly_comfortable_region_${from}_${to}.html"

# OneDrive 側の保存先
$OutputHtmlDated = Join-Path $OneDriveDir $FileName

# GitHub Pages 側の保存先（weekly フォルダ）
$RepoHtmlDated   = Join-Path $RepoWeeklyDir $FileName

# --- ⑤ HTML テーブル生成 ---
$rows = ""
foreach ($r in $data) {
    $rows += "<tr>
<td>$($r.Ranking)</td>
<td>$($r.CityEn)</td>
<td>$($r.CountryCode)</td>
<td>$($r.AvgT)</td>
<td>$($r.AvgH)</td>
<td>$($r.HeatIndex)</td>
<td>$($r.WetBulb)</td>
<td>$($r.WBGT)</td>
<td>$($r.DiscomfortIndex)</td>
<td>$($r.ComfortScore)</td>
</tr>"
}

# --- ⑥ HTML 全体構築 ---
$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Weekly Comfortable Region Ranking</title>
<style>
body { font-family: Arial; margin: 20px; }
table { border-collapse: collapse; width: 100%; }
th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
th { background: #f0f0f0; }
</style>
</head>
<body>
<h1>Weekly Comfortable Region Ranking</h1>
<p>From $($data[0].FromDate) To $($data[0].ToDate)</p>
<table>
<tr>
<th>Rank</th><th>City</th><th>Country</th>
<th>AvgT</th><th>AvgH</th><th>HI</th><th>WB</th><th>WBGT</th>
<th>DI</th><th>Score</th>
</tr>
$rows
</table>
</body>
</html>
"@

# --- ⑦ 固定名 HTML を出力 ---
$html | Out-File -Encoding UTF8 $OutputHtmlFixed

# --- ⑧ 日付入り HTML を OneDrive にコピー ---
Copy-Item $OutputHtmlFixed $OutputHtmlDated -Force

# --- ⑨ GitHub Pages 用 weekly フォルダにコピー ---
Copy-Item $OutputHtmlFixed $RepoHtmlDated -Force

# --- ⑩ GitHub に push（pull 追加） ---
cd $RepoPath
git pull
git add .
git commit -m "Weekly comfortable region update ($from-$to)"
git push origin main
