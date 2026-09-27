🌍 City Addition Guide (English Version)
1. Add a City to the Daily HTML
📌 Script Used
C:\weather\Script\convert_to_html.ps1

📌 Dictionary Files to Update
Add the new city name to all daily dictionaries:

C:\weather\config\dictionary_daily.json
C:\weather\config\dictionary_ptbr.json
C:\weather\config\dictionary_ar.json
C:\weather\config\dictionary_vi.json
C:\weather\config\dictionary_ko.json
C:\weather\config\dictionary_zh.json
C:\weather\config\dictionary_ru.json


Each dictionary corresponds to a language version of the daily weather report.

2. Add a City to weather_viewer.py
📌 Country Name Dictionary
If the new city uses a country code not yet registered,
add it to:

C:\weather\config\country_fullname.json

This file expands country codes (e.g., US → UNITED STATES).

3. Add a City to the Weekly English HTML
📌 English Dictionary
Add the city name to:

C:\weather\config\dictionary.json

This dictionary is used for the weekly English weather report.