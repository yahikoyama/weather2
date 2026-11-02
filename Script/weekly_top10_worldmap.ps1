# ==========================================
# Weekly Top10 World Map
# ==========================================

Add-Type -AssemblyName System.Drawing

# ==========================================
# DB接続
# ==========================================

$dbconfPath = "C:\weather\config\dbconfig.json"
$dbconf = Get-Content $dbconfPath | ConvertFrom-Json

$SqlServer = $dbconf.Server
$Database  = $dbconf.Database
$User      = $dbconf.User
$Password  = $dbconf.Password

# ==========================================
# ファイル
# ==========================================

$MapFile = "C:\weather\images\world_map.png"
$OutFile = "C:\weather\output\top10_worldmap.png"

# ==========================================
# SQL
# ==========================================

$query = @"
SELECT TOP 10
    c.Ranking,
    c.CityEn,
    c.CountryCode,
    c.FromDate,
    c.ToDate,
    m.Latitude,
    m.Longitude
FROM ComfortableRegionWeekly c
INNER JOIN CityMaster m
    ON c.CityCode = m.CityCode
WHERE c.FromDate =
(
    SELECT MAX(FromDate)
    FROM ComfortableRegionWeekly
)
ORDER BY c.Ranking;
"@

$data = Invoke-Sqlcmd `
    -ServerInstance $SqlServer `
    -Database $Database `
    -Username $User `
    -Password $Password `
    -Query $query

if ($data.Count -eq 0)
{
    Write-Host "No data found."
    exit
}

# ==========================================
# 日付
# ==========================================

$fromDate = Get-Date $data[0].FromDate -Format "yyyy-MM-dd"
$toDate   = Get-Date $data[0].ToDate   -Format "yyyy-MM-dd"

$titleText = "Top 10 Comfortable Cities This Week ($fromDate - $toDate)"

# ==========================================
# 地図読込
# ==========================================

$bitmap   = [System.Drawing.Bitmap]::FromFile($MapFile)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

$graphics.SmoothingMode =
    [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

$graphics.TextRenderingHint =
    [System.Drawing.Text.TextRenderingHint]::AntiAlias

# ==========================================
# タイトル
# ==========================================

$titleFont = New-Object System.Drawing.Font(
    "Arial",
    10,
    [System.Drawing.FontStyle]::Bold
)

$graphics.DrawString(
    $titleText,
    $titleFont,
    [System.Drawing.Brushes]::DarkBlue,
    10,
    10
)

# ==========================================
# 地図上ラベル
# ==========================================

$font = New-Object System.Drawing.Font(
    "Arial",
    5,
    [System.Drawing.FontStyle]::Bold
)

foreach($r in $data)
{
    $lat = [double]$r.Latitude
    $lon = [double]$r.Longitude

    $x = (($lon + 180.0) / 360.0) * $bitmap.Width

    # 地図補正
    $x = $x - 50

    $y = ((90.0 - $lat) / 180.0) * $bitmap.Height

    $text = "$($r.Ranking) $($r.CityEn) ($($r.CountryCode))"

    $textX = $x
    $textY = $y

    # 右端回避
    if ($x -gt ($bitmap.Width * 0.80))
    {
        $textX = $x - 120
    }

    $graphics.DrawString(
        $text,
        $font,
        [System.Drawing.Brushes]::DarkRed,
        $textX,
        $textY
    )
}

# ==========================================
# Pacific Ranking Box
# ==========================================

$rankFont = New-Object System.Drawing.Font(
    "Arial",
    5,
    [System.Drawing.FontStyle]::Bold
)

$rankX = $bitmap.Width * 0.90
$rankY = $bitmap.Height * 0.25

$boxWidth  = 300
$boxHeight = 230

# 白背景
$graphics.FillRectangle(
    [System.Drawing.Brushes]::White,
    $rankX - 10,
    $rankY - 10,
    $boxWidth,
    $boxHeight
)

# 枠線
$graphics.DrawRectangle(
    [System.Drawing.Pens]::DarkBlue,
    $rankX - 10,
    $rankY - 10,
    $boxWidth,
    $boxHeight
)

# 見出し
$graphics.DrawString(
    "Top 10 Ranking",
    $rankFont,
    [System.Drawing.Brushes]::DarkBlue,
    $rankX,
    $rankY
)

$line = 1

foreach($r in $data)
{
    $rankText = "{0,2}. {1} ({2})" -f `
        $r.Ranking,
        $r.CityEn,
        $r.CountryCode

    $graphics.DrawString(
        $rankText,
        $rankFont,
        [System.Drawing.Brushes]::DarkRed,
        $rankX,
        $rankY + ($line * 18)
    )

    $line++
}

# ==========================================
# 保存
# ==========================================

$bitmap.Save(
    $OutFile,
    [System.Drawing.Imaging.ImageFormat]::Png
)

$graphics.Dispose()
$bitmap.Dispose()

Write-Host ""
Write-Host "Created:"
Write-Host $OutFile
Write-Host ""