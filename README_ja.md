# 🌍 グローバル不快指数（4時間ごとに更新）

## 👉 **多言語対応のグローバル天気レポート — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_en.html">
<img width="1280" alt="Daily Weather Report Screenshot" src="https://github.com/user-attachments/assets/c794a36d-a4bf-4905-9ff1-9d7591c2480a" />
</a>

---

# 🌦️ 毎日の天気レポート（自動更新）

| 言語 | URL | 更新頻度 |
|------|-----|-----------|
| 🇯🇵 日本語 | https://yahikoyama.github.io/weather2/weather_report_now.html | 4時間ごと |
| 🇬🇧 英語 | https://yahikoyama.github.io/weather2/weather_report_now_en.html | 4時間ごと（JST） |
| 🇷🇺 ロシア語 | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | 4時間ごと（JST） |
| 🇨🇳 中国語（簡体字） | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | 4時間ごと（JST） |
| 🇰🇷 韓国語 | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | 4時間ごと（JST） |
| 🇻🇳 ベトナム語 | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | 4時間ごと（JST） |
| 🇦🇪 アラビア語 | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | 4時間ごと（JST） |
| 🇧🇷 ブラジルポルトガル語 | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | 4時間ごと（JST） |

---

# 📜 過去の天気レポート（アーカイブ）

毎日の天気データと不快指数（DI）のアーカイブ：

- 🇬🇧 英語版  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 日本語版  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 日次インデックス  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html

---

このプロジェクトは、世界中の不快指数を4時間ごとに可視化します。  
どの都市が暑い・寒い・蒸し暑い・快適かを確認できます。

---

# 📌 概要

このプロジェクトは **OpenWeatherMap API** のリアルタイムデータを使用し、  
**気温・湿度・天候**から **不快指数（DI）** を計算して自動更新レポートを生成します。

- ⏱ **4時間ごとに自動更新**  
- 🌐 **多言語対応（8言語）**  
- 📊 **過去データのアーカイブあり**  
- ⚙️ **PowerShell + SQL Server + Python + GitHub Pages による完全自動化**

用途：
- 天候監視  
- 熱中症対策  
- 環境観測  
- 自動化学習（PowerShell / SQL / Python）

---

# 📘 プロジェクト概要

このプロジェクトは、世界の気象データ（気温・湿度・天候）を自動収集し、  
**不快指数（DI）** を計算して多言語HTMLレポートを GitHub Pages に公開します。

学習用途としても最適：
- SQL データベース  
- PowerShell 自動化  
- Python データ処理  
- 多言語 HTML 生成  
- GitHub Pages 公開

都市を追加したい場合は **CityMaster テーブル** にレコードを追加してください。

---

# 🏗️ システム構成

### 使用技術
- Windows 11 Pro（タスクスケジューラ自動化）
- PowerShell 5.1
- Microsoft SQL Server Express 2022（最大10GB）
- Python 3.14 + pyodbc（ODBCドライバ）

---

## 📦 GitHub リポジトリに含まれるファイル

以前 **weather.zip** に含まれていたすべてのファイルは、  
現在は GitHub リポジトリ内にフォルダ単位で公開されています。

含まれる内容：

- フルソースコード  
- SQL Server データベーススクリプト & バックアップ  
- 設定テンプレート（config.ps1, sql1.ps1 など）  
- 自動化スクリプト（BAT / PowerShell）  
- タスクスケジューラ XML（自動実行用）

環境に合わせて設定ファイルを編集し、  
必要に応じてタスクスケジューラ XML をインポートしてください。

📩 連絡先: **yahikoyama.777@gmail.com**

---

# 🌐 利用可能な言語

[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

---

# 🚀 クイックスタート

### 1. リポジトリをクローン
```
weather2/
├── Historical/                # 日本語アーカイブ
├── Historical_en/             # 英語アーカイブ
├── SRC_DB_SETTING/            # DBバックアップ・設定ファイル
├── DBBackup/                  # SQL Server 日次バックアップ
├── weather_report_now.html    # 日本語レポート
├── weather_report_now_en.html # 英語レポート
├── weather_report_now_ko.html # 韓国語レポート
├── weather_report_now_ru.html # ロシア語レポート
├── weather_report_now_zh.html # 中国語レポート
├── weather_report_now_vi.html # ベトナム語レポート
├── weather_report_now_ar.html # アラビア語レポート
├── weather_report_now_ptbr.html # ブラジルポルトガル語レポート
```

🌐 多言語天気レポート生成タスク
| XMLファイル | 目的 | スケジュール |
| --- | --- | --- |
| get-temp-data.xml | APIから天気データ取得 → SQL Serverへ挿入 | トリガー |
| make-txt-file.xml | テキストデータ生成 | 4時間ごと |
| export_jp_latest_sync_html.xml | 多言語HTML生成 → GitHubへアップロード | 4時間ごと |
| Historicaldata_daily.xml | 日次データ生成 | 毎日14:00 JST |


📜 過去データ生成タスク
| XMLファイル | 目的 | スケジュール |
| --- | --- | --- |
| calc_weekly_avg.xml | 週次平均計算 → 週次HTML生成 → GitHubへアップロード | 毎週 |

🖥️ サーバ管理タスク
| XMLファイル | 目的 | スケジュール |
| --- | --- | --- |
| DBbackup.xml | SQL Server バックアップ | 定期 |
| DBbackupSync.xml | バックアップを GitHub にアップロード | バックアップ後 |
| reboot.xml | システム再起動 | 定期 |

🔧 その他タスク
| XMLファイル | 目的 | スケジュール |
| --- | --- | --- |
| historical_index_for_claude.xml | Claude 用インデックス生成 | 定期 |
| OneDriveToGithub.xml | 14:00にデータ取得 → 15:00にGitHubへアップロード | 毎日 |
| auto_check_weather_update_daily.xml | HTML更新チェック → 必要なら再実行 | 4時間ごと |

git clone https://github.com/yahikoyama/weather2

🔎 SEO キーワード
不快指数（DI）

WBGT

グローバル天気

日本の天気

湿度 / 気温

OpenWeatherMap API

天気可視化

GitHub Pages 自動化

PowerShell 自動化

SQL Server 天気データベース

📁 SQL 一覧（Data-Extraction-SQL）
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

☀️ WBGT（暑さ指数）— SQLで直接計算
WBGT は温度と湿度のみで計算でき、外部API不要です。

公式の簡易式：
WBGT = 0.7T + 0.3(T × H / 100)
精度は ±1–2°C 程度で、実用的な熱リスク評価が可能。

😓 不快指数（DI）
discomfort_index_en.sql

discomfort_index_jp.sql

温度・湿度から不快指数を計算し、
英語版・日本語版の快適度分類を出力します。

🌤 日次データ抽出
daily_data_en.sql

daily_data_jp.sql

🏙 都市リスト
city_list_en.sql

city_list_jp.sql

🌦 天気コード
weathercode_en.sql

weathercode_jp.sql

weathercode_list_en.sql

weathercode_list_jp.sql
