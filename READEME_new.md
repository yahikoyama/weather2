# weather2 – Global Weather Data, Discomfort Index (DI), WBGT & Multilingual Reports  
Automatically updated every 4 hours using OpenWeatherMap API

weather2 is a fully automated weather data processing project that generates:
- Discomfort Index (DI)
- WBGT (Wet Bulb Globe Temperature)
- Multilingual weather reports (8 languages)
- Historical weather datasets
- SQL-based data extraction tools
- CSV conversion automation (BAT / PowerShell)

All outputs are published on GitHub Pages and updated every 4 hours.

---

## 🌍 GitHub Pages (Live Weather Reports)
Real-time weather reports in 8 languages:

- 🇯🇵 Japanese  
- 🇺🇸 English  
- 🇷🇺 Russian  
- 🇨🇳 Chinese (Simplified)  
- 🇰🇷 Korean  
- 🇻🇳 Vietnamese  
- 🇦🇪 Arabic  
- 🇧🇷 Brazilian Portuguese  

**Live site:**  
https://yahikoyama.github.io/weather2/

---

## 📄 Sitemap (Updated Every day)
This sitemap is automatically regenerated every 4 hours to ensure
search engines always receive the latest weather report URLs.

https://yahikoyama.github.io/weather2/sitemap.xml

---

## 💾 Source Code, SQL Database & SQL Scripts
This repository contains all SQL files used for:
- Discomfort Index (DI)
- WBGT calculation
- City metadata
- Weather codes
- Historical weather extraction
- Multi-language data processing

Example SQL scripts included:
- wbgt_en.sql / wbgt_jp.sql
- discomfort_index_en.sql / discomfort_index_jp.sql
- city_list_en.sql / city_list_jp.sql
- weathercode_list_en.sql / weathercode_list_jp.sql

SQL files are located here:  
https://github.com/yahikoyama/weather2/tree/main/Data-Extraction-SQL

---

## 🔧 SQL → CSV Automation (BAT & PowerShell)
Sample scripts for converting SQL query results into CSV files:

- `.bat` automation  
- `.ps1` PowerShell automation  

These automation samples show how to:
- Run SQL queries automatically
- Export results to CSV
- Schedule periodic data extraction

Samples:  
https://github.com/yahikoyama/weather2/tree/main/db_sql2csv

---

## 📚 Historical Weather Reports (GitHub Pages)
- English: https://yahikoyama.github.io/weather2/Historical_en/  
- Japanese: https://yahikoyama.github.io/weather2/Historical/

---

## ⚙️ Automated GitHub Pages Deployment
The entire workflow is automated:
- SQL execution  
- Data formatting  
- Multi-language generation  
- Sitemap update  
- GitHub Pages publishing  

Updates occur every **4 hours**.

---

## 🧩 Technologies Used
- OpenWeatherMap API  
- SQL Server Express 2022  
- SQL (multiple datasets)  
- GitHub Actions  
- GitHub Pages  
- PowerShell / BAT automation  
- JSON / CSV data processing  

---

## 📌 Repository Topics (Recommended)
weather, weather-api, openweathermap, sql, csv,
wbgt, discomfort-index, multilingual, github-pages,
automation, data-extraction, meteorology, climate-data


---

## 📈 Project Goals
- Provide simple, fast, multilingual weather insights  
- Offer reusable SQL datasets for developers  
- Enable automated weather data extraction  
- Support heat countermeasures and environmental monitoring  
- Provide SQL examples for learning and data processing practice  

---

## 📬 Contact
Maintainer: **Yahikoyama**  
GitHub: https://github.com/yahikoyama
