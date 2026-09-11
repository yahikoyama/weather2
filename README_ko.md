# 🌍 글로벌 불쾌지수 (4시간마다 업데이트)

## 👉 **다국어 글로벌 날씨 보고서 — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_en.html">
<img width="1280" alt="Daily Weather Report Screenshot" src="https://github.com/user-attachments/assets/c794a36d-a4bf-4905-9ff1-9d7591c2480a" />
</a>

---

# 🌦️ 매일 자동 업데이트되는 날씨 보고서

| 언어 | URL | 업데이트 주기 |
|------|-----|----------------|
| 🇯🇵 일본어 | https://yahikoyama.github.io/weather2/weather_report_now.html | 4시간마다 |
| 🇬🇧 영어 | https://yahikoyama.github.io/weather2/weather_report_now_en.html | 4시간마다 (JST) |
| 🇷🇺 러시아어 | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | 4시간마다 (JST) |
| 🇨🇳 중국어(간체) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | 4시간마다 (JST) |
| 🇰🇷 한국어 | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | 4시간마다 (JST) |
| 🇻🇳 베트남어 | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | 4시간마다 (JST) |
| 🇦🇪 아랍어 | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | 4시간마다 (JST) |
| 🇧🇷 브라질 포르투갈어 | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | 4시간마다 (JST) |

---

# 📜 과거 날씨 보고서 (아카이브)

매일의 날씨 데이터 및 불쾌지수(DI) 기록:

- 🇬🇧 영어  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 일본어  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 일일 인덱스  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html

---

이 프로젝트는 전 세계 도시의 불쾌지수를 4시간마다 시각화합니다.  
어떤 도시가 덥고, 춥고, 습하거나, 쾌적한지 확인할 수 있습니다.

---

# 📌 개요

이 프로젝트는 **OpenWeatherMap API**의 실시간 데이터를 사용하여  
**기온, 습도, 날씨 상태**를 기반으로 **불쾌지수(DI)**를 계산합니다.

- ⏱ **4시간마다 자동 업데이트**  
- 🌐 **8개 언어 지원**  
- 📊 **과거 데이터 아카이브 제공**  
- ⚙️ **PowerShell + SQL Server + Python + GitHub Pages 완전 자동화**

사용 목적:
- 날씨 모니터링  
- 열 스트레스 평가  
- 환경 관측  
- 자동화 학습 (PowerShell / SQL / Python)

---

# 📘 프로젝트 설명

이 프로젝트는 전 세계의 날씨 데이터를 자동으로 수집하고  
**불쾌지수(DI)**를 계산하여 다국어 HTML 보고서를 **GitHub Pages**에 게시합니다.

학습용으로도 적합합니다:
- SQL 데이터베이스  
- PowerShell 자동화  
- Python 데이터 처리  
- 다국어 HTML 생성  
- GitHub Pages 배포

도시를 추가하려면 **CityMaster** 테이블에 레코드를 삽입하세요.

---

# 🏗️ 시스템 아키텍처

### 사용 기술
- Windows 11 Pro (작업 스케줄러 자동화)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (최대 10GB)
- Python 3.14 + pyodbc (ODBC 드라이버)

---

## 📦 GitHub 저장소 구성

이전에는 **weather.zip**에 포함되어 있던 모든 파일이  
현재는 GitHub 저장소 내 폴더로 제공됩니다.

포함된 내용:

- 전체 소스 코드  
- SQL Server 데이터베이스 스크립트 및 백업  
- 설정 템플릿 (config.ps1, sql1.ps1 등)  
- 자동화 스크립트 (BAT / PowerShell)  
- 자동 실행용 Task Scheduler XML

환경에 맞게 설정 파일을 구성하고  
필요하다면 Task Scheduler XML을 가져오세요.

📩 문의: **yahikoyama.777@gmail.com**

---

# 🌐 지원 언어

[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

---

# 🚀 빠른 시작

### 1. 저장소 클론
````
weather2/
├── Historical/                # 일본어 아카이브
├── Historical_en/             # 영어 아카이브
├── SRC_DB_SETTING/            # DB 백업 및 설정 파일
├── DBBackup/                  # SQL Server 일일 백업
├── weather_report_now.html    # 일본어 보고서
├── weather_report_now_en.html # 영어 보고서
├── weather_report_now_ko.html # 한국어 보고서
├── weather_report_now_ru.html # 러시아어 보고서
├── weather_report_now_zh.html # 중국어 보고서
├── weather_report_now_vi.html # 베트남어 보고서
├── weather_report_now_ar.html # 아랍어 보고서
├── weather_report_now_ptbr.html # 브라질 포르투갈어 보고서
````

🌐 다국어 날씨 보고서 생성 작업
| XML 파일 | 기능 | 스케줄 |
| --- | --- | --- |
| get-temp-data.xml | API 날씨 데이터 가져오기 → SQL Server 저장 | 트리거 기반 |
| make-txt-file.xml | 텍스트 데이터 생성 | 4시간마다 |
| export_jp_latest_sync_html.xml | 다국어 HTML 생성 → GitHub 업로드 | 4시간마다 |
| Historicaldata_daily.xml | 일일 데이터 생성 | 매일 14:00 JST |

📜 과거 데이터 생성 작업
| XML 파일 | 기능 | 스케줄 |
| --- | --- | --- |
| calc_weekly_avg.xml | 주간 평균 계산 → HTML 생성 → GitHub 업로드 | 매주 |

🖥️ 서버 관리 작업
| XML 파일 | 기능 | 스케줄 |
| --- | --- | --- |
| DBbackup.xml | SQL Server 백업 | 정기 |
| DBbackupSync.xml | 백업 파일 GitHub 업로드 | 백업 후 |
| reboot.xml | 시스템 재부팅 | 정기 |

🔧 기타 작업
| XML 파일 | 기능 | 스케줄 |
| --- | --- | --- |
| historical_index_for_claude.xml | Claude용 역사 인덱스 생성 | 정기 |
| OneDriveToGithub.xml | 14:00 데이터 수집 → 15:00 GitHub 업로드 | 매일 |
| auto_check_weather_update_daily.xml | HTML 업데이트 확인 → 필요 시 재실행 | 4시간마다 |

🔎 SEO 키워드
불쾌지수 (DI)

WBGT

글로벌 날씨

일본 날씨

습도 / 기온

OpenWeatherMap API

날씨 시각화

GitHub Pages 자동화

PowerShell 자동화

SQL Server 날씨 데이터베이스

📁 SQL 스크립트 (Data-Extraction-SQL)
````
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
````

☀️ WBGT — SQL로 직접 계산
WBGT는 기온과 습도만으로 계산할 수 있으며 외부 API가 필요 없습니다.

공식 간이식:

WBGT = 0.7T + 0.3(T × H / 100)
정확도는 ±1–2°C로, 열 스트레스 평가에 충분합니다.

😓 불쾌지수 (DI)
discomfort_index_en.sql

discomfort_index_jp.sql

기온과 습도를 기반으로 DI를 계산하고
영어/일본어 기준의 쾌적도 등급을 출력합니다.

🌤 일일 데이터
daily_data_en.sql

daily_data_jp.sql

🏙 도시 목록
city_list_en.sql

city_list_jp.sql

🌦 날씨 코드
weathercode_en.sql

weathercode_jp.sql

weathercode_list_en.sql

weathercode_list_jp.sql



```bash
git clone https://github.com/yahikoyama/weather2
