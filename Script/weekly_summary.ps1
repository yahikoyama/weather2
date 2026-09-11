# ================================
# Weekly Weather Summary Generator
# ================================

$configPath = "C:\weather\config\dbconfig.json"
$config = Get-Content $configPath | ConvertFrom-Json

$server   = $config.Server
$database = $config.Database
$user     = $config.User
$password = $config.Password

$sql = @"
DECLARE @Now DATE = CAST(GETDATE() AS DATE);

-- 今週の月曜
DECLARE @ThisMonday DATE = DATEADD(WEEK, DATEDIFF(WEEK, 0, @Now), 0);

-- 前週の月曜
DECLARE @FromDate DATE = DATEADD(WEEK, -1, @ThisMonday);

-- 前週の日曜
DECLARE @ToDate DATE = DATEADD(DAY, 6, @FromDate);

-- ★ 一時テーブル（集計結果を先に作る）
DECLARE @temp TABLE (
    CityCode VARCHAR(10),
    AvgTemperature DECIMAL(5,2),
    AvgHumidity DECIMAL(5,2),
    DI DECIMAL(5,2)
);

-- ★ まず集計して @temp に入れる
INSERT INTO @temp
SELECT
    W.CityCode,
    AVG(W.Temperature),
    AVG(W.Humidity),
    (
        0.81 * AVG(W.Temperature)
        + 0.01 * AVG(W.Humidity) * (0.99 * AVG(W.Temperature) - 14.3)
        + 46.3
    ) AS DI
FROM WeatherLog W
WHERE W.LogDate BETWEEN @FromDate AND @ToDate
GROUP BY W.CityCode;

-- ★ ComfortLevel と JOIN して WeeklyWeatherSummary に登録
INSERT INTO WeeklyWeatherSummary (
    CityCode,
    AvgTemperature,
    AvgHumidity,
    DiscomfortIndex,
    ComfortLevel,
    FromDate,
    ToDate,
    Term
)
SELECT
    T.CityCode,
    T.AvgTemperature,
    T.AvgHumidity,
    T.DI,
    CL.LevelName,
    @FromDate,
    @ToDate,
    '1w'
FROM @temp T
JOIN ComfortLevel CL
    ON T.DI BETWEEN CL.MinDI AND CL.MaxDI
WHERE NOT EXISTS (
    SELECT 1
    FROM WeeklyWeatherSummary S
    WHERE S.CityCode = T.CityCode
      AND S.FromDate = @FromDate
      AND S.ToDate = @ToDate
      AND S.Term = '1w'
);
"@

sqlcmd -S $server -d $database -U $user -P $password -Q $sql

Write-Host "Weekly summary calculation completed."
