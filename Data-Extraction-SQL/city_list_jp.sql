SELECT
    CityCode     AS 都市コード,
    CityJp       AS 地域名,
    Latitude     AS 緯度,
    Longitude    AS 経度,
    CountryCode  AS 国コード
FROM
    CityMaster
ORDER BY
    CityJp ASC;
