CREATE TABLE ComfortableRegionWeekly (
    Ranking          INT,
    FromDate         VARCHAR(10),
    ToDate           VARCHAR(10),
    CityCode         VARCHAR(20),
    CityEn           VARCHAR(100),
    CountryCode      VARCHAR(10),
    AvgT             FLOAT,
    AvgH             FLOAT,
    HeatIndex        FLOAT,
    WetBulb          FLOAT,
    WBGT             FLOAT,
    DiscomfortIndex  FLOAT,
    ComfortScore     FLOAT,
    UpdatedAt        DATETIME  -- add（JST）
);
