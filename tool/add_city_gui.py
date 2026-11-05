# ==========================================
# part1
# ==========================================


import tkinter as tk
from tkinter import messagebox
import pyodbc
import json
import os
import shutil
from datetime import datetime

# ==========================================
# Output Directory
# ==========================================

OUTPUT_DIR = r"C:\weather\tool\add-city"

os.makedirs(
    OUTPUT_DIR,
    exist_ok=True
)

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
# SQL Server接続文字列
# ==========================================

conn_str = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={dbconf['Server']};"
    f"DATABASE={dbconf['Database']};"
    f"UID={dbconf['User']};"
    f"PWD={dbconf['Password']};"
)

# ==========================================
# Config Directory
# ==========================================

CONFIG_DIR = r"C:\weather\config"

# ==========================================
# Dictionary Files
# ==========================================

DICT_FILES = [
    "dictionary_daily.json",
    "dictionary_ptbr.json",
    "dictionary_ar.json",
    "dictionary_vi.json",
    "dictionary_ko.json",
    "dictionary_zh.json",
    "dictionary_ru.json",
    "dictionary.json",
    "country_fullname.json"
]

# ==========================================
# JSON Utility
# ==========================================

def load_json(path):

    with open(
        path,
        "r",
        encoding="utf-8"
    ) as f:

        return json.load(f)

def save_json(path, data):

    with open(
        path,
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(
            data,
            f,
            ensure_ascii=False,
            indent=2
        )

# ==========================================
# Backup Dictionary Files
# ==========================================

def backup_files():

    timestamp = datetime.now().strftime(
        "%Y%m%d_%H%M%S"
    )

    backup_list = []

    for filename in DICT_FILES:

        source_file = os.path.join(
            CONFIG_DIR,
            filename
        )

        if not os.path.exists(source_file):
            continue

        backup_file = (
            source_file
            + "."
            + timestamp
            + ".bak"
        )

        shutil.copy2(
            source_file,
            backup_file
        )

        backup_list.append(
            os.path.basename(
                backup_file
            )
        )

    return backup_list

# ==========================================
# CityCode 初期値取得
# ==========================================

def get_next_city_code_from_db():

    conn = pyodbc.connect(
        conn_str
    )

    cursor = conn.cursor()

    cursor.execute("""
    SELECT
        ISNULL(
            MAX(
                CAST(CityCode AS INT)
            ),
            0
        )
    FROM CityMaster
    """)

    max_code = cursor.fetchone()[0]

    conn.close()

    return str(
        max_code + 1
    ).zfill(4)

# ==========================================
# CityEn 重複チェック
# ==========================================

def find_duplicate_city(
    cursor,
    city_en
):

    sql = """
    SELECT
        CityCode
    FROM CityMaster
    WHERE
        UPPER(CityEn)
        =
        UPPER(?)
    """

    cursor.execute(
        sql,
        city_en
    )

    return cursor.fetchone()

# ==========================================
# CityCode 重複チェック
# ==========================================

def find_duplicate_city_code(
    cursor,
    city_code
):

    sql = """
    SELECT
        CityCode
    FROM CityMaster
    WHERE
        CityCode = ?
    """

    cursor.execute(
        sql,
        city_code
    )

    return cursor.fetchone()

# ==========================================
# CityMaster Backup Table
# ==========================================

def backup_citymaster(
    cursor
):

    backup_table = (
        "CityMaster_BK_"
        + datetime.now().strftime(
            "%Y%m%d_%H%M%S"
        )
    )

    sql = f"""
    SELECT *
    INTO {backup_table}
    FROM CityMaster
    """

    cursor.execute(sql)

    return backup_table

# ==========================================
# part2
# ==========================================
# ==========================================
# dictionary_daily.json
# place[CityJp] = CityEn
# ==========================================

def update_dictionary_daily(
    city_jp,
    city_en
):

    path = os.path.join(
        CONFIG_DIR,
        "dictionary_daily.json"
    )

    data = load_json(path)

    if "place" not in data:
        data["place"] = {}

    data["place"][city_jp] = city_en

    save_json(
        path,
        data
    )

# ==========================================
# Generic Dictionary Update
# place[CityJp] = Translation
# ==========================================

def update_dictionary_place(
    filename,
    city_jp,
    translated_name
):

    if translated_name == "":
        return

    path = os.path.join(
        CONFIG_DIR,
        filename
    )

    if not os.path.exists(path):
        return

    data = load_json(path)

    if "place" not in data:
        data["place"] = {}

    data["place"][city_jp] = translated_name

    save_json(
        path,
        data
    )

# ==========================================
# country_fullname.json
# ==========================================

def update_country_fullname(
    country_code,
    country_name
):

    path = os.path.join(
        CONFIG_DIR,
        "country_fullname.json"
    )

    data = load_json(path)

    data[country_code] = country_name

    save_json(
        path,
        data
    )

# ==========================================
# Update All Dictionaries
# ==========================================

def update_all_dictionaries(

    city_jp,
    city_en,

    city_zh,
    city_ko,
    city_ru,
    city_vi,
    city_ar,
    city_pt,

    country_code,
    country_name

):

    # dictionary_daily.json
    update_dictionary_daily(
        city_jp,
        city_en
    )

    # dictionary.json (Weekly English)
    update_dictionary_place(
        "dictionary.json",
        city_jp,
        city_en
    )

    # Chinese
    update_dictionary_place(
        "dictionary_zh.json",
        city_jp,
        city_zh
    )

    # Korean
    update_dictionary_place(
        "dictionary_ko.json",
        city_jp,
        city_ko
    )

    # Russian
    update_dictionary_place(
        "dictionary_ru.json",
        city_jp,
        city_ru
    )

    # Vietnamese
    update_dictionary_place(
        "dictionary_vi.json",
        city_jp,
        city_vi
    )

    # Arabic
    update_dictionary_place(
        "dictionary_ar.json",
        city_jp,
        city_ar
    )

    # Portuguese
    update_dictionary_place(
        "dictionary_ptbr.json",
        city_jp,
        city_pt
    )

    # Country Full Name
    update_country_fullname(
        country_code,
        country_name
    )

# ==========================================
# part3
# ==========================================
# ==========================================
# INSERT CityMaster
# ==========================================

def insert_citymaster(
    cursor,
    city_code,
    city_en,
    city_jp,
    latitude,
    longitude,
    country_code
):

    sql = """
    INSERT INTO CityMaster
    (
        CityCode,
        CityEn,
        CityJp,
        Latitude,
        Longitude,
        CountryCode
    )
    VALUES
    (
        ?,
        ?,
        ?,
        ?,
        ?,
        ?
    )
    """

    cursor.execute(
        sql,
        city_code,
        city_en,
        city_jp,
        float(latitude),
        float(longitude),
        country_code
    )

# ==========================================
# SAVE add-city.sql
# ==========================================

def save_sql_file(
    city_code,
    city_en,
    city_jp,
    latitude,
    longitude,
    country_code
):

    sql_text = f"""
INSERT INTO CityMaster
(
    CityCode,
    CityEn,
    CityJp,
    Latitude,
    Longitude,
    CountryCode
)
VALUES
(
    '{city_code}',
    '{city_en}',
    '{city_jp}',
    {latitude},
    {longitude},
    '{country_code}'
);
"""

    output_file = os.path.join(
        OUTPUT_DIR,
        "add-city.sql"
    )

    with open(
        output_file,
        "w",
        encoding="utf-8"
    ) as f:

        f.write(sql_text)

# ==========================================
# Register Processing
# ==========================================

def register_city():

    conn = None

    try:

        city_code = (
            txt_city_code
            .get()
            .strip()
        )

        city_en = (
            txt_city_en
            .get()
            .strip()
        )

        city_jp = (
            txt_city_jp
            .get()
            .strip()
        )

        country_code = (
            txt_country_code
            .get()
            .strip()
            .upper()
        )

        country_name = (
            txt_country_name
            .get()
            .strip()
        )

        latitude = (
            txt_latitude
            .get()
            .strip()
        )

        longitude = (
            txt_longitude
            .get()
            .strip()
        )

        city_zh = txt_zh.get().strip()
        city_ko = txt_ko.get().strip()
        city_ru = txt_ru.get().strip()
        city_vi = txt_vi.get().strip()
        city_ar = txt_ar.get().strip()
        city_pt = txt_pt.get().strip()

        # --------------------------
        # Necessary Check
        # --------------------------

        if city_code == "":
            raise Exception(
                "City Code is necessary."
            )

        if city_en == "":
            raise Exception(
                "City English Name is necessary."
            )

        if city_jp == "":
            raise Exception(
                "City Japanese Name is necessary."
            )

        if country_code == "":
            raise Exception(
                "Country Code is necessary."
            )

        if country_name == "":
            raise Exception(
                "Country Full Name is necessary."
            )

        if latitude == "":
            raise Exception(
                "Latitude is necessary."
            )

        if longitude == "":
            raise Exception(
                "Longitude is necessary."
            )

        # --------------------------
        # SQL Server Connect
        # --------------------------

        conn = pyodbc.connect(
            conn_str
        )

        cursor = conn.cursor()

        # --------------------------
        # CityEn Duplicate Check
        # --------------------------

        duplicate_city = (
            find_duplicate_city(
                cursor,
                city_en
            )
        )

        if duplicate_city:

            raise Exception(
                f"{city_en} already exists.\n"
                f"CityCode={duplicate_city[0]}"
            )

        # --------------------------
        # CityCode Duplicate Check
        # --------------------------

        duplicate_code = (
            find_duplicate_city_code(
                cursor,
                city_code
            )
        )

        if duplicate_code:

            raise Exception(
                f"CityCode already exists.\n"
                f"CityCode={city_code}"
            )

        # --------------------------
        # Backup CityMaster
        # --------------------------

        backup_table = ""

        if backup_citymaster_var.get():

            backup_table = (
                backup_citymaster(
                    cursor
                )
            )

        # --------------------------
        # Backup Dictionaries
        # --------------------------

        backup_list = []

        if backup_dict_var.get():

            backup_list = (
                backup_files()
            )

        # --------------------------
        # Insert DB
        # --------------------------

        insert_citymaster(
            cursor,
            city_code,
            city_en,
            city_jp,
            latitude,
            longitude,
            country_code
        )

        # --------------------------
        # Save SQL
        # --------------------------

        save_sql_file(
            city_code,
            city_en,
            city_jp,
            latitude,
            longitude,
            country_code
        )

        # --------------------------
        # Update Dictionaries
        # --------------------------

        update_all_dictionaries(
            city_jp=city_jp,
            city_en=city_en,
            city_zh=city_zh,
            city_ko=city_ko,
            city_ru=city_ru,
            city_vi=city_vi,
            city_ar=city_ar,
            city_pt=city_pt,
            country_code=country_code,
            country_name=country_name
        )

        # --------------------------
        # COMMIT
        # --------------------------

        conn.commit()

        conn.close()

        messagebox.showinfo(
            "Completed",
            f"CityCode : {city_code}\n\n"
            f"CityEn : {city_en}\n"
            f"CityJp : {city_jp}\n\n"
            f"Backup Table :\n"
            f"{backup_table}\n\n"
            f"Dictionary Backups :\n"
            f"{len(backup_list)} files\n\n"
            f"Completed Successfully"
        )

    except Exception as ex:

        try:

            if conn is not None:
                conn.rollback()

        except:
            pass

        try:

            if conn is not None:
                conn.close()

        except:
            pass

        messagebox.showerror(
            "Error",
            "Rollback executed.\n\n"
            + str(ex)
        )

# ==========================================
# part4
# ==========================================
# ==========================================
# GUI
# ==========================================

root = tk.Tk()

root.title(
    "Weather2 City Registration Tool"
)

root.geometry("950x750")

# ==========================================
# Helper
# ==========================================

current_row = 0

def create_entry(
    label_text,
    status_text
):

    global current_row

    lbl = tk.Label(
        root,
        text=label_text,
        width=25,
        anchor="w"
    )

    lbl.grid(
        row=current_row,
        column=0,
        padx=5,
        pady=4,
        sticky="w"
    )

    txt = tk.Entry(
        root,
        width=50
    )

    txt.grid(
        row=current_row,
        column=1,
        padx=5,
        pady=4,
        sticky="w"
    )

    status = tk.Label(
        root,
        text=status_text,
        width=12,
        anchor="w"
    )

    status.grid(
        row=current_row,
        column=2,
        padx=5,
        pady=4,
        sticky="w"
    )

    current_row += 1

    return txt

# ==========================================
# Input Area
# ==========================================

txt_city_code = create_entry(
    "City Code",
    "necessary"
)

txt_city_code.insert(
    0,
    get_next_city_code_from_db()
)

txt_city_en = create_entry(
    "City English Name",
    "necessary"
)

txt_city_jp = create_entry(
    "City Japanese Name",
    "necessary"
)

txt_country_code = create_entry(
    "Country Code",
    "necessary"
)

txt_country_name = create_entry(
    "Country Full Name",
    "necessary"
)

txt_latitude = create_entry(
    "Latitude",
    "necessary"
)

txt_longitude = create_entry(
    "Longitude",
    "necessary"
)

txt_zh = create_entry(
    "Chinese Name",
    "optional"
)

txt_ko = create_entry(
    "Korean Name",
    "optional"
)

txt_ru = create_entry(
    "Russian Name",
    "optional"
)

txt_vi = create_entry(
    "Vietnamese Name",
    "optional"
)

txt_ar = create_entry(
    "Arabic Name",
    "optional"
)

txt_pt = create_entry(
    "Portuguese Name",
    "optional"
)

# ==========================================
# Separator
# ==========================================

tk.Label(
    root,
    text="------------------------------------------------------------"
).grid(
    row=current_row,
    column=0,
    columnspan=3,
    pady=10
)

current_row += 1

# ==========================================
# Options
# ==========================================

backup_citymaster_var = tk.BooleanVar(
    value=True
)

backup_dict_var = tk.BooleanVar(
    value=True
)

chk1 = tk.Checkbutton(
    root,
    text="Backup CityMaster Table",
    variable=backup_citymaster_var
)

chk1.grid(
    row=current_row,
    column=0,
    sticky="w",
    padx=5
)

current_row += 1

chk2 = tk.Checkbutton(
    root,
    text="Backup Dictionary Files",
    variable=backup_dict_var
)

chk2.grid(
    row=current_row,
    column=0,
    sticky="w",
    padx=5
)

current_row += 1

# ==========================================
# Information
# ==========================================

tk.Label(
    root,
    text="Default CityCode is MAX(CityCode)+1. You may modify it manually."
).grid(
    row=current_row,
    column=0,
    columnspan=3,
    sticky="w",
    padx=5
)

current_row += 1

tk.Label(
    root,
    text="CityCode duplicates are checked automatically."
).grid(
    row=current_row,
    column=0,
    columnspan=3,
    sticky="w",
    padx=5
)

current_row += 1

tk.Label(
    root,
    text="CityEn duplicates are checked automatically."
).grid(
    row=current_row,
    column=0,
    columnspan=3,
    sticky="w",
    padx=5
)

current_row += 1

tk.Label(
    root,
    text="Rollback is executed automatically if any error occurs."
).grid(
    row=current_row,
    column=0,
    columnspan=3,
    sticky="w",
    padx=5
)

current_row += 2

# ==========================================
# Register Button
# ==========================================

btn_register = tk.Button(
    root,
    text="Register City",
    width=30,
    height=2,
    bg="lightgreen",
    command=register_city
)

btn_register.grid(
    row=current_row,
    column=1,
    pady=10
)

current_row += 1

# ==========================================
# Exit Button
# ==========================================

btn_exit = tk.Button(
    root,
    text="Exit",
    width=30,
    command=root.destroy
)

btn_exit.grid(
    row=current_row,
    column=1,
    pady=5
)

# ==========================================
# Start GUI
# ==========================================

root.mainloop()