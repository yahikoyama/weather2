-- ★ Declare variables
DECLARE @FromDate DATE;
DECLARE @ToDate   DATE;

-- ★ User-defined period
SET @FromDate = '2026-08-01';
SET @ToDate   = '2026-08-31';

SELECT
    w.LogDate      AS ObservationDate,
    c.CityEn       AS CityName,
    w.TimeSlot     AS TimeSlot,
    w.Temperature  AS Temperature,
    w.Humidity     AS Humidity,

    -- Discomfort Index (DI) calculation
    (0.81 * w.Temperature)
        + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
        + 46.3 AS DiscomfortIndex,

    -- DI Level (English)
    CASE
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 < 65
            THEN 'Comfortable'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 < 71
            THEN 'Pleasant'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 < 75
            THEN 'Not Hot'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 < 80
            THEN 'Slightly Hot (Half feel discomfort)'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 < 85
            THEN 'Hot & Sweaty (Most feel discomfort)'
        ELSE 'Extremely Hot'
    END AS DI_Level

FROM
    WeatherLog w
    INNER JOIN CityMaster c
        ON w.CityCode = c.CityCode
WHERE
    w.LogDate >= @FromDate
    AND w.LogDate <= @ToDate
ORDER BY
    w.LogDate ASC,
    c.CityEn ASC,
    w.TimeSlot ASC;
