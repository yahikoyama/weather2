City Addition Procedure
This document describes the complete workflow for adding a new city to the weather system.
Follow all steps to ensure the city appears correctly in Daily HTML, Weekly HTML, Python viewer, and all multilingual dictionary files.

## 1. Add the City to the CityMaster Table
Insert the new city into the database using the following SQL scripts:

【Insert】add-city.sql

【Insert】add-city2.sql

These scripts register the city ID, city name, country code, and related metadata required by downstream processes.

## 2. Add the City to the Daily HTML Output
Modify the PowerShell script responsible for generating Daily HTML:

C:\weather\Script\convert_to_html.ps1

Add the new city to the section where Daily HTML pages are generated.
This ensures the city appears in the daily weather report.

## 3. Add the City to All Dictionary Files
Add the city name to every dictionary file used for multilingual output.

📌 Dictionary files to update:

C:\weather\config\dictionary_daily.json
C:\weather\config\dictionary_ptbr.json
C:\weather\config\dictionary_ar.json
C:\weather\config\dictionary_vi.json
C:\weather\config\dictionary_ko.json
C:\weather\config\dictionary_zh.json
C:\weather\config\dictionary_ru.json

Each dictionary must contain:

"city_code": "City Name in that language"

Ensure encoding is UTF‑8

Maintain alphabetical or existing ordering rules

## 4. Add the City to weather_viewer.py
The Python viewer uses a separate dictionary for country names.

📌 Dictionary file used:

C:\weather\config\country_fullname.json


If the city belongs to a country whose country code is not yet registered, add it here:

Example:

"JP": "Japan",
"US": "United States",
"KR": "Korea"

This ensures the viewer displays the correct full country name.

## 5. Add the City to the Weekly English HTML
Weekly English HTML uses a different dictionary:

📌 Dictionary file used:

C:\weather\config\dictionary.json

Add the English city name here.
This dictionary is used exclusively for the English Weekly Report.



