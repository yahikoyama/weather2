# 🌍 Глобальный индекс дискомфорта (обновляется каждые 4 часа)

## 👉 **Многоязычный глобальный погодный отчёт — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_en.html">
<img width="1280" alt="Daily Weather Report Screenshot" src="https://github.com/user-attachments/assets/c794a36d-a4bf-4905-9ff1-9d7591c2480a" />
</a>

---

# 🌦️ Ежедневные погодные отчёты (автообновление)

| Язык | URL | Частота обновления |
|------|-----|---------------------|
| 🇯🇵 Японский | https://yahikoyama.github.io/weather2/weather_report_now.html | Каждые 4 часа |
| 🇬🇧 Английский | https://yahikoyama.github.io/weather2/weather_report_now_en.html | Каждые 4 часа (JST) |
| 🇷🇺 Русский | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | Каждые 4 часа (JST) |
| 🇨🇳 Китайский (упрощённый) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | Каждые 4 часа (JST) |
| 🇰🇷 Корейский | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | Каждые 4 часа (JST) |
| 🇻🇳 Вьетнамский | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | Каждые 4 часа (JST) |
| 🇦🇪 Арабский | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | Каждые 4 часа (JST) |
| 🇧🇷 Бразильский португальский | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | Каждые 4 часа (JST) |

---

# 📜 Исторические погодные отчёты

Архив ежедневных данных о погоде и индексе дискомфорта (DI):

- 🇬🇧 Английский  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 Японский  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 Ежедневный индекс  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html

---

Этот проект визуализирует глобальный индекс дискомфорта каждые 4 часа.  
Вы можете увидеть, в каких городах жарко, холодно, влажно или комфортно.

---

# 📌 Обзор

Проект использует данные **OpenWeatherMap API** в реальном времени и вычисляет  
**индекс дискомфорта (DI)** на основе **температуры, влажности и погодных условий**.

- ⏱ Автообновление каждые **4 часа**  
- 🌐 Поддержка **8 языков**  
- 📊 Исторические архивы  
- ⚙️ Полная автоматизация через **PowerShell + SQL Server + Python + GitHub Pages**

Проект подходит для:
- мониторинга погоды  
- оценки теплового риска  
- экологического наблюдения  
- изучения автоматизации (PowerShell / SQL / Python)

---

# 📘 Описание проекта

Проект автоматически собирает глобальные данные о погоде (температура, влажность, погодные условия),  
вычисляет **индекс дискомфорта (DI)** и публикует многоязычные отчёты на **GitHub Pages**.

Также проект полезен для изучения:
- SQL‑баз данных  
- автоматизации PowerShell  
- обработки данных Python  
- генерации многоязычных HTML  
- публикации через GitHub Pages

Чтобы добавить новые города, вставьте записи в таблицу **CityMaster**.

---

# 🏗️ Архитектура системы

### Используемые технологии
- Windows 11 Pro (автоматизация через Task Scheduler)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (макс. 10 ГБ)
- Python 3.14 + pyodbc (ODBC‑драйвер)

---

## 📦 Файлы в репозитории GitHub

Все файлы, которые ранее находились в **weather.zip**,  
теперь доступны напрямую в этом репозитории в виде отдельных папок.

Включает:

- полный исходный код  
- SQL‑скрипты и резервные копии базы данных  
- шаблоны конфигурации (config.ps1, sql1.ps1 и др.)  
- скрипты автоматизации (BAT / PowerShell)  
- XML‑файлы Task Scheduler для авто‑выполнения

Настройте конфигурационные файлы под вашу среду  
и импортируйте XML‑файлы Task Scheduler при необходимости.

📩 Контакт: **yahikoyama.777@gmail.com**

---

# 🌐 Доступные языки

[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

---

# 🚀 Быстрый старт

### 1. Клонируйте репозиторий

```bash
git clone https://github.com/yahikoyama/weather2


weather2/
├── Historical/                # Японский архив
├── Historical_en/             # Английский архив
├── SRC_DB_SETTING/            # Резервная копия БД и конфигурация
├── DBBackup/                  # Ежедневная резервная копия SQL Server
├── weather_report_now.html    # Японский отчёт
├── weather_report_now_en.html # Английский отчёт
├── weather_report_now_ko.html # Корейский отчёт
├── weather_report_now_ru.html # Русский отчёт
├── weather_report_now_zh.html # Китайский отчёт
├── weather_report_now_vi.html # Вьетнамский отчёт
├── weather_report_now_ar.html # Арабский отчёт
├── weather_report_now_ptbr.html # Бразильский португальский отчёт

🌐 Задачи генерации многоязычных отчётов
| XML‑файл | Назначение | Расписание |
| --- | --- | --- |
| get-temp-data.xml | Получение данных API → вставка в SQL Server | По триггеру |
| make-txt-file.xml | Генерация текстовых данных | Каждые 4 часа |
| export_jp_latest_sync_html.xml | Генерация многоязычных HTML → загрузка в GitHub | Каждые 4 часа |
| Historicaldata_daily.xml | Генерация ежедневных данных | Ежедневно в 14:00 JST |

📜 Генерация исторических данных
| XML‑файл | Назначение | Расписание |
| --- | --- | --- |
| calc_weekly_avg.xml | Расчёт недельных средних → генерация HTML → загрузка в GitHub | Еженедельно |

🖥️ Управление сервером
| XML‑файл | Назначение | Расписание |
| --- | --- | --- |
| DBbackup.xml | Резервное копирование SQL Server | По расписанию |
| DBbackupSync.xml | Загрузка резервной копии в GitHub | После резервного копирования |
| reboot.xml | Перезагрузка системы | По расписанию |

🔧 Прочие задачи
| XML‑файл | Назначение | Расписание |
| --- | --- | --- |
| historical_index_for_claude.xml | Генерация исторического индекса для Claude | По расписанию |
| OneDriveToGithub.xml | Получение данных в 14:00 → загрузка в 15:00 | Ежедневно |
| auto_check_weather_update_daily.xml | Проверка обновления HTML → повторный запуск при необходимости | Каждые 4 часа |

🔎 SEO‑ключевые слова
Индекс дискомфорта (DI)

WBGT

Глобальная погода

Погода Японии

Влажность / температура

OpenWeatherMap API

Визуализация погоды

Автоматизация GitHub Pages

Автоматизация PowerShell

SQL Server база данных погоды

📁 SQL‑скрипты (Data-Extraction-SQL)

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

☀️ WBGT — расчёт в SQL

WBGT вычисляется только по температуре и влажности, без внешних API.

Формула:
WBGT = 0.7T + 0.3(T × H / 100)
Точность: ±1–2°C — достаточно для оценки теплового риска.

😓 Индекс дискомфорта (DI)
discomfort_index_en.sql

discomfort_index_jp.sql

Вычисляет DI и выводит классификацию комфортности
для английской и японской версий.

🌤 Ежедневные данные
daily_data_en.sql

daily_data_jp.sql

🏙 Список городов
city_list_en.sql

city_list_jp.sql

🌦 Погодные коды
weathercode_en.sql

weathercode_jp.sql

weathercode_list_en.sql

weathercode_list_jp.sql
