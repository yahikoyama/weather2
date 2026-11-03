import json
import pyodbc
import pandas as pd
import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
from PIL import Image

# ==========================================
# DB設定
# ==========================================

with open(
    r"C:\weather\config\dbconfig.json",
    "r",
    encoding="utf-8"
) as f:
    dbconf = json.load(f)

# ==========================================
# SQL Server接続
# ==========================================

conn_str = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={dbconf['Server']};"
    f"DATABASE={dbconf['Database']};"
    f"UID={dbconf['User']};"
    f"PWD={dbconf['Password']};"
)

conn = pyodbc.connect(conn_str)

sql = """
SELECT TOP 10
    c.Ranking,
    c.CityEn,
    c.CountryCode,
    c.FromDate,
    c.ToDate,
    m.Latitude,
    m.Longitude
FROM ComfortableRegionWeekly c
INNER JOIN CityMaster m
    ON c.CityCode = m.CityCode
WHERE c.FromDate =
(
    SELECT MAX(FromDate)
    FROM ComfortableRegionWeekly
)
ORDER BY c.Ranking;
"""

df = pd.read_sql(sql, conn)

conn.close()

if len(df) == 0:
    raise Exception("No data found.")

# ==========================================
# 日付
# ==========================================

from_date = pd.to_datetime(
    df.iloc[0]["FromDate"]
).strftime("%Y-%m-%d")

to_date = pd.to_datetime(
    df.iloc[0]["ToDate"]
).strftime("%Y-%m-%d")

title = (
    f"Top 10 Comfortable Cities This Week "
    f"({from_date} - {to_date})"
)

# ==========================================
# 地図画像
# ==========================================

map_file = r"C:\weather\images\world_map.png"
output_file = r"C:\weather\output\top10_worldmap.png"

img = Image.open(map_file)

width, height = img.size

fig, ax = plt.subplots(
    figsize=(18, 9),
    dpi=100
)

ax.imshow(
    img,
    extent=[-180, 180, -90, 90]
)

# ==========================================
# 地図上プロット
# ==========================================

for _, row in df.iterrows():

    lon = float(row["Longitude"])
    lat = float(row["Latitude"])

    label = (
        f"{int(row['Ranking'])} "
        f"{row['CityEn']} "
        f"({row['CountryCode']})"
    )

    # 全都市共通で左へ補正
    label_lon = lon - 10

    ax.text(
        label_lon,
        lat,
        label,
        fontsize=6,
        color="darkred",
        fontweight="bold"
    )

# ==========================================
# 太平洋ランキング
# ==========================================

ranking_lines = []

for _, row in df.iterrows():

    ranking_lines.append(
        f"{int(row['Ranking']):2d}. "
        f"{row['CityEn']} "
        f"({row['CountryCode']})"
    )

ranking_text = "\n".join(ranking_lines)

# 東京よりかなり右
ax.text(
    0.92,      # 右へ移動
    0.50,      # 下へ移動
    "Top 10 Ranking\n\n" + ranking_text,
    transform=ax.transAxes,
    fontsize=9,
    fontweight="bold",
    color="darkred",
    ha="left",
    va="center",
    bbox=dict(
        facecolor="white",
        edgecolor="navy",
        boxstyle="round,pad=0.5"
    )
)

# ==========================================
# タイトル
# ==========================================

ax.set_title(
    title,
    fontsize=18,
    color="navy",
    fontweight="bold",
    pad=10
)

# ==========================================
# 軸非表示
# ==========================================

ax.set_xlim(-180, 180)
ax.set_ylim(-90, 90)

ax.axis("off")

# ==========================================
# 保存
# ==========================================

import shutil

plt.savefig(
    output_file,
    bbox_inches="tight",
    pad_inches=0.05
)

plt.close()

# ==========================================
# 日付入りファイル名
# ==========================================

history_file_name = (
    f"weekly_comfortable_"
    f"{from_date}_{to_date}_top10.png"
)

# ==========================================
# OneDrive Historical_en
# ==========================================

one_drive_history = (
    rf"C:\Users\winserverroot\OneDrive\Historical_en\{history_file_name}"
)

shutil.copy2(
    output_file,
    one_drive_history
)

