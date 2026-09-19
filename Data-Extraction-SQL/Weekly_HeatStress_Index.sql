DECLARE 
    @FromDate DATE,
    @ToDate DATE;

-- Бе Last 7 days (excluding today)
SET @FromDate = DATEADD(DAY, -7, CAST(GETDATE() AS DATE));
SET @ToDate   = DATEADD(DAY, -1, CAST(GETDATE() AS DATE));

SELECT
    W.CityCode,
    C.CityEn,        -- English city name
    C.CountryCode,   -- Бе CountryCode added here
    CAST(W.CreatedAt AS DATE) AS LogDate,
    ROUND(AVG(W.Temperature), 2) AS AvgT,
    ROUND(AVG(W.Humidity), 2) AS AvgH,

    -- Бе Heat Index (rounded to 2 decimals)
    ROUND(
        -8.784695
        + 1.61139411 * AVG(W.Temperature)
        + 2.338549   * AVG(W.Humidity)
        - 0.14611605 * AVG(W.Temperature) * AVG(W.Humidity)
        - 0.012308094 * POWER(AVG(W.Temperature), 2)
        - 0.016424828 * POWER(AVG(W.Humidity), 2)
        + 0.002211732 * POWER(AVG(W.Temperature), 2) * AVG(W.Humidity)
        + 0.00072546  * AVG(W.Temperature) * POWER(AVG(W.Humidity), 2)
        - 0.000003582 * POWER(AVG(W.Temperature), 2) * POWER(AVG(W.Humidity), 2),
        2
    ) AS HeatIndex,

    -- Бе Wet-bulb temperature (rounded to 2 decimals)
    ROUND(
        AVG(W.Temperature) * ATAN(0.151977 * SQRT(AVG(W.Humidity) + 8))
        + ATAN(AVG(W.Temperature) + AVG(W.Humidity))
        - ATAN(AVG(W.Humidity) - 1.676331)
        + 0.00391838 * POWER(AVG(W.Humidity), 1.5) * ATAN(0.023101 * AVG(W.Humidity))
        - 4.686035,
        2
    ) AS WetBulb,

    -- Бе WBGT (rounded to 2 decimals)
    ROUND(
        0.7 * (
            AVG(W.Temperature) * ATAN(0.151977 * SQRT(AVG(W.Humidity) + 8))
            + ATAN(AVG(W.Temperature) + AVG(W.Humidity))
            - ATAN(AVG(W.Humidity) - 1.676331)
            + 0.00391838 * POWER(AVG(W.Humidity), 1.5) * ATAN(0.023101 * AVG(W.Humidity))
            - 4.686035
        )
        + 0.3 * AVG(W.Temperature),
        2
    ) AS WBGT,

    -- Бе Discomfort Index (rounded to 2 decimals)
    ROUND(
        0.81 * AVG(W.Temperature)
        + 0.01 * AVG(W.Humidity) * (0.99 * AVG(W.Temperature) - 14.3)
        + 46.3,
        2
    ) AS DiscomfortIndex

FROM WeatherLog W
JOIN CityMaster C
    ON W.CityCode = C.CityCode
WHERE CAST(W.CreatedAt AS DATE) BETWEEN @FromDate AND @ToDate
GROUP BY W.CityCode, C.CityEn, C.CountryCode, CAST(W.CreatedAt AS DATE)

-- Бе Latest date first
ORDER BY LogDate DESC, CityCode;
