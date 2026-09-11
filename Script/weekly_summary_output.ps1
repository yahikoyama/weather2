# ============================================
# Weekly Weather Summary TXT Output Generator
# ============================================

$configPath = "C:\weather\config\dbconfig.json"
$config = Get-Content $configPath | ConvertFrom-Json

$server   = $config.Server
$database = $config.Database
$user     = $config.User
$password = $config.Password

$outputLatest = "C:\Users\winserverroot\OneDrive\weekly.txt"
$historyFolder = "C:\Users\winserverroot\OneDrive\Historical"

if (-not (Test-Path $historyFolder)) {
    New-Item -ItemType Directory -Path $historyFolder | Out-Null
}

# ============================================
# ★ 最新週の FromDate / ToDate を DB から取得
# ============================================

$sql = @"
DECLARE @FromDate DATE;
DECLARE @ToDate DATE;

SELECT TOP 1 
    @FromDate = FromDate,
    @ToDate = ToDate
FROM WeeklyWeatherSummary
WHERE Term = '1w'
ORDER BY Id DESC;

SELECT 
    W.CityCode,         -- 0
    C.CityJp,           -- 1
    C.CountryCode,      -- 2
    W.AvgTemperature,   -- 3
    W.AvgHumidity,      -- 4
    W.DiscomfortIndex,  -- 5
    W.ComfortLevel,     -- 6
    @FromDate AS FromDate, -- 7
    @ToDate AS ToDate      -- 8
FROM WeeklyWeatherSummary W
LEFT JOIN CityMaster C
    ON W.CityCode = C.CityCode
WHERE W.FromDate = @FromDate
  AND W.ToDate = @ToDate
  AND W.Term = '1w'
ORDER BY W.CityCode;
"@

$result = sqlcmd -S $server -d $database -U $user -P $password -Q $sql -s "," -W

$lines = @()

# ============================================
# ★ 最初の行から FromDate / ToDate を取得
# ============================================

$firstData = $result | Where-Object { $_ -match "^\d" } | Select-Object -First 1

if ($firstData) {
    $cols = $firstData.Split(",")
    $fromDate = [datetime]$cols[7]
    $toDate   = [datetime]$cols[8]
} else {
    Write-Host "No weekly summary data found."
    exit
}

# ヘッダー行
$header = "{0} から {1} 平均気温と平均湿度" -f `
    $fromDate.ToString("yyyy/M/d"), `
    $toDate.ToString("yyyy/M/d")

$lines += $header
$lines += ""

# ============================
# JP / NOT JP 分割
# ============================

$jpList = @()
$notjpList = @()

foreach ($row in $result) {
    if ($row -match "^\d") {
        $cols = $row.Split(",")

        $cityName    = $cols[1].Trim()
        $countryCode = $cols[2].Trim()
        $temp        = [decimal]$cols[3]
        $hum         = [decimal]$cols[4]
        $di          = [decimal]$cols[5]
        $level       = $cols[6].Trim()

        $obj = [PSCustomObject]@{
            City        = $cityName
            CountryCode = $countryCode
            Temp        = $temp
            Hum         = $hum
            DI          = $di
            Level       = $level
        }

        if ($countryCode -eq "JP") {
            $jpList += $obj
        } else {
            $notjpList += $obj
        }
    }
}

# ============================
# ソート
# ============================

$jpSorted    = $jpList    | Sort-Object Temp
$notjpSorted = $notjpList | Sort-Object Temp

# ============================
# TXT 出力
# ============================

$lines += "【国内（JP）】"
$lines += "地名             AvgTemp(℃)   AvgHum(%)   不快指数(DI)   評価"
$lines += "-----------------------------------------------------------------------"

foreach ($item in $jpSorted) {
    $line = "{0,-15} {1,10:N2} {2,10:N2} {3,12:N2} {4,-10}" -f `
        $item.City, $item.Temp, $item.Hum, $item.DI, $item.Level
    $lines += $line
}

$lines += ""

$lines += "【海外（NOT JP）】"
$lines += "地名             国  AvgTemp(℃)   AvgHum(%)   不快指数(DI)   評価"
$lines += "-----------------------------------------------------------------------"

foreach ($item in $notjpSorted) {
    $line = "{0,-15} {1,-3} {2,10:N2} {3,10:N2} {4,12:N2} {5,-10}" -f `
        $item.City, $item.CountryCode, $item.Temp, $item.Hum, $item.DI, $item.Level
    $lines += $line
}

# 最新週ファイルに保存
$lines | Out-File -FilePath $outputLatest -Encoding UTF8

# 履歴ファイルに保存
$historyFile = Join-Path $historyFolder ("weekly_{0}_{1}.txt" -f `
    $fromDate.ToString("yyyyMMdd"), $toDate.ToString("yyyyMMdd"))

$lines | Out-File -FilePath $historyFile -Encoding UTF8

Write-Host "Weekly summary TXT output completed."
