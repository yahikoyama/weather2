# 🌍 Global Discomfort Index (Updated every 4 hours)

## 👉 **Live Weather Report**
### https://yahikoyama.github.io/weather2/


<img width="640" alt="Daily Weather Report Screenshot" src="https://github.com/user-attachments/assets/c794a36d-a4bf-4905-9ff1-9d7591c2480a" />

---

## 🌐 Available Languages
[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

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

# 🏗️ System Architecture


### Technologies Used
- Windows 11 Pro (Task Scheduler automation)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (max size 10GB)
- Python 3.14 + pyodbc (ODBC driver)

### Included in **weather.zip**
- Full source code  
- SQL Server database backup  
- Configuration templates  
- Task Scheduler XML (auto-execution)

Please configure the **conf** files according to your environment and import the Task Scheduler XML.

📩 Contact: **yahikoyama.777@gmail.com**

---

# 🌦️ Daily Weather Reports (Auto-updated)

| Language | URL | Update Frequency |
|---------|-----|------------------|
| 🇯🇵 Japanese | https://yahikoyama.github.io/weather2/weather_report_now.html | Every 4 hours |
| 🇬🇧 English | https://yahikoyama.github.io/weather2/weather_report_now_en.html | Every 4 hours (JST) |
| 🇷🇺 Russian | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | Every 4 hours (JST) |
| 🇨🇳 Chinese (Simplified) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | Every 4 hours (JST) |
| 🇰🇷 Korean | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | Every 4 hours (JST) |
| 🇻🇳 Vietnamese | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | Every 4 hours (JST) |

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

unzip weather.zip
c:\weather
├─config        # Configuration files (DB, API, GitHub) and dictionaries
├─Data          # cities.csv (not used if you restore the DB backup file)
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


## 🌐 Multi‑Language Weather Reports
| XML File                     | Purpose                                                   | Schedule              |
|------------------------------|-----------------------------------------------------------|-----------------------|
| get-temp-data.xml            | Fetch weather data via API and insert into SQL Server     | Trigger-based         |
| make-txt-file.xml            | Generate text data every 4 hours                          | Every 4 hours         |
| export_jp_latest_sync_html.xml | Generate multi‑language HTML reports and upload to GitHub | Every 4 hours       |
| Historicaldata_daily.xml     | Generate daily weather data                               | Daily at 14:00 JST    |

## 📜 Historical Weather Reports
| XML File          | Purpose                                                        | Schedule |
|-------------------|----------------------------------------------------------------|----------|
| calc_weekly_avg.xml | Calculate weekly averages, generate weekly HTML reports, and upload to GitHub | Weekly   |

## 🖥️ Server Management
| XML File        | Purpose                               | Schedule              |
|-----------------|---------------------------------------|-----------------------|
| DBbackup.xml    | SQL Server database backup            | Scheduled             |
| DBbackupSync.xml| Upload DB backup file to GitHub       | After DB backup       |
| reboot.xml      | System reboot task                    | Scheduled             |

## 🔧 Miscellaneous Tasks
| XML File                    | Purpose                                      | Schedule |
|-----------------------------|----------------------------------------------|----------|
| historical_index_for_claude.xml | Generate historical index for Claude         | Scheduled |
| OneDriveToGithub.xml        | Fetch data at 14:00 and upload to GitHub at 15:00 | Daily     |

