[string]$sql = "
---Largest_Daily_Temperature_Range_TOP20---
--SQL START ---
IF OBJECT_ID('tempdb..#DailyRange') IS NOT NULL
    DROP TABLE #DailyRange;

SELECT
    CityCode,
    LogDate,
    MAX(Temperature) AS MaxTemp,
    MIN(Temperature) AS MinTemp,
    MAX(Temperature) - MIN(Temperature) AS TemperatureRange
INTO #DailyRange
FROM WeatherLog
GROUP BY
    CityCode,
    LogDate;

SELECT TOP 20
    CM.CityCode,
    CM.CityEn,
    CM.CityJp,
    CM.CountryCode,

    CM.Latitude,
    CM.Longitude,

    DR.LogDate,

    CAST(
        DR.TemperatureRange
        AS DECIMAL(10,2)
    ) AS TemperatureRange,

    CAST(
        DR.MaxTemp
        AS DECIMAL(10,2)
    ) AS MaxTemp,

    CAST(
        DR.MinTemp
        AS DECIMAL(10,2)
    ) AS MinTemp

FROM #DailyRange DR

INNER JOIN CityMaster CM
    ON DR.CityCode = CM.CityCode

ORDER BY DR.TemperatureRange DESC;

DROP TABLE #DailyRange;
--SQL END ---
;
";