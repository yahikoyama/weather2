📝 都市追加方法（まとめ）

1. Daily HTML に都市を追加する
   
【Insert】add-city.sql

【Insert】add-city2.sql
   
📌 修正するスクリプト

C:\weather\Script\convert_to_html.ps1

📌 追加する辞書ファイル

以下の辞書に都市名を追加する：

C:\weather\config\dictionary_daily.json

C:\weather\config\dictionary_ptbr.json

C:\weather\config\dictionary_ar.json

C:\weather\config\dictionary_vi.json

C:\weather\config\dictionary_ko.json

C:\weather\config\dictionary_zh.json

C:\weather\config\dictionary_ru.json


2. weather_viewer.py に都市を追加する
   
📌 使用する辞書ファイル

C:\weather\config\country_fullname.json

国コード（例：JP, US, KR など）を追加する場合はここに追記する。

3. Weekly 英語版 HTML に都市を追加する

📌 使用する辞書ファイル

C:\weather\config\dictionary.json

英語版の都市名はこの辞書に追加する。
