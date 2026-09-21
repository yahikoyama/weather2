# 🧱 weather2 설치 가이드

## 📘 개요

### 디렉터리 구조 (로컬)

```
c:\weather
├─config                 # 구성 파일(DB, API, GitHub) 및 사전
├─Data                   # cities.csv (DB 백업을 복원하면 사용하지 않음)
├─Data-Extraction-SQL    # 데이터 추출 도구
├─DBBackup               # SQL Server 백업 파일
├─Logs                   # 사용하지 않음
├─output                 # index.html, jp_result.txt (JST 14:00에 생성)
├─Script                 # PowerShell 스크립트, 배치 파일, Python 스크립트
├─Setup                  # 설치 지침 및 환경 준비
└─TaskScheduler          # Windows 작업 스케줄러 XML 정의
```

```
c:\winserverroot\OneDrive
├─Historical        # 일본(JP) 과거 데이터
├─Historical_en     # 영어(EN) 과거 데이터
```

`c:\winserverroot\OneDrive` 아래의 파일은 GitHub에 업로드됩니다.  
이 경로는 `c:\weather\Script\ps1` 및 `.bat` 파일에서 변경할 수 있습니다.

---

## 🛠 사전 준비

### 🔑 OpenWeather API Key 발급  
https://openweathermap.org/api  
`c:\weather\config\dbconfig.json` 에서 사용됩니다.

### 🔑 GitHub Token 발급  
`c:\weather\config\sync.json` 에서 사용됩니다.

### 📥 GitHub에서 파일 다운로드  
다음 경로에 맞게 파일을 배치하세요:

```
c:\weather\

c:\winserverroot\OneDrive
```

---

## 🚀 설치 단계

### 1) SQL Server 2022 Express 설치

다운로드:  
https://www.microsoft.com/ja-jp/download/details.aspx?id=104781

SETUP.EXE  
- 관리자 권한으로 실행  
- 새로운 SQL Server 독립 실행형 설치  
- 라이선스 동의 → 다음  
- “Microsoft Update 사용” 체크하지 않음  
- 다음 → 다음  
- “SQL Server Azure 확장 기능” 체크 해제 → 다음  
- 인스턴스 기능 기본값 유지 → 다음  
- “기본 인스턴스(Default instance)” 선택 → 다음  
- 서비스 계정 설정 기본값 유지 → 다음  
- 혼합 모드(Mixed Mode) 선택  
  비밀번호: `test@123`  
  (반드시 기록해 두세요)

이 비밀번호는 다음 파일에서 필요합니다:

```
c:\weather\config\dbconfig.json
```

---

### 2) SQL Server Management Studio (SSMS) 설치

https://learn.microsoft.com/ja-jp/ssms/install/install

vs_SSMS.exe  
- 관리자 권한으로 실행  
- 계속  
- 워크로드 선택 없이 설치

SSMS 실행 후:  
계정 추가는 건너뜁니다.

연결 설정:  
- 서버 이름: `(local)`  
- 인증 방식: SQL Server 인증  
- 사용자 이름: `sa`  
- 비밀번호: `test@123`  
- “비밀번호 저장” 체크  
- 데이터베이스: <기본값>  
- 암호화: 선택 사항

Object Explorer가 표시되면 정상입니다.

---

### 3) 데이터베이스 복원

Object Explorer →  
**Databases** 오른쪽 클릭 → **Restore Database**

- “Device” 선택 → “…” 클릭  
- 다음 파일 선택:  
  `C:\Weather\DBBackup\weather\2026mmdd.bak`  
- OK → OK

**“Database 'weather' restored successfully”** 메시지가 나오면 완료입니다.

---

### 4) `c:\weather\config\dbconfig.json` 수정

메모장으로 파일을 엽니다.

다음 항목을 수정합니다:  
- Server  
- Password  
- OpenWeatherApiKey

```json
{
    "Server": "(local)",
    "Database": "weather",
    "User": "sa",
    "Password": "test@123",
    "OpenWeatherApiKey": "????????"
}
```

참고:  
- `(local)` 또는 서버 IP 주소 사용  
- OpenWeather API Key 입력  
- 데이터베이스 이름은 복원된 DB 이름과 동일해야 함  
- 사용자 이름은 `sa`

---

### 5) 데이터 수집 수동 테스트

명령 프롬프트:

```
cd c:\weather\script
WeatherLogger.bat
```

반환값 **1**이 반복되면 데이터가 정상적으로 DB에 저장되고 있는 것입니다.

다음 경로도 확인하세요:

```
c:\weather\logs\
```

SQL 확인:

```sql
SELECT *
  FROM [weather].[dbo].[WeatherLog]
  ORDER BY 1 DESC;
```

최근 데이터가 보이면 정상입니다.

---

### 6) Windows 작업 스케줄러 등록 (자동 데이터 수집)

작업 스케줄러 → 새 작업 만들기  
이름: **get-temp-data**

**일반(General)**  
- 사용자가 로그인했는지 여부와 관계없이 실행  
- 최고 권한으로 실행

**트리거(Triggers)**  
매일:

```
0:00 4:00 8:00 12:00 14:00 16:00 20:00
```

**작업(Actions)**  
프로그램:

```
C:\weather\Script\WeatherLogger.bat
```

시작 위치:

```
C:\weather\Script
```

**설정(Settings)**  
“작업이 너무 오래 실행되면 중지” 체크 해제

등록 후 “모든 작업 기록 사용” 클릭  
“기록(사용 안 함)” → “기록”으로 변경됨

---

### 7) Python 설치 (데이터 조회용)

python‑3.14.6‑amd64.exe  
- 관리자 권한으로 실행  
- “Use admin privileges when installing py.exe” 체크  
- “Add python.exe to PATH” 체크  
- **Install Now** 클릭

---

### 8) Python ODBC 드라이버(pyodbc) 설치

PowerShell:

```
pip install pyodbc
```

예상 출력:

```
Downloading pyodbc-5.3.0...
Installing collected packages: pyodbc
Successfully installed pyodbc-5.3.0
```

---

### 9) 수집된 데이터 조회

명령 프롬프트:

```
c:\weather\Script\weather\viewer.py
```

---

### 10) DB 자동 백업

6번 단계와 동일하게 DBbackup 작업 생성

또는 다음 파일을 가져오기(import):

```
c:\weather\TaskScheduler\DBbackup.xml
```

---

### 11) 텍스트 파일 출력

명령 프롬프트:

```
c:\weather\Script\export_jp.py
```

출력:

```
c:\weather\output\jp_result.txt
```

`jp_result.txt` 파일이 `output` 폴더에 생성됩니다.

