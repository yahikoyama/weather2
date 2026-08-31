-- ★ 期間指定（ユーザーが変更する部分）
DECLARE @FromDate DATE;
DECLARE @ToDate   DATE;

SET @FromDate = '2026-08-01';
SET @ToDate   = '2026-08-31';

SELECT
    w.LogDate      AS 観測日,
    c.CityJp       AS 地域名,
    w.TimeSlot     AS 時間帯,

    w.Temperature  AS 気温,
    w.Humidity     AS 湿度,

    -- WBGT計算（簡易式）
    (0.7 * w.Temperature)
        + (0.3 * (w.Temperature * w.Humidity / 100.0)) AS WBGT,

    -- WBGT危険レベル（日本語）
    CASE
        WHEN (0.7 * w.Temperature)
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 31
            THEN '危険（運動禁止）'
        WHEN (0.7 * w.Temperature)
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 28
            THEN '厳重警戒'
        WHEN (0.7 * w.Temperature)
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 25
            THEN '警戒'
        WHEN (0.7 * w.Temperature)
             + (0.3 * (w.Temperature * w.Humidity / 100.0)) >= 21
            THEN '注意'
        ELSE '安全'
    END AS WBGTレベル

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
    c.CityJp ASC;
