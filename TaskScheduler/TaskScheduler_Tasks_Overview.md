# 🗂️ Task Scheduler XML — Overview

This document provides a structured overview of all Task Scheduler XML files used in the **weather automation system**.  
Each XML file defines an automated task responsible for data collection, report generation, database maintenance, or system operations.

---

## 🌐 1. Multi‑Language Weather Reports

| XML File | Description | Schedule |
|---------|-------------|----------|
| **get-temp-data.xml** | Fetch weather data via API and insert into SQL Server | Trigger-based |
| **make-txt-file.xml** | Generate text data every 4 hours | Every 4 hours |
| **export_jp_latest_sync_html.xml** | Generate multi-language HTML reports and upload to GitHub | Every 4 hours |
| **Historicaldata_daily.xml** | Generate daily weather data | Daily at **14:00 JST** |

---

## 📜 2. Historical Weather Reports

| XML File | Description | Schedule |
|---------|-------------|----------|
| **calc_weekly_avg.xml** | Calculate weekly averages, generate weekly HTML reports, and upload to GitHub | Weekly |

---

## 🖥️ 3. Server Management Tasks

| XML File | Description | Schedule |
|---------|-------------|----------|
| **DBbackup.xml** | SQL Server database backup | Scheduled |
| **DBbackupSync.xml** | Upload the database backup file to GitHub | After DB backup (trigger-based) |
| **reboot.xml** | System reboot task | Scheduled |

---

## 🔧 4. Miscellaneous Tasks

| XML File | Description | Schedule |
|---------|-------------|----------|
| **historical_index_for_claude.xml** | Generate historical index for Claude | Scheduled |
| **OneDriveToGithub.xml** | Fetch data at **14:00**, upload to GitHub at **15:00** | Daily |

---

## 📁 Directory Location

All XML files and this overview document are stored in:

