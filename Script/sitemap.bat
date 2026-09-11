@echo off

REM ★ 自分自身のバッチが動いていたら終了（誤検出なし）
wmic process where "CommandLine like '%%sitemap.bat%%' and not CommandLine like '%%wmic%%'" get ProcessId >nul 2>&1
if %errorlevel%==0 exit

REM まず weather2 に移動
cd C:\Users\winserverroot\weather2 2>nul

REM push を試す（拒否されたら再クローン）
git push origin main
if %errorlevel% neq 0 (
    echo push が拒否されたため再クローンします…

    REM フォルダを完全削除
    rmdir /s /q C:\Users\winserverroot\weather2

    REM 再クローン
    git clone https://github.com/yahikoyama/weather2.git C:\Users\winserverroot\weather2
)

REM 強制削除
del /f /q C:\Users\winserverroot\weather2\sitemap.xml

REM コピー
copy C:\Users\winserverroot\OneDrive\Historical\html\sitemap.xml C:\Users\winserverroot\weather2\sitemap.xml /Y

REM GitHub リポジトリへ移動
cd C:\Users\winserverroot\weather2

REM 変更をステージング
git add -A

REM 必ずコミットを作る
git commit --allow-empty -m "auto update sitemap.xml"

REM GitHub に push
git push origin main

REM 終了
exit
