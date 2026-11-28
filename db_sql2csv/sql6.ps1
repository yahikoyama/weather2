[string]$sql = "
--- Smallest_Daily_Temperature_Range_TOP20---
--SQL START ---
IF OBJECT_ID('tempdb..#TargetCity') IS NOT NULL
    DROP TABLE #TargetCity;

IF OBJECT_ID('tempdb..#DailyRange') IS NOT NULL
    DROP TABLE #DailyRange;

-- 100日以上データが存在する都市を抽出
SELECT
    CityCode
INTO #TargetCity
FROM WeatherLog
WHERE LogDate >= '2026-07-01'
GROUP BY CityCode
HAVING COUNT(DISTINCT LogDate) >= 100;

-- 日別寒暖差を計算
SELECT
    WL.CityCode,
    WL.LogDate,
    MAX(WL.Temperature) AS MaxTemp,
    MIN(WL.Temperature) AS MinTemp,
    MAX(WL.Temperature) - MIN(WL.Temperature) AS TemperatureRange
INTO #DailyRange
FROM WeatherLog WL
INNER JOIN #TargetCity TC
    ON WL.CityCode = TC.CityCode
WHERE WL.LogDate >= '2026-07-01'
GROUP BY
    WL.CityCode,
    WL.LogDate;

-- 寒暖差が小さいTOP50
SELECT TOP 50
    CM.CityCode,
    CM.CityEn,
    CM.CityJp,
    CM.CountryCode,
    CM.Latitude,
    CM.Longitude,
    DR.LogDate,

    CAST(DR.TemperatureRange AS DECIMAL(10,2)) AS TemperatureRange,
    CAST(DR.MaxTemp AS DECIMAL(10,2)) AS MaxTemp,
    CAST(DR.MinTemp AS DECIMAL(10,2)) AS MinTemp

FROM #DailyRange DR
INNER JOIN CityMaster CM
    ON DR.CityCode = CM.CityCode

ORDER BY
    DR.TemperatureRange ASC,
    DR.LogDate DESC;

DROP TABLE #DailyRange;
DROP TABLE #TargetCity;
--SQL END ---
;
";