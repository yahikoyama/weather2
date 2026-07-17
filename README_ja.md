# Weather Report（GitHub Pages）
https://yahikoyama.github.io/weather2/

このプロジェクトは、世界の気象データを利用して  
**データベース（SQL）とプログラミングを学習するためのシステム**です。

OpenWeatherMap API から取得した気温・湿度・天気データをもとに  
**不快指数（Discomfort Index：DI）を自動計算**し、  
世界のどこが涼しいのかを可視化することで、地球温暖化対策にも役立つ情報を提供します。

都市を追加したい場合は、**CityMaster テーブルにレコードを追加**してください。

---

## ■ システム概要

このシステムは Client/Server 方式で構築されています。

- Windows 11 Pro（タスクスケジューラ使用）
- PowerShell 5.1
- Microsoft SQL Server Express 2022（最大 10GB）
- Python 3.14（pyodbc ODBC ドライバ使用）

**weather.zip** には、  
- ソースコード一式  
- データベースバックアップ  
が含まれています。

環境に合わせて **conf ファイルを設定**し、  
タスクスケジューラの **XML ファイルをインポート**してください。

---

## ■ 毎日更新レポート（4時間ごと更新）
https://yahikoyama.github.io/weather2/weather_report_now.html

---

## ■ 過去レポート一覧（Historical）
https://yahikoyama.github.io/weather2/Historical/

---

## ■ お問い合わせ
yahikoyama.777@gmail.com
