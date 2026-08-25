-- ★ Declare variables
DECLARE @FromDate DATE;
DECLARE @ToDate   DATE;

-- ★ User-defined period
SET @FromDate = '2026-08-01';
SET @ToDate   = '2026-08-31';

SELECT
    w.LogDate      AS ObservationDate,
    w.TimeSlot     AS TimeSlot,
    c.CityEn       AS CityName,
    w.Temperature  AS Temperature,
    w.Humidity     AS Humidity
FROM
    WeatherLog w
    INNER JOIN CityMaster c
        ON w.CityCode = c.CityCode
WHERE
    w.LogDate >= @FromDate
    AND w.LogDate <= @ToDate
ORDER BY
    w.LogDate ASC,
    w.TimeSlot ASC,
    c.CityEn ASC;
