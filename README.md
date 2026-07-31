# 🌍 Weather Report (GitHub Pages)
Automatically generates multilingual weather & discomfort index (DI) reports every 4 hours using OpenWeatherMap API.

🔗 **Live Weather Report**  
https://yahikoyama.github.io/weather2/

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
| 🇬🇧 English | https://yahikoyama.github.io/weather2/weather_report_now_en.html | Every morning (JST) |
| 🇷🇺 Russian | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | Every morning (JST) |
| 🇨🇳 Chinese (Simplified) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | Every morning (JST) |
| 🇰🇷 Korean | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | Every morning (JST) |
| 🇻🇳 Vietnamese | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | Every morning (JST) |

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
├── weather_report_now_fr.html # French report
├── weather_report_now_ko.html # Korean report
├── weather_report_now_ru.html # Russian report
├── weather_report_now_zh.html # Chinese report
├── weather_report_now_vi.html # Vietnamese report
