# -*- coding: utf-8 -*-
import pyodbc
import json
import os
import shutil
from datetime import datetime

# ▼ JSON 読み込み（DB設定）
with open(r"C:\weather\Config\dbconfig.json", "r", encoding="utf-8") as f:
    config = json.load(f)

SERVER = config["Server"]
DATABASE = config["Database"]
USER = config["User"]
PASSWORD = config["Password"]

# ▼ SQL（JP）※ INNERINNER → INNER JOIN に修正済み
SQL_JP = """
WITH LatestLog AS (
    SELECT wl.*
    FROM WeatherLog wl
    INNER JOIN (
        SELECT CityCode, MAX(CreatedAt) AS MaxCreatedAt
        FROM WeatherLog
        GROUP BY CityCode
    ) x
        ON wl.CityCode = x.CityCode
       AND wl.CreatedAt = x.MaxCreatedAt
)
SELECT
    REPLACE(REPLACE(c.CityJp, '(', ''), ')', '') AS 地名,
    l.Temperature AS 温度,
    l.Humidity AS 湿度,
    w.WeatherNameJp AS 天気,
    FORMAT(l.CreatedAt, 'yyyy-MM-dd HH:mm:ss') AS 取得時間JST
FROM LatestLog l
INNER JOIN CityMaster c ON l.CityCode = c.CityCode
INNER JOIN WeatherCodeMaster w ON l.WeatherCode = w.WeatherCode
WHERE c.CountryCode = 'JP'
ORDER BY l.Temperature ASC;
"""

# ▼ SQL（NOTJP）
SQL_NOTJP = """
WITH LatestLog AS (
    SELECT wl.*
    FROM WeatherLog wl
    INNER JOIN (
        SELECT CityCode, MAX(CreatedAt) AS MaxCreatedAt
        FROM WeatherLog
        GROUP BY CityCode
    ) x
        ON wl.CityCode = x.CityCode
       AND wl.CreatedAt = x.MaxCreatedAt
)
SELECT
    REPLACE(REPLACE(c.CityJp, '(', ''), ')', '') AS 地名,
    l.Temperature AS 温度,
    l.Humidity AS 湿度,
    w.WeatherNameJp AS 天気,
    FORMAT(l.CreatedAt, 'yyyy-MM-dd HH:mm:ss') AS 取得時間JST,
    c.CountryCode AS 国
FROM LatestLog l
INNER JOIN CityMaster c ON l.CityCode = c.CityCode
INNER JOIN WeatherCodeMaster w ON l.WeatherCode = w.WeatherCode
WHERE c.CountryCode <> 'JP'
ORDER BY l.Temperature ASC;
"""

# ▼ DB 接続
conn = pyodbc.connect(
    f"DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USER};PWD={PASSWORD}"
)
cursor = conn.cursor()

cursor.execute(SQL_JP)
rows_jp = cursor.fetchall()

cursor.execute(SQL_NOTJP)
rows_notjp = cursor.fetchall()

cursor.execute("SELECT MinDI, MaxDI, LevelName FROM ComfortLevel")
eval_rows = cursor.fetchall()

conn.close()

# ▼ 不快指数計算
def calc_di(temp, hum):
    return round(0.81 * temp + 0.01 * hum * (0.99 * temp - 14.3) + 46.3, 2)

# ▼ 評価取得
def get_eval(di, eval_rows):
    for row in eval_rows:
        if float(row[0]) <= di <= float(row[1]):
            return row[2]
    return "評価なし"

# ▼ 列幅自動計算
def calc_width(rows, columns):
    widths = [len(col) for col in columns]
    for row in rows:
        for i, col in enumerate(row):
            widths[i] = max(widths[i], len(str(col)))
    return widths

# ▼ 行整形（数値右寄せ＋列間2スペース）
def format_row(row, widths, numeric_cols):
    formatted = []
    for i, col in enumerate(row):
        if i in numeric_cols:
            formatted.append(str(col).rjust(widths[i]))
        else:
            formatted.append(str(col).ljust(widths[i]))
    return "  ".join(formatted)  # ★ 列間は必ず半角2スペース

# ▼ 出力ファイル
output_path = r"C:\weather\output\jp_result.txt"

if os.path.exists(output_path):
    try:
        os.remove(output_path)
    except PermissionError:
        print("jp_result.txt が使用中です。閉じてから再実行してください。")
        exit()

with open(output_path, "w", encoding="utf-8") as f:

    if len(rows_jp) > 0:
        f.write(f"取得時間JST {rows_jp[0][4]}\n\n")

    # ▼ JP
    f.write("【国内（JP）】\n")
    jp_columns = ["地名", "温度(℃)", "湿度(%)", "天気", "不快指数", "評価"]
    jp_data = []

    for r in rows_jp:
        temp = float(r[1])
        hum = float(r[2])
        di = calc_di(temp, hum)
        ev = get_eval(di, eval_rows)
        jp_data.append([r[0], f"{temp:.2f}", f"{hum:.0f}", r[3], f"{di:.2f}", ev])

    jp_widths = calc_width(jp_data, jp_columns)
    numeric_cols_jp = [1, 2, 4]

    f.write(format_row(jp_columns, jp_widths, []) + "\n")
    f.write("-" * (sum(jp_widths) + len(jp_widths) * 2) + "\n")

    for row in jp_data:
        f.write(format_row(row, jp_widths, numeric_cols_jp) + "\n")

    f.write("\n\n")

    # ▼ NOTJP
    f.write("【海外（NOTJP）】\n")
    notjp_columns = ["地名", "温度(℃)", "湿度(%)", "天気", "国", "不快指数", "評価"]
    notjp_data = []

    for r in rows_notjp:
        temp = float(r[1])
        hum = float(r[2])
        di = calc_di(temp, hum)
        ev = get_eval(di, eval_rows)
        notjp_data.append([r[0], f"{temp:.2f}", f"{hum:.0f}", r[3], r[5], f"{di:.2f}", ev])

    notjp_widths = calc_width(notjp_data, notjp_columns)
    numeric_cols_notjp = [1, 2, 5]

    f.write(format_row(notjp_columns, notjp_widths, []) + "\n")
    f.write("-" * (sum(notjp_widths) + len(notjp_widths) * 2) + "\n")

    for row in notjp_data:
        f.write(format_row(row, notjp_widths, numeric_cols_notjp) + "\n")

print("JP + NOTJP のデータを出力しました:", output_path)

# ▼ OneDrive コピー
onedrive_base = r"C:\Users\winserverroot\OneDrive"
onedrive_hist = r"C:\Users\winserverroot\OneDrive\Historical"

shutil.copy(output_path, os.path.join(onedrive_base, "jp_result_mail.txt"))

today = datetime.now().strftime("%Y%m%d")
shutil.copy(output_path, os.path.join(onedrive_hist, f"jp_result_mail_{today}.txt"))

print("OneDrive へのコピーが完了しました。")
