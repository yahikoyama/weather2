-- ★ 期間指定（ユーザーが変更する部分）
DECLARE @FromDate DATE;
DECLARE @ToDate   DATE;
DECLARE @WeatherCode INT;

SET @FromDate = '2026-08-01';
SET @ToDate   = '2026-08-31';
SET @WeatherCode = 804;   -- ← 例：804=曇り、800=晴れ

SELECT
    w.LogDate      AS 観測日,
    c.CityJp       AS 地域名,
    w.TimeSlot     AS 時間帯,
    w.Temperature  AS 気温,
    w.Humidity     AS 湿度,
    wc.WeatherCode AS 天気コード,
    wc.WeatherNameJp AS 天気名
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
    c.CityJp ASC,
    w.TimeSlot ASC;
