\# 🧱 weather2 Setup Guide



\## 📘 Overview



\### Directory Structure (Local)



```

c:\\weather

├─config                 # Configuration files (DB, API, GitHub) and dictionaries
├─Data                   # cities.csv (not used if you restore the DB backup file)
├─Data-Extraction-SQL    # Data extraction tool
├─DBBackup               # SQL Server backup file
├─Logs                   # Not used
├─output                 # index.html, jp\_result.txt (generated at JST 14:00)
├─Script                 # PowerShell scripts, batch files (calling PS1), and Python scripts
├─Setup                  # Setup instructions and environment preparation
└─TaskScheduler          # Task Scheduler XML definitions

```

```

c:\\winserverroot\\OneDrive

├─Historical        # Historical data JP
├─Historical\_en     # Historical data EN

```

Files under `c:\\winserverroot\\OneDrive` are uploaded to GitHub.  

This path can be changed inside `c:\\weather\\Script\\ps1` and `.bat` files.

\---



\## 🛠 Preparation



\### 🔑 Obtain an OpenWeather API Key  

https://openweathermap.org/api  

Used in `c:\\weather\\config\\dbconfig.json`.



\### 🔑 Obtain a GitHub Token  

Used in `c:\\weather\\config\\sync.json`.



\### 📥 Download files from GitHub  

Place them according to the following paths:



```

c:\\weather\\



c:\\winserverroot\\OneDrive

```



\---



\## 🚀 Installation Steps



\### 1) Install SQL Server 2022 Express



Download:  

https://www.microsoft.com/ja-jp/download/details.aspx?id=104781



SETUP.EXE  

\- Run as Administrator  

\- Perform a new SQL Server stand‑alone installation  

\- Accept license terms → Next  

\- Do NOT check “Use Microsoft Update to check for updates”  

\- Next → Next  

\- Uncheck “SQL Server Azure extension” → Next  

\- Instance features → leave default → Next  

\- Select “Default instance” → Next  

\- Service accounts → leave as is → Next  

\- Select Mixed Mode  

&#x20; Password: `test@123`  

&#x20; (Make sure to write it down)



This password is required in:



```

c:\\weather\\config\\dbconfig.json

```



\---



\### 2) Install SQL Server Management Studio (SSMS)



https://learn.microsoft.com/ja-jp/ssms/install/install



vs\_SSMS.exe  

\- Run as Administrator  

\- Continue  

\- Do not select any workloads → Install



After launching SSMS:  

Skip adding an account for now.



Connection settings:  

\- Server name: `(local)`  

\- Authentication: SQL Server Authentication  

\- Username: `sa`  

\- Password: `test@123`  

\- Check “Remember password”  

\- Database: <Default>  

\- Encryption: Optional



If Object Explorer appears, setup is OK.



\---



\### 3) Restore the Database



Object Explorer →  

Right‑click \*\*Databases\*\* → \*\*Restore Database\*\*



\- Select “Device” → click “…”  

\- Choose:  

&#x20; `C:\\Weather\\DBBackup\\weather\_2026mmdd.bak`  

\- Click OK → OK



If the message \*\*“Database 'weather' restored successfully”\*\* appears, it is complete.



\---



\### 4) Edit `c:\\weather\\config\\dbconfig.json`



Open with Notepad.



Modify the following fields:  

\- Server  

\- Password  

\- OpenWeatherApiKey



```json

{

"Server": "(local)",

"Database": "weather",

"User": "sa",

"Password": "test@123",

"OpenWeatherApiKey": "????????"

}

```



Notes:  

\- Use `(local)` or your server IP address  

\- Paste your own OpenWeather API key  

\- Database name must match the restored DB  

\- User is `sa`



\---



\### 5) Manual Data Retrieval Test



Command Prompt:



```

cd c:\\weather\\script

WeatherLogger.bat

```



If return value \*\*1\*\* continues to appear, data is being inserted into the database.



Also check:



```

c:\\weather\\logs\\

```



SQL check:



```sql

SELECT \*

&#x20; FROM \[weather].\[dbo].\[WeatherLog]

&#x20; ORDER BY 1 DESC;

```



If recent data appears, it is working correctly.



\---



\### 6) Add Windows Task (Automatic Data Retrieval)



Task Scheduler → Create New Task  

Name: \*\*get-temp-data\*\*



\*\*General\*\*  

\- Run whether user is logged on or not  

\- Run with highest privileges



\*\*Triggers\*\*  

Daily at:  

```

0:00 4:00 8:00 12:00 14:00 16:00 20:00

```



\*\*Actions\*\*  

Program:  

```

C:\\weather\\Script\\WeatherLogger.bat

```



Start in:  

```

C:\\weather\\Script

```



\*\*Settings\*\*  

Uncheck “Stop the task if it runs longer than…”



After registering, click “Enable All Tasks History”.  

“History (disabled)” will change to “History”.



\---



\### 7) Install Python (for viewing retrieved data)



python‑3.14.6‑amd64.exe  

\- Run as Administrator  

\- Check: “Use admin privileges when installing py.exe”  

\- Check: “Add python.exe to PATH”  

\- Click \*\*Install Now\*\*



\---



\### 8) Install Python ODBC Driver (pyodbc)



PowerShell:



```

pip install pyodbc

```



Expected output:



```

Downloading pyodbc-5.3.0...

Installing collected packages: pyodbc

Successfully installed pyodbc-5.3.0

```



\---



\### 9) View Retrieved Data



Command Prompt:



```

c:\\weather\\Script>weather\_viewer.py

```



\---



\### 10) Automatic DB Backup



Create a DBbackup task similar to step 6.



Or import:



```

c:\\weather\\TaskScheduler\\DBbackup.xml

```



\---



\### 11) Export Text File



Command Prompt:



```

c:\\weather\\Script>export\_jp.py

```



Output:



```

c:\\weather\\output\\jp\_result.txt

```



The file `jp\_result.txt` will be generated in the `output` folder.





