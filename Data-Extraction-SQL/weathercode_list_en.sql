SELECT
    WeatherCode      AS WeatherCode,
    WeatherGroup     AS WeatherNameEn,
    WeatherNameJp    AS WeatherNameJp
FROM
    WeatherCodeMaster
ORDER BY
    WeatherCode ASC;
