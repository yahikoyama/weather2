-- š Declare variables
DECLARE @FromDate DATE;
DECLARE @ToDate   DATE;
DECLARE @WeatherCode INT;

-- š User-defined period and weather code
SET @FromDate = '2026-08-01';
SET @ToDate   = '2026-08-31';
SET @WeatherCode = 804;   -- © user can change (e.g., 800=Clear, 804=Cloudy)

SELECT
    w.LogDate      AS ObservationDate,
    c.CityEn       AS CityName,
    w.TimeSlot     AS TimeSlot,
    w.Temperature  AS Temperature,
    w.Humidity     AS Humidity,
    wc.WeatherCode AS WeatherCode,
    wc.WeatherGroup AS WeatherName
FROM
    WeatherLog w
    INNER JOIN CityMaster c
        ON w.CityCode = c.CityCode
    INNER JOIN WeatherCodeMaster wc
        ON w.WeatherCode = wc.WeatherCode
WHERE
    w.LogDate >= @FromDate
    AND w.LogDate <= @ToDate
    AND w.WeatherCode = @WeatherCode
ORDER BY
    w.LogDate ASC,
    c.CityEn ASC,
    w.TimeSlot ASC;
