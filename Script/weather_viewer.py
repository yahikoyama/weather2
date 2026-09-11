# -*- coding: utf-8 -*-
import tkinter as tk
from tkinter import ttk, messagebox
import pyodbc
import json

# ▼ JSON 読み込み（DB設定）
with open(r"C:\weather\Config\dbconfig.json", "r", encoding="utf-8") as f:
    config = json.load(f)

SERVER = config["Server"]
DATABASE = config["Database"]
USER = config["User"]
PASSWORD = config["Password"]

# ▼ 国名辞書（外部 JSON から読み込み）
with open(r"C:\weather\Config\country_fullname.json", "r", encoding="utf-8") as f:
    country_fullname = json.load(f)

# ▼ GUI 作成
root = tk.Tk()
root.title("最新気象データビューア")
root.geometry("1000x600")

# ▼ 並び順（ASC / DESC）
sort_order = tk.StringVar(value="ASC")

# ▼ 表示対象（ALL / JP / NOTJP）
display_filter = tk.StringVar(value="ALL")


# ▼ SQL 生成
def get_sql_query():
    where_clause = ""
    if display_filter.get() == "JP":
        where_clause = "WHERE c.CountryCode = 'JP'"
    elif display_filter.get() == "NOTJP":
        where_clause = "WHERE c.CountryCode <> 'JP'"

    # 海外のみのときだけ国列を追加
    country_column = ""
    if display_filter.get() == "NOTJP":
        country_column = ", c.CountryCode AS 国"

    return f"""
WITH LatestLog AS (
    SELECT
        wl.*
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
    {country_column}
FROM LatestLog l
INNER JOIN CityMaster c
    ON l.CityCode = c.CityCode
INNER JOIN WeatherCodeMaster w
    ON l.WeatherCode = w.WeatherCode
{where_clause}
ORDER BY l.Temperature {sort_order.get()};
"""


# ▼ Treeview の列を動的に切り替え
def rebuild_tree_columns():
    if display_filter.get() == "NOTJP":
        new_columns = ("地名", "温度", "湿度", "天気", "取得時間JST", "国")
    else:
        new_columns = ("地名", "温度", "湿度", "天気", "取得時間JST")

    tree["columns"] = new_columns

    for col in new_columns:
        tree.heading(col, text=col)
        tree.column(col, width=150)


# ▼ DB からデータ取得
def fetch_data():
    try:
        rebuild_tree_columns()

        conn = pyodbc.connect(
            f"DRIVER={{SQL Server}};"
            f"SERVER={SERVER};"
            f"DATABASE={DATABASE};"
            f"UID={USER};"
            f"PWD={PASSWORD}"
        )
        cursor = conn.cursor()
        cursor.execute(get_sql_query())
        rows = cursor.fetchall()
        conn.close()

        # 表クリア
        for row in tree.get_children():
            tree.delete(row)

        for r in rows:
            row = list(r)

            # 整形
            row[0] = str(row[0]).replace("(", "").replace(")", "").replace("'", "").replace(",", "").strip()
            row[3] = str(row[3]).replace("'", "").replace(",", "").strip()
            row[4] = str(row[4]).replace("'", "").strip()

            # ▼ 海外のみのときだけ国名を KR(KOREA) の形式に変換
            if display_filter.get() == "NOTJP":
                code = row[5]  # 国コード
                fullname = country_fullname.get(code, "UNKNOWN")
                row[5] = f"{code}({fullname})"

            tree.insert("", tk.END, values=row)

    except Exception as e:
        messagebox.showerror("エラー", f"データ取得に失敗しました\n{e}")


# ▼ 上部フレーム
top_frame = tk.Frame(root)
top_frame.pack(pady=10)

# ▼ 最新データ取得ボタン
btn = tk.Button(top_frame, text="最新データ取得", command=fetch_data, font=("Meiryo", 12))
btn.grid(row=0, column=0, padx=10)

# ▼ 並び順ラジオボタン
tk.Label(top_frame, text="並び順：", font=("Meiryo", 12)).grid(row=0, column=1)

tk.Radiobutton(top_frame, text="寒い順（ASC）", variable=sort_order, value="ASC",
               command=fetch_data, font=("Meiryo", 12)).grid(row=0, column=2, padx=5)

tk.Radiobutton(top_frame, text="暑い順（DESC）", variable=sort_order, value="DESC",
               command=fetch_data, font=("Meiryo", 12)).grid(row=0, column=3, padx=5)

# ▼ 表示対象ラジオボタン
tk.Label(top_frame, text="表示対象：", font=("Meiryo", 12)).grid(row=1, column=0, pady=10)

tk.Radiobutton(top_frame, text="すべて", variable=display_filter, value="ALL",
               command=fetch_data, font=("Meiryo", 12)).grid(row=1, column=1, padx=5)

tk.Radiobutton(top_frame, text="国内のみ（JP）", variable=display_filter, value="JP",
               command=fetch_data, font=("Meiryo", 12)).grid(row=1, column=2, padx=5)

tk.Radiobutton(top_frame, text="海外のみ（NOT JP）", variable=display_filter, value="NOTJP",
               command=fetch_data, font=("Meiryo", 12)).grid(row=1, column=3, padx=5)

# ▼ 表（Treeview）
tree = ttk.Treeview(root, columns=("地名", "温度", "湿度", "天気", "取得時間JST"), show="headings", height=18)

for col in ("地名", "温度", "湿度", "天気", "取得時間JST"):
    tree.heading(col, text=col)
    tree.column(col, width=150)

tree.pack(fill=tk.BOTH, expand=True)

root.mainloop()
