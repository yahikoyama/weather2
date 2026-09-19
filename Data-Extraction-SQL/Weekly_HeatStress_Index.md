📝 Overview
This SQL script calculates advanced meteorological metrics for each city over the last 7 days, including:

Heat Index (HI)

Wet-bulb Temperature (Tw)

WBGT (Heat Stress Index)

Discomfort Index (DI)

The query aggregates daily averages of temperature and humidity from WeatherLog, joins city information from CityMaster, and outputs results with:

CityCode

CityEn (English city name)

CountryCode

Daily metrics (rounded to 2 decimals)

Latest dates shown first

🔢 Formulas Used
🌡️ Heat Index (HI)
NOAA standard formula (Celsius version):
HI = -8.784695
     + 1.61139411*T
     + 2.338549*H
     - 0.14611605*T*H
     - 0.012308094*T^2
     - 0.016424828*H^2
     + 0.002211732*T^2*H
     + 0.00072546*T*H^2
     - 0.000003582*T^2*H^2

🧊 Wet-bulb Temperature (Tw)
Approximation formula using temperature (T) and humidity (H):
Tw = T * atan(0.151977 * sqrt(H + 8))
     + atan(T + H)
     - atan(H - 1.676331)
     + 0.00391838 * H^(3/2) * atan(0.023101 * H)
     - 4.686035
     
🥵 WBGT (Indoor Approximation)
WBGT is mainly determined by Wet-bulb temperature:

WBGT = 0.7 * Tw + 0.3 * T

| Column | Description |
| --- | --- |
| CityCode | City identifier |
| CityEn | English city name |
| CountryCode | Country code (ISO) |
| LogDate | Date of aggregated weather data |
| AvgT | Average temperature (°C) |
| AvgH | Average humidity (%) |
| HeatIndex | Calculated HI |
| WetBulb | Calculated Tw |
| WBGT | Calculated heat stress index |
| DiscomfortIndex | Calculated DI |


