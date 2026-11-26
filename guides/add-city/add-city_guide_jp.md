📝 都市追加方法（更新）
 
(1)ツールを使った都市の自動追加

tool/add_city_gui_2.py をc:\weather\tool\  にコピー

https://github.com/yahikoyama/weather2/blob/main/tool/add_city_gui_2.py

コマンドプロンプト

cd c:\weather\tool

add_city_gui_2.py

画面が表示されたら、

4037Macau.txt

のように登録データを用意し(AIに聞く)、テキストボックスにデータ張り付ける

CityCodeはMAX+1が自動設定される　手動でも変更できる

最後に RegisterCity　ボタンをクリックする

テーブル、辞書ファイルが自動で更新される。

登録が終わると入力ボックスがクリアされ、CityCodeが+1される。

変更前の辞書ファイルは 

country_fullname.json.20261117_193720.bak

のようにファイル名_日付_時間.bakで保存される

テーブルから都市を削除したい場合は手動でSQLで削除してください

delete from CityMaster 
where CityCode='4037'

バックアップテーブルを削除したい場合は手動でSQLで削除してください（例）

drop table CityMaster_BK_20261124_220204

(2)ツールを使わなない都市の手動追加 

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
