# Weather Report (GitHub Pages)
https://yahikoyama.github.io/weather2/

이 프로젝트는 전 세계의 기상 데이터를 활용하여  
**데이터베이스 시스템(SQL)과 프로그래밍을 학습하기 위한 시스템**입니다.

OpenWeatherMap API를 통해 기온, 습도, 날씨 정보를 수집하고  
자동으로 **불쾌지수(Discomfort Index: DI)**를 계산합니다.  
이를 통해 세계에서 가장 시원한 지역을 찾고,  
지구 온난화 완화에 도움이 되는 정보를 제공합니다.

새로운 도시를 추가하고 싶다면 **CityMaster 테이블**에 레코드를 삽입하십시오.

---

## ■ 시스템 개요

이 시스템은 Client/Server 구조로 구성되어 있으며 다음 환경을 사용합니다:

- Windows 11 Pro (작업 스케줄러)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (최대 10GB)
- Python 3.14 (pyodbc ODBC 드라이버 사용)

**weather.zip**에는 다음이 포함되어 있습니다:
- 전체 소스 코드  
- 데이터베이스 백업  

환경에 맞게 **conf 파일을 설정**하고  
작업 스케줄러의 **XML 파일을 가져오기(import)** 하십시오.

---

## ■ 매일 업데이트되는 보고서 (4시간마다 자동 갱신)
https://yahikoyama.github.io/weather2/weather_report_now.html

---

## ■ 과거 보고서 목록 (Historical)
https://yahikoyama.github.io/weather2/Historical/

---

## ■ 연락처
yahikoyama.777@gmail.com
