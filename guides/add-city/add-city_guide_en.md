📝 How to Add a City (Updated)
(1) Automatically Add a City Using the Tool
Step 1: Copy the Tool

Copy tool/add_city_gui_2.py to:

C:\weather\tool\

Download:

https://github.com/yahikoyama/weather2/blob/main/tool/add_city_gui_2.py

Step 2: Launch the Tool

Open Command Prompt and run:

`cd C:\weather\tool`

`add_city_gui_2.py`


Step 3: Prepare City Registration Data

Prepare a registration file such as:

4037Macau.txt

(You can generate the content with AI assistance.)

Paste the registration data into the text box displayed by the tool.

Step 4: Register the City
CityCode is automatically assigned as MAX + 1.
You can manually change the CityCode if necessary.
Click the RegisterCity button.

The following items will be updated automatically:

CityMaster table
Dictionary files
After Registration

When registration completes:

The input box is cleared automatically.
The CityCode is incremented by 1 for the next city.
Automatic Backup

Before any dictionary file is modified, a backup is created automatically.

Example:

country_fullname.json.20261117_193720.bak

Backup format:

<FileName>_<Date>_<Time>.bak

Delete a City (Manual SQL)

To delete a city from the table, run SQL manually:

DELETE FROM CityMaster
WHERE CityCode = '4037';

Delete a Backup Table (Manual SQL)

To remove an old backup table, run SQL manually.

Example:

DROP TABLE CityMaster_BK_20261124_220204;


(2) Manually Add a City (Without Using the Tool)

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



