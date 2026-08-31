SELECT
    WeatherCode      AS 天気コード,
    WeatherNameJp    AS 天気名,
    WeatherGroup     AS 天気名英語
FROM
    WeatherCodeMaster
ORDER BY
    WeatherCode ASC;
