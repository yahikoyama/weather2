📝 都市追加方法（更新）
 
(1)ツールを使った都市の自動追加

[add_city_gui.py](https://github.com/yahikoyama/weather2/tree/main/tool/add_city_gui.py)

cd c:\weather\tool

add_city_gui.py

画面が表示されたら、

4037Macau.txt

のように登録データを用意し、テキストボックスにデータ張り付ける

CityCodeはMAX+1が自動設定される　手動でも変更できる

最後に RegisterCity　ボタンをクリックする

テーブル、辞書ファイルが自動で更新される。

変更前の辞書ファイルは 

country_fullname.json.20261117_193720.bak

のようにファイル名_日付_時間.bakで保存される

(2)ツールを使わなない手動追加 

0.CityMasterテーブルのバックアップ

SELECT *

INTO CityMaster_BK_20261022

FROM CityMaster; 


1.CityMasterテーブルに都市を追加する

【Insert】add-city.sql

【Insert】add-city2.sql

2. Daily HTML に都市を追加する
   
📌 修正するスクリプト

C:\weather\Script\convert_to_html.ps1

3.辞書ファイルに追加する

📌 追加する辞書ファイル

以下の辞書に都市名を追加する：

C:\weather\config\dictionary_daily.json

C:\weather\config\dictionary_ptbr.json

C:\weather\config\dictionary_ar.json

C:\weather\config\dictionary_vi.json

C:\weather\config\dictionary_ko.json

C:\weather\config\dictionary_zh.json

C:\weather\config\dictionary_ru.json


4. weather_viewer.py に都市を追加する
   
📌 使用する辞書ファイル

C:\weather\config\country_fullname.json

国コード（例：JP, US, KR など）を追加する場合はここに追記する。

5. Weekly 英語版 HTML に都市を追加する

📌 使用する辞書ファイル

C:\weather\config\dictionary.json

英語版の都市名はこの辞書に追加する。
