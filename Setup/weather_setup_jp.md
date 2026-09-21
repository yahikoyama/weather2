\# 🧱 weather2 構築方法



\## 📘 概要



\### ディレクトリ構成（ローカル）



```

c:\\weather

├─config                 # Configuration files (DB, API, GitHub) and dictionaries

├─Data                   # cities.csv (not used if you restore the DB backup file)

├─Data-Extraction-SQL    # Data-Extraction-tool

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



主に `c:\\winserverroot\\OneDrive` のファイルを GitHub にアップロードする仕組み。  

このパスは `c:\\weather\\Script\\ps1` および `.bat` 内で指定しているため変更可能。



\---



\## 🛠 事前準備



\### 🔑 OpenWeather API Key を取得  

https://openweathermap.org/api  

`c:\\weather\\config\\dbconfig.json` で使用します。



\### 🔑 GitHub Token を取得  

`c:\\weather\\config\\sync.json` で使用します。



\### 📥 GitHub からファイルをダウンロード  

以下のパスに合わせて配置してください。



```

c:\\weather\\

c:\\winserverroot\\OneDrive

```



\---



\## 🚀 インストール手順



\### 1. SQL Server 2022 Express のインストール



ダウンロード：  

https://www.microsoft.com/ja-jp/download/details.aspx?id=104781



SETUP.EXE

⇒管理者として実行

⇒SQLServerの新規スタンドアロンインストールを実行・・・

⇒ライセンス条項と次に同意します⇒次へ

⇒Micorosoft Udateを使用して更新プログラムを確認する　チェックしない

⇒次へ⇒次へ



SQL Server用Azure拡張機能のチェックを外す⇒次へ

インスタンス機能はそのまま⇒次へ

⇒既定のインスタンスを選択⇒次へ

サービスアカウント　そのまま⇒次へ



混合モードを選択 パスワード test@123 ⇒次へ

パスワードはメモしておくこと



c:\\weather\\config\\dbconfig.json



で必要になります



2)SQLServer Management Studio(SSMS)のインストール



https://learn.microsoft.com/ja-jp/ssms/install/install



vs\_SSMS.exe

⇒管理者として実行

⇒続行

⇒ワークロード画面はなにも選択せず　インストール



起動させたら

後でアカウントをスキップして追加します



サーバー名 (local)

認証　SQL Server認証

ユーザー名 sa

パスワード test@123

パスワードを記憶するをチェックする

データベース　<既定>

暗号化　オプション



オブジェクトエクスプローラーが表示されればOK



3)データベース復号化

オブジェクトエクスプローラー

⇒データベース　を選択し、右クリック

⇒データベースの復元

デバイスを選択　... をクリック



⇒C:\\Weather\\DBBackup\\weather\_202609.bak　を選択しOK

⇒OK をクリック

⇒OK をクリック



データベース'weather'の復元に成功しました。　と表示されればOK



4)C:\\weather\\config\\dbconfig.json 変更

メモ帳で修正する

変更するのは

Server,Password,OpenWeatherApiKey



{

&#x20;   "Server": "(local)",

&#x20;   "Database": "weather",

&#x20;   "User": "sa",

&#x20;   "Password": "test@123",

&#x20;   "OpenWeatherApiKey": "????????"

}



説明



5)データ取得確認(手動）



コマンドプロンプト



cd c:\\weather\\script

WeatherLogger.bat



戻り値　1　が連続で表示されればデータがデータベースに登録されている



c:\\weather\\logs\\ も確認してください



weatherデータベースに対しSQL文



SELECT \*

&#x20; FROM \[weather].\[dbo].\[WeatherLog]

&#x20; order by 1 desc



で直近に取得したデータが入っていればOKです

IP-ADDRESS あるいは (local) にしてください

OpenWeatherApiKey は自分で取得したキーを張り付けてください。

Databaseは復元したときのデータベース名です

Userはsa です。



6)Windowsタスクに追加する（データ取得自動のため）

タスクスケジューラ

新しいタスクの作成

名前 get-temp-data



「全般」

●ユーザーがログオンしているかどうかにかかわらず実行する

●最上位の特権で実行する



「トリガー」

毎日 0:00 4:00 8:00 12:00 14:00 16:00 20:00



「操作」

プログラム

C:\\weather\\Script\\WeatherLogger.bat



開始オプション

C:\\weather\\Script



「設定」

タスクを停止するまでの時間　のチェックを外す



登録されたら、右の「すべてのタスク履歴を有効にする」をクリックする



履歴(無効)が履歴　に変わる



7)登録されたデータを確認するためにPythonをインストールする



python-3.14.6-amd64.exe

⇒管理者として実行

●Use admin privileges when installing py.exe

●Add python.exe to PATH



Install Nowをクリック



8)Python ODBCドライバインストール

PowerShell プロンプト



pip install pyodbc



次のように表示されればOK

Downloading pyodbc-5.3.0-cp314-cp314-win\_amd64.whl.metadata (2.8 kB)

Downloading pyodbc-5.3.0-cp314-cp314-win\_amd64.whl (72 kB)

Installing collected packages: pyodbc

Successfully installed pyodbc-5.3.0



9)取得したデータを参照する

コマンドプロンプト



c:\\weather\\Script>weather\_viewer.py



10)DBbackupを自動実行



6)を参考にDBbackupタスクを作成する



あるいは　c:\\weather\\TaskScheduler\\DBbackup.xml　

をタスクスケジューラーでインポートする



11)テキストファイルに出力

c:\\weather\\Script>export\_jp.py



とすれば、



c:\\weather\\output\\jp\_result.txt



c:\\weather\\output フォルダに jp\_result.txt ファイルが出力されます



