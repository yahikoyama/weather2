-- ★ 変数を宣言
DECLARE @FromDate DATE;
DECLARE @ToDate   DATE;

-- ★ ユーザーが変更する部分（期間指定）
SET @FromDate = '2026-08-01';
SET @ToDate   = '2026-08-31';

SELECT
    w.LogDate      AS 観測日,
    w.TimeSlot     AS 時間帯,        -- ★ ここを TimeSlot に修正
    c.CityJp       AS 地域名,
    w.Temperature  AS 気温,
    w.Humidity     AS 湿度
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
