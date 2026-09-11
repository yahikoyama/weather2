# -*- coding: utf-8 -*-
import tkinter as tk
from tkinter import ttk, messagebox
import pyodbc
import json

# ▼ Load DB config
with open(r"C:\weather\Config\dbconfig.json", "r", encoding="utf-8") as f:
    config = json.load(f)

SERVER = config["Server"]
DATABASE = config["Database"]
USER = config["User"]
PASSWORD = config["Password"]

# ▼ Load country full name dictionary (external JSON)
with open(r"C:\weather\Config\country_fullname.json", "r", encoding="utf-8") as f:
    country_fullname = json.load(f)

# ▼ GUI
root = tk.Tk()
root.title("Latest Weather Data Viewer (English Version)")
root.geometry("1000x600")

# ▼ Sort order (ASC / DESC)
sort_order = tk.StringVar(value="ASC")

# ▼ Display filter (ALL / JP / NOTJP)
display_filter = tk.StringVar(value="ALL")


# ▼ SQL generator
def get_sql_query():
    where_clause = ""
    if display_filter.get() == "JP":
        where_clause = "WHERE c.CountryCode = 'JP'"
    elif display_filter.get() == "NOTJP":
        where_clause = "WHERE c.CountryCode <> 'JP'"

    # Add country column only for NOTJP
    country_column = ""
    if display_filter.get() == "NOTJP":
        country_column = ", c.CountryCode AS Country"

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
    c.CityEn AS City,
    l.Temperature AS Temperature,
    l.Humidity AS Humidity,
    w.WeatherGroup AS Weather,
    FORMAT(l.CreatedAt, 'yyyy-MM-dd HH:mm:ss') AS TimeJST
    {country_column}
FROM LatestLog l
INNER JOIN CityMaster c
    ON l.CityCode = c.CityCode
INNER JOIN WeatherCodeMaster w
    ON l.WeatherCode = w.WeatherCode
{where_clause}
ORDER BY l.Temperature {sort_order.get()};
"""


# ▼ Rebuild Treeview columns dynamically
def rebuild_tree_columns():
    if display_filter.get() == "NOTJP":
        new_columns = ("City", "Temperature", "Humidity", "Weather", "TimeJST", "Country")
    else:
        new_columns = ("City", "Temperature", "Humidity", "Weather", "TimeJST")

    tree["columns"] = new_columns

    for col in new_columns:
        tree.heading(col, text=col)
        tree.column(col, width=150)


# ▼ Fetch data from DB
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

        # Clear table
        for row in tree.get_children():
            tree.delete(row)

        for r in rows:
            row = list(r)

            # Clean strings
            row[0] = str(row[0]).strip()
            row[3] = str(row[3]).strip()
            row[4] = str(row[4]).strip()

            # Add country full name only for NOTJP
            if display_filter.get() == "NOTJP":
                code = row[5]
                fullname = country_fullname.get(code, "UNKNOWN")
                row[5] = f"{code}({fullname})"

            tree.insert("", tk.END, values=row)

    except Exception as e:
        messagebox.showerror("Error", f"Failed to fetch data\n{e}")


# ▼ Top frame
top_frame = tk.Frame(root)
top_frame.pack(pady=10)

# ▼ Fetch button
btn = tk.Button(top_frame, text="Fetch Latest Data", command=fetch_data, font=("Segoe UI", 12))
btn.grid(row=0, column=0, padx=10)

# ▼ Sort order
tk.Label(top_frame, text="Sort Order:", font=("Segoe UI", 12)).grid(row=0, column=1)

tk.Radiobutton(top_frame, text="Coldest First (ASC)", variable=sort_order, value="ASC",
               command=fetch_data, font=("Segoe UI", 12)).grid(row=0, column=2, padx=5)

tk.Radiobutton(top_frame, text="Hottest First (DESC)", variable=sort_order, value="DESC",
               command=fetch_data, font=("Segoe UI", 12)).grid(row=0, column=3, padx=5)

# ▼ Display filter
tk.Label(top_frame, text="Display:", font=("Segoe UI", 12)).grid(row=1, column=0, pady=10)

tk.Radiobutton(top_frame, text="All", variable=display_filter, value="ALL",
               command=fetch_data, font=("Segoe UI", 12)).grid(row=1, column=1, padx=5)

tk.Radiobutton(top_frame, text="Japan Only (JP)", variable=display_filter, value="JP",
               command=fetch_data, font=("Segoe UI", 12)).grid(row=1, column=2, padx=5)

tk.Radiobutton(top_frame, text="Overseas Only (NOT JP)", variable=display_filter, value="NOTJP",
               command=fetch_data, font=("Segoe UI", 12)).grid(row=1, column=3, padx=5)

# ▼ Table
tree = ttk.Treeview(root, columns=("City", "Temperature", "Humidity", "Weather", "TimeJST"), show="headings", height=18)

for col in ("City", "Temperature", "Humidity", "Weather", "TimeJST"):
    tree.heading(col, text=col)
    tree.column(col, width=150)

tree.pack(fill=tk.BOTH, expand=True)

root.mainloop()
