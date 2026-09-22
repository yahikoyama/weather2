# 🌍 Global Discomfort Index (Updated every 4 hours)

## 👉 **Live Global Weather Report — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_en.html">
<img width="1280" alt="Daily Weather Report Screenshot" src="https://github.com/user-attachments/assets/c794a36d-a4bf-4905-9ff1-9d7591c2480a" />
</a>
# 🌦️ Daily Weather Reports (Auto-updated)

| Language | URL | Update Frequency |
|---------|-----|------------------|
| 🇯🇵 Japanese | https://yahikoyama.github.io/weather2/weather_report_now.html | Every 4 hours |
| 🇬🇧 English | https://yahikoyama.github.io/weather2/weather_report_now_en.html | Every 4 hours (JST) |
| 🇷🇺 Russian | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | Every 4 hours (JST) |
| 🇨🇳 Chinese (Simplified) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | Every 4 hours (JST) |
| 🇰🇷 Korean | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | Every 4 hours (JST) |
| 🇻🇳 Vietnamese | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | Every 4 hours (JST) |
| ar Arabic | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | Every 4 hours (JST) |
| br Brazilian Portuguese | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | Every 4 hours (JST) |
---

# 📜 Historical Weather Reports

Daily archived weather & DI data:

- 🇬🇧 English:  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 Japanese:  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 Daily Index:  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html
---
This project visualizes global discomfort index every 4 hours.
You can check which cities feel hot, cold, humid, or comfortable.



---
## 📌 Overview  
This project provides **automatically updated weather and discomfort index (DI) reports** using real-time data from the **OpenWeatherMap API**.  
The discomfort index is calculated from **temperature**, **humidity**, and **weather conditions**, offering a clear indicator of how hot or humid the environment feels.

- ⏱ Updates every **4 hours**  
- 🌐 Supports **multiple languages**  
- 📊 Includes **historical archives**  
- ⚙️ Fully automated via **PowerShell + SQL Server + Python + GitHub Pages**

This repository is designed for **weather monitoring**, **heat countermeasures**, **environmental observation**, and **automation study**.

---

# 📘 Project Overview
This project automatically collects global weather data (temperature, humidity, weather conditions) from the **OpenWeatherMap API**, calculates the **Discomfort Index (DI)**, and publishes multilingual weather reports on **GitHub Pages**.

It also serves as a practical study project for:
- SQL database systems  
- PowerShell automation  
- Python data processing  
- Multilingual HTML generation  
- GitHub Pages publishing  

If you want to add additional cities, please insert records into the **CityMaster** table.

---
AI Search Guide:
https://yahikoyama.github.io/weather2/ai_search.html


# 🏗️ System Architecture


### Technologies Used
- Windows 11 Pro (Task Scheduler automation)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (max size 10GB)
- Python 3.14 + pyodbc (ODBC driver)

📦 Included Files (GitHub Repository)
All files that were previously distributed in weather.zip  
are now fully available directly in this GitHub repository.

The following components are provided as individual folders:

Full source code

SQL Server database scripts & backups

Configuration templates (config.ps1, sql1.ps1, etc.)

Automation scripts (BAT / PowerShell)

Task Scheduler XML for auto‑execution

Please configure the files according to your environment and
import the Task Scheduler XML if you want automatic execution.

📩 Contact: **yahikoyama.777@gmail.com**

---
## 🌐 Available Languages
[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)


---

# 🚀 Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/yahikoyama/weather2

weather2/
├── Historical/                # Japanese Archived weather reports 
├── Historical_en/             # English Archived weather reports
├── SRC_DB_SETTING/ weather.zip  # Source + DB backup  +  SQL Server conf + API conf
├── DBBackup/                   # Daily SQL Server Backup file
├── weather_report_now.html    # Japanese report
├── weather_report_now_en.html # English report
├── weather_report_now_ko.html # Korean report
├── weather_report_now_ru.html # Russian report
├── weather_report_now_zh.html # Chinese report
├── weather_report_now_vi.html # Vietnamese report
├── weather_report_now_ar.html # Arabic report
├── weather_report_now_ptbr.html # Brazilian Portuguese report

download weather2
c:\weather
├─config        # Configuration files (DB, API, GitHub) and dictionaries
├─Data          # cities.csv (not used if you restore the DB backup file)
├─Data-Extraction-SQL    # Data extraction tool
├─DBBackup      # SQL Server backup file
├─Logs          # Not used
├─output        # index.html, jp_result.txt (generated at JST 14:00)
├─Script        # PowerShell scripts, batch files (calling PS1), and Python scripts
├─Setup         # Setup instructions and environment preparation
└─TaskScheduler # Task Scheduler XML definitions
      ├─get-temp-data.xml
      ├─make-txt-file.xml
      ├─export_jp_latest_sync_html.xml
      ├─Historicaldata_daily.xml
      ├─calc_weekly_avg.xml
      ├─DBbackup.xml
      ├─DBbackupSync.xml
      ├─reboot.xml
      ├─historical_index_for_claude.xml
      ├─OneDriveToGithub.xml
      ├─auto_check_weather_update_daily.xml
      ├─weekly_comfortable_region.xml

c:\winserverroot\OneDrive
├─Historical        # Historical data JP
├─Historical_en     # Historical data EN


## 🌐 Multi‑Language Weather Reports
| XML File                     | Purpose                                                   | Schedule              |
|------------------------------|-----------------------------------------------------------|-----------------------|
| get-temp-data.xml            | Fetch weather data via API and insert into SQL Server     | Trigger-based         |
| make-txt-file.xml            | Generate text data every 4 hours                          | Every 4 hours         |
| export_jp_latest_sync_html.xml | Generate multi‑language HTML reports and upload to GitHub | Every 4 hours       |
| Historicaldata_daily.xml     | Generate daily weather data                               | Daily at 14:00 JST    |

## 📜 Historical Weather Reports
| XML File            | Purpose                                                                       | Schedule |
|---------------------|-------------------------------------------------------------------------------|----------|
| calc_weekly_avg.xml | Calculate weekly averages, generate weekly HTML reports, and upload to GitHub | Weekly   |
|weekly_comfortable_region.xml | Calculate WBGT and discomfort index and comfortable Index            | Weekly   |

## 🖥️ Server Management
| XML File        | Purpose                               | Schedule              |
|-----------------|---------------------------------------|-----------------------|
| DBbackup.xml    | SQL Server database backup            | Scheduled             |
| DBbackupSync.xml| Upload DB backup file to GitHub       | After DB backup       |
| reboot.xml      | System reboot task                    | Scheduled             |

## 🔧 Miscellaneous Tasks
| XML File                         | Purpose                                           | Schedule |
|----------------------------------|---------------------------------------------------|----------|
| historical_index_for_claude.xml  | Generate historical index for Claude              | Scheduled |
| OneDriveToGithub.xml        　　 | Fetch data at 14:00 and upload to GitHub at 15:00  | Daily     |
|auto_check_weather_update_daily.xml| report html data update check and run task again | Every 4 hours|

## 🔎 SEO Keywords  
To improve discoverability, this project focuses on the following topics:

- Discomfort Index (DI)  
- `Comfortable Index(Original)`
- WBGT
- Global Weather  
- Japan Weather  
- Humidity / Temperature  
- OpenWeatherMap API  
- Weather Visualization  
- GitHub Pages Weather Automation  
- PowerShell Weather Automation  
- SQL Server Weather Database  

---
Data-Extraction-SQL/
 ├─ daily_data_en.sql
 ├─ daily_data_jp.sql
 ├─ wbgt_en.sql
 ├─ wbgt_jp.sql
 ├─ discomfort_index_en.sql
 ├─ discomfort_index_jp.sql
 ├─ city_list_en.sql
 ├─ city_list_jp.sql
 ├─ weathercode_en.sql
 ├─ weathercode_jp.sql
 ├─ weathercode_list_en.sql
 ├─ weathercode_list_jp.sql
 ├─ Weekly_HeatStress_Index.sql
 └─ ComfortableRegionFinder.sql

📁 SQL Overview
weather2 includes multiple SQL scripts to extract weather data in both English and Japanese.
Each script is designed for general users, analysts, and developers.

☀️ WBGT (Heat Index) — Calculated Directly in SQL
This is one of the strongest features of weather2:

WBGT (heat index) can be calculated directly using SQL.  
No external API, no additional libraries — only temperature and humidity.

WBGT is calculated using the internationally recognized simplified formula:

𝑊𝐵𝐺𝑇=0.7𝑇+0.3(𝑇×𝐻/100)
This provides practical accuracy (±1–2°C) for heat‑risk evaluation.

🔗 wbgt_en.sql
Calculates WBGT from temperature & humidity

Outputs English danger levels

Ideal for international users

🔗 wbgt_jp.sql
Calculates WBGT

Outputs Japanese danger levels

Popular during summer months

😓 Discomfort Index (DI)
🔗 discomfort_index_en.sql
Calculates DI

English comfort level classification

Useful for global users

🔗 discomfort_index_jp.sql
Calculates DI

Japanese comfort level classification

Uses your custom DI scale

🌤 Daily Weather Data
🔗 daily_data_en.sql
Extracts temperature, humidity, weather code

English city names

🔗 daily_data_jp.sql
Same as above

Japanese city names

🏙 City List
🔗 city_list_en.sql
CityCode / CityEn / latitude / longitude / country code

🔗 city_list_jp.sql
CityCode / CityJp / latitude / longitude / country code

🌦 Weather Code
🔗 weathercode_en.sql
Filter weather data by weather code

English weather names (WeatherGroup)

🔗 weathercode_jp.sql
Same as above

Japanese weather names (WeatherNameJp)

🔗 weathercode_list_en.sql
WeatherCode / English name / Japanese name

Useful as a reference table

🔗 weathercode_list_jp.sql

## 📘 Detailed Documentation
A full technical documentation including SQL scripts, automation samples (BAT / PowerShell),
and multilingual processing details is available here:

👉 [README_new.md](README_new.md)

## New Features Added

### 1. Weekly Heat‑Stress Index Generator
A new batch script (`Weekly_HeatStress_Index.bat`) has been added to automatically generate  
**Weekly_HeatStress_Index.csv**, summarizing the past 7 days of meteorological stress indicators  
(Heat Index, Wet‑Bulb, WBGT, and Discomfort Index) for all registered cities.

This tool is useful for:
- Weekly climate monitoring  
- Heat‑stress risk assessment  
- Educational and research use  
- Automated data‑processing workflows

The script is fully integrated into the main menu (`menu.bat`) as option **1**.

---

### 2. Comfortable Region Finder
A new batch script (`Comfortable_Region_Finder.bat`) generates  
**Comfortable_Region_Finder.csv**, ranking global cities by comfort level using a composite score  
based on temperature, humidity, Heat Index, Wet‑Bulb, WBGT, and Discomfort Index.

This feature enables:
- Identification of comfortable climate regions  
- Comparative climate analysis  
- Multi‑language reporting  
- Integration with GitHub Pages dashboards

The script is available in the main menu (`menu.bat`) as option **2**.

---

### Updated Menu Options
The project’s interactive menu now includes the new tools:

| Number | Description                         | Output File                     |
|--------|-------------------------------------|---------------------------------|
| **0**  | Generate city list                  | `city-list.csv`                 |
| **1**  | Generate weekly heat‑stress metrics | `Weekly_HeatStress_Index.csv`   |
| **2**  | Generate comfortable region ranking | `Comfortable_Region_Finder.csv` |
| **99** | Exit the menu                       | —                               |

These additions expand weather2’s capabilities for climate analysis, education, and automated data processing.


[![weather2 | AlternativeTo](https://alternativeto.net/static/badges/badge-compact-dark.svg)](https://alternativeto.net/software/weather2/about/?utm_source=badge&utm_medium=referral)


