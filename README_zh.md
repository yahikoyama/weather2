# Weather Report（GitHub Pages）
https://yahikoyama.github.io/weather2/

本项目用于通过全球天气数据来学习
**数据库系统（SQL）和编程技术**。

系统从 OpenWeatherMap API 获取气温、湿度和天气状况，
并自动计算 **不舒适指数（Discomfort Index：DI）**，
帮助找出世界上较凉爽的地区，为减缓全球变暖提供参考信息。

如果您想添加新的城市，请在 **CityMaster** 表中插入记录。

---

## ■ 系统概述

本系统采用 Client/Server 架构，使用以下环境：

- Windows 11 Pro（任务计划程序）
- PowerShell 5.1
- Microsoft SQL Server Express 2022（最大 10GB）
- Python 3.14（使用 pyodbc ODBC 驱动）

**weather.zip** 包含：
- 全部源代码  
- 数据库备份  

请根据您的环境配置 **conf 文件**，  
并导入任务计划程序的 **XML 文件**。

---

## ■ 每日更新报告（每 4 小时自动更新）
https://yahikoyama.github.io/weather2/weather_report_now_zh.html

---

## ■ 历史报告列表（Historical）
https://yahikoyama.github.io/weather2/Historical/

---

## ■ 联系方式
yahikoyama.777@gmail.com
