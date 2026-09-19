[string]$sql = "
---ComfortableRegionFinder.sql mod---
--SQL START ---
DECLARE 
    @FromDate DATE,
    @ToDate   DATE;

-- Last 7 days (excluding today)
SET @FromDate = DATEADD(DAY, -7, CAST(GETDATE() AS DATE));
SET @ToDate   = DATEADD(DAY, -1, CAST(GETDATE() AS DATE));

-- Convert dates to string
DECLARE 
    @FromDateStr VARCHAR(10) = CONVERT(VARCHAR(10), @FromDate, 111),
    @ToDateStr   VARCHAR(10) = CONVERT(VARCHAR(10), @ToDate, 111);

-- Calculate average temperature and humidity per city
WITH CityStats AS (
    SELECT
        W.CityCode,
        C.CityEn,
        C.CountryCode,

        AVG(W.Temperature) AS AvgT,
        AVG(W.Humidity)    AS AvgH
    FROM WeatherLog W
    JOIN CityMaster C
        ON W.CityCode = C.CityCode
    WHERE CAST(W.CreatedAt AS DATE) BETWEEN @FromDate AND @ToDate
    GROUP BY W.CityCode, C.CityEn, C.CountryCode
),

-- Calculate HeatIndex, WetBulb, WBGT, DiscomfortIndex
Metrics AS (
    SELECT
        CityCode,
        CityEn,
        CountryCode,
        AvgT,
        AvgH,

        -- Heat Index
        -8.784695
        + 1.61139411 * AvgT
        + 2.338549   * AvgH
        - 0.14611605 * AvgT * AvgH
        - 0.012308094 * POWER(AvgT, 2)
        - 0.016424828 * POWER(AvgH, 2)
        + 0.002211732 * POWER(AvgT, 2) * AvgH
        + 0.00072546  * AvgT * POWER(AvgH, 2)
        - 0.000003582 * POWER(AvgT, 2) * POWER(AvgH, 2)
        AS HeatIndex,

        -- Wet-bulb temperature
        AvgT * ATAN(0.151977 * SQRT(AvgH + 8))
        + ATAN(AvgT + AvgH)
        - ATAN(AvgH - 1.676331)
        + 0.00391838 * POWER(AvgH, 1.5) * ATAN(0.023101 * AvgH)
        - 4.686035
        AS WetBulb,

        -- WBGT (heat stress index)
        0.7 * (
            AvgT * ATAN(0.151977 * SQRT(AvgH + 8))
            + ATAN(AvgT + AvgH)
            - ATAN(AvgH - 1.676331)
            + 0.00391838 * POWER(AvgH, 1.5) * ATAN(0.023101 * AvgH)
            - 4.686035
        )
        + 0.3 * AvgT
        AS WBGT,

        -- Discomfort Index
        0.81 * AvgT
        + 0.01 * AvgH * (0.99 * AvgT - 14.3)
        + 46.3
        AS DiscomfortIndex
    FROM CityStats
),

-- Add ComfortScore
Final AS (
    SELECT
        CityCode,
        CityEn,
        CountryCode,
        ROUND(AvgT, 2)            AS AvgT,
        ROUND(AvgH, 2)            AS AvgH,
        ROUND(HeatIndex, 2)       AS HeatIndex,
        ROUND(WetBulb, 2)         AS WetBulb,
        ROUND(WBGT, 2)            AS WBGT,
        ROUND(DiscomfortIndex, 2) AS DiscomfortIndex,

        -- Comfort score calculation
        ROUND(
            (24 - ABS(AvgT - 21)) * 0.4 +
            (60 - ABS(AvgH - 50)) * 0.2 +
            (60 - DiscomfortIndex) * 0.2 +
            (27 - HeatIndex)       * 0.1 +
            (24 - WetBulb)         * 0.1,
            2
        ) AS ComfortScore
    FROM Metrics
)

-- Output with ranking + FromDateStr + ToDateStr
SELECT
    RANK() OVER (ORDER BY ComfortScore DESC) AS Ranking,
    @FromDateStr AS FromDate,
    @ToDateStr   AS ToDate,
    CityCode,
    CityEn,
    CountryCode,
    AvgT,
    AvgH,
    HeatIndex,
    WetBulb,
    WBGT,
    DiscomfortIndex,
    ComfortScore
FROM Final
ORDER BY Ranking;

--SQL END ---
;
";