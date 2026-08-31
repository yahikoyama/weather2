SELECT
    CityCode     AS CityCode,
    CityEn       AS CityName,
    Latitude     AS Latitude,
    Longitude    AS Longitude,
    CountryCode  AS CountryCode
FROM
    CityMaster
ORDER BY
    CityEn ASC;
