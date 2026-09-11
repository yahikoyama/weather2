# 🌍 全球不舒适指数（每 4 小时更新）

## 👉 **多语言全球天气报告 — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_en.html">
<img width="1280" alt="Daily Weather Report Screenshot" src="https://github.com/user-attachments/assets/c794a36d-a4bf-4905-9ff1-9d7591c2480a" />
</a>

---

# 🌦️ 每日天气报告（自动更新）

| 语言 | URL | 更新频率 |
|------|-----|-----------|
| 🇯🇵 日语 | https://yahikoyama.github.io/weather2/weather_report_now.html | 每 4 小时 |
| 🇬🇧 英语 | https://yahikoyama.github.io/weather2/weather_report_now_en.html | 每 4 小时（JST） |
| 🇷🇺 俄语 | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | 每 4 小时（JST） |
| 🇨🇳 简体中文 | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | 每 4 小时（JST） |
| 🇰🇷 韩语 | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | 每 4 小时（JST） |
| 🇻🇳 越南语 | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | 每 4 小时（JST） |
| 🇦🇪 阿拉伯语 | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | 每 4 小时（JST） |
| 🇧🇷 巴西葡萄牙语 | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | 每 4 小时（JST） |

---

# 📜 历史天气报告

每日天气与不舒适指数（DI）档案：

- 🇬🇧 英文版  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 日文版  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 每日指数  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html

---

本项目每 4 小时可视化全球不舒适指数。  
您可以查看哪些城市炎热、寒冷、潮湿或舒适。

---

# 📌 概述

本项目使用 **OpenWeatherMap API** 的实时数据，  
根据 **气温、湿度、天气状况** 计算 **不舒适指数（DI）**，并自动生成天气报告。

- ⏱ **每 4 小时自动更新**  
- 🌐 **支持 8 种语言**  
- 📊 **包含历史档案**  
- ⚙️ **通过 PowerShell + SQL Server + Python + GitHub Pages 完全自动化**

适用于：
- 天气监测  
- 中暑风险评估  
- 环境观察  
- 自动化学习（PowerShell / SQL / Python）

---

# 📘 项目说明

本项目自动收集全球天气数据（气温、湿度、天气状况），  
计算 **不舒适指数（DI）**，并在 **GitHub Pages** 发布多语言天气报告。

也适用于学习：
- SQL 数据库  
- PowerShell 自动化  
- Python 数据处理  
- 多语言 HTML 生成  
- GitHub Pages 发布流程

如需添加城市，请在 **CityMaster** 表中插入记录。

---

# 🏗️ 系统架构

### 使用技术
- Windows 11 Pro（任务计划程序自动化）
- PowerShell 5.1
- Microsoft SQL Server Express 2022（最大 10GB）
- Python 3.14 + pyodbc（ODBC 驱动）

---

## 📦 GitHub 仓库内容

原先包含在 **weather.zip** 中的所有文件  
现在已在 GitHub 仓库中以文件夹形式提供。

包含：

- 完整源代码  
- SQL Server 数据库脚本与备份  
- 配置模板（config.ps1、sql1.ps1 等）  
- 自动化脚本（BAT / PowerShell）  
- 任务计划程序 XML（自动执行）

请根据您的环境配置相关文件，  
如需自动执行，请导入任务计划程序 XML。

📩 联系方式: **yahikoyama.777@gmail.com**

---

# 🌐 可用语言

[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

---

# 🚀 快速开始

### 1. 克隆仓库

weather2/
├── Historical/                # 日文档案
├── Historical_en/             # 英文档案
├── SRC_DB_SETTING/            # 数据库备份与配置文件
├── DBBackup/                  # SQL Server 每日备份
├── weather_report_now.html    # 日文报告
├── weather_report_now_en.html # 英文报告
├── weather_report_now_ko.html # 韩文报告
├── weather_report_now_ru.html # 俄文报告
├── weather_report_now_zh.html # 中文报告
├── weather_report_now_vi.html # 越南文报告
├── weather_report_now_ar.html # 阿拉伯文报告
├── weather_report_now_ptbr.html # 巴西葡萄牙文报告

🌐 多语言天气报告生成任务
| XML 文件 | 功能 | 时间表 |
| --- | --- | --- |
| get-temp-data.xml | 获取 API 天气数据 → 写入 SQL Server | 触发执行 |
| make-txt-file.xml | 生成文本数据 | 每 4 小时 |
| export_jp_latest_sync_html.xml | 生成多语言 HTML → 上传至 GitHub | 每 4 小时 |
| Historicaldata_daily.xml | 生成每日天气数据 | 每天 14:00 JST |

📜 历史数据生成任务
| XML 文件 | 功能 | 时间表 |
| --- | --- | --- |
| calc_weekly_avg.xml | 计算每周平均 → 生成 HTML → 上传至 GitHub | 每周 |

🖥️ 服务器管理任务
| XML 文件 | 功能 | 时间表 |
| --- | --- | --- |
| DBbackup.xml | SQL Server 备份 | 定期 |
| DBbackupSync.xml | 上传数据库备份至 GitHub | 备份后 |
| reboot.xml | 系统重启 | 定期 |

🔧 其他任务
| XML 文件 | 功能 | 时间表 |
| --- | --- | --- |
| historical_index_for_claude.xml | 为 Claude 生成历史索引 | 定期 |
| OneDriveToGithub.xml | 14:00 获取数据 → 15:00 上传至 GitHub | 每天 |
| auto_check_weather_update_daily.xml | 检查 HTML 更新 → 必要时重新执行 | 每 4 小时 |

🔎 SEO 关键词
不舒适指数（DI）

WBGT（湿球黑球温度）

全球天气

日本天气

湿度 / 气温

OpenWeatherMap API

天气可视化

GitHub Pages 自动化

PowerShell 自动化

SQL Server 天气数据库

📁 SQL 脚本（Data-Extraction-SQL）
daily_data_en.sql
daily_data_jp.sql
wbgt_en.sql
wbgt_jp.sql
discomfort_index_en.sql
discomfort_index_jp.sql
city_list_en.sql
city_list_jp.sql
weathercode_en.sql
weathercode_jp.sql
weathercode_list_en.sql
weathercode_list_jp.sql

☀️ WBGT（湿球黑球温度）— SQL 直接计算
WBGT 可仅通过气温与湿度计算，无需外部 API。

公式：WBGT = 0.7T + 0.3(T × H / 100)

精度约 ±1–2°C，适用于热风险评估。

😓 不舒适指数（DI）
discomfort_index_en.sql

discomfort_index_jp.sql

根据气温与湿度计算 DI，
输出英文与日文的舒适度等级。

🌤 每日天气数据
daily_data_en.sql

daily_data_jp.sql

🏙 城市列表
city_list_en.sql

city_list_jp.sql

🌦 天气代码
weathercode_en.sql

weathercode_jp.sql

weathercode_list_en.sql

weathercode_list_jp.sql

```bash
git clone https://github.com/yahikoyama/weather2
