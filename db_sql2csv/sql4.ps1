[string]$sql = "
---Largest_All-Time_Temperature_Range_TOP10---
--SQL START ---
IF OBJECT_ID('tempdb..#TempRange') IS NOT NULL
    DROP TABLE #TempRange;

SELECT
    CityCode,
    MAX(Temperature) AS MaxTemp,
    MIN(Temperature) AS MinTemp,
    MAX(Temperature) - MIN(Temperature) AS TemperatureRange
INTO #TempRange
FROM WeatherLog
GROUP BY CityCode;

SELECT TOP 10
    CM.CityCode,
    CM.CityEn,
    CM.CityJp,
    CM.CountryCode,

    CM.Latitude,
    CM.Longitude,

    CAST(TR.TemperatureRange AS DECIMAL(10,2)) AS TemperatureRange,

    CAST(TR.MaxTemp AS DECIMAL(10,2)) AS MaxTemp,
    MX.LogDate AS MaxTempDate,
    MX.TimeSlot AS MaxTempTimeSlot,

    CAST(TR.MinTemp AS DECIMAL(10,2)) AS MinTemp,
    MN.LogDate AS MinTempDate,
    MN.TimeSlot AS MinTempTimeSlot

FROM #TempRange TR
INNER JOIN CityMaster CM
    ON TR.CityCode = CM.CityCode

OUTER APPLY
(
    SELECT TOP 1
        W.LogDate,
        W.TimeSlot
    FROM WeatherLog W
    WHERE W.CityCode = TR.CityCode
      AND W.Temperature = TR.MaxTemp
    ORDER BY W.LogDate, W.TimeSlot
) MX

OUTER APPLY
(
    SELECT TOP 1
        W.LogDate,
        W.TimeSlot
    FROM WeatherLog W
    WHERE W.CityCode = TR.CityCode
      AND W.Temperature = TR.MinTemp
    ORDER BY W.LogDate, W.TimeSlot
) MN

ORDER BY TR.TemperatureRange DESC;
--SQL END ---
;
";