-- ★ Declare variables
DECLARE @FromDate DATE;
DECLARE @ToDate   DATE;

-- ★ User-defined period
SET @FromDate = '2026-08-01';
SET @ToDate   = '2026-08-10';

SELECT
    w.LogDate      AS ObservationDate,
     c.CityEn       AS CityName,
    w.TimeSlot     AS TimeSlot,
   
    w.Temperature  AS Temperature,
    w.Humidity     AS Humidity,

    -- WBGT calculation (simplified formula)
    (0.7 * w.Temperature) 
        + (0.3 * (w.Temperature * w.Humidity / 100.0)) AS WBGT,

    -- WBGT risk level (English)
    CASE
        WHEN (0.7 * w.Temperature) 
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 31
            THEN 'Danger (Stop all activity)'
        WHEN (0.7 * w.Temperature) 
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 28
            THEN 'Severe Warning'
        WHEN (0.7 * w.Temperature) 
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 25
            THEN 'Warning'
        WHEN (0.7 * w.Temperature) 
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 21
            THEN 'Caution'
        ELSE 'Safe'
    END AS WBGT_Level

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
