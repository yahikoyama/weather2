@echo off
setlocal enabledelayedexpansion

REM ▼ JSON 設定ファイル
set CONFIG=C:\Weather\Config\dbconfig.json

REM ▼ PowerShell で JSON 読み込み
for /f "usebackq tokens=1,* delims=:" %%A in (`powershell -NoProfile -Command ^
    "(Get-Content '%CONFIG%' | ConvertFrom-Json) | ConvertTo-Json -Compress"`) do (
    set JSON=%%B
)

REM ▼ 個別項目を PowerShell で取得
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Content '%CONFIG%' | ConvertFrom-Json).Server"') do set SERVER=%%A
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Content '%CONFIG%' | ConvertFrom-Json).Database"') do set DATABASE=%%A
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Content '%CONFIG%' | ConvertFrom-Json).User"') do set USER=%%A
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Content '%CONFIG%' | ConvertFrom-Json).Password"') do set PASSWORD=%%A

echo Server: %SERVER%
echo Database: %DATABASE%
echo User: %USER%

REM ▼ バックアップファイル保存先
set BACKUP_DIR=C:\Weather\DBBackup
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

set BACKUP_FILE=%BACKUP_DIR%\%DATABASE%_%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%.bak

echo Backup file: %BACKUP_FILE%

REM ▼ SQL Server バックアップ実行
sqlcmd -S "%SERVER%" -U "%USER%" -P "%PASSWORD%" -Q "BACKUP DATABASE [%DATABASE%] TO DISK='%BACKUP_FILE%' WITH INIT"

if %ERRORLEVEL%==0 (
    echo Backup completed successfully.
) else (
    echo Backup failed.
)

REM ▼ ここから：7世代より古いバックアップを削除
echo.
echo === 古いバックアップを削除中（7世代保持） ===

pushd "%BACKUP_DIR%"

REM ▼ *.bak を日付順に並べて 7 個より多い分を削除
set COUNT=0
for /f "delims=" %%F in ('dir /b /a-d /o-d *.bak') do (
    set /a COUNT+=1
    if !COUNT! GTR 7 (
        echo 削除: %%F
        del "%%F"
    )
)

popd

echo 完了しました。
rem pause
