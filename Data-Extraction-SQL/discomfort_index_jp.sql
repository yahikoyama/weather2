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

    -- 不快指数（DI）計算式
    (0.81 * w.Temperature)
        + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
        + 46.3 AS 不快指数,

    -- 不快指数レベル（日本語）
    CASE
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 <= 50
            THEN '寒くてたまらない'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 <= 55
            THEN '寒い'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 <= 60
            THEN '肌寒い'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 <= 65
            THEN '何も感じない'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 <= 70
            THEN '快適'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 <= 75
            THEN '不快感出始め'
        WHEN (0.81 * w.Temperature)
             + (0.01 * w.Humidity * (0.99 * w.Temperature - 14.3))
             + 46.3 <= 80
            THEN '半数が不快'
        ELSE '全員不快'
    END AS 不快指数レベル

FROM
    WeatherLog w
    INNER JOIN CityMaster c
        ON w.CityCode = c.CityCode
WHERE
    w.LogDate >= @FromDate
    AND w.LogDate <= @ToDate
ORDER BY
    w.LogDate ASC,
    c.CityJp ASC,
    w.TimeSlot ASC;
