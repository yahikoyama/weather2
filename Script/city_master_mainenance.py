import pyodbc
import json
import csv
import os

# ▼ 設定ファイル読み込み（PowerShell と同じ）
CONFIG_PATH = r"C:\WeatherSystem\Config\dbconfig.json"

with open(CONFIG_PATH, "r", encoding="utf-8") as f:
    config = json.load(f)

# ▼ DB接続文字列（PowerShell と同じ構造）
CONNECTION_STRING = (
    f"DRIVER={{SQL Server}};"
    f"SERVER={config['Server']};"
    f"DATABASE={config['Database']};"
    f"UID={config['User']};"
    f"PWD={config['Password']};"
)

def connect_db():
    return pyodbc.connect(CONNECTION_STRING)


# ▼ INSERT
def insert_city():
    print("\n--- Insert City ---")
    city = {}
    city["CityCode"] = input("CityCode: ")
    city["CityEn"] = input("CityEn: ")
    city["CityJp"] = input("CityJp: ")
    city["Latitude"] = float(input("Latitude: "))
    city["Longitude"] = float(input("Longitude: "))
    city["CountryCode"] = input("CountryCode: ")

    conn = connect_db()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO CityMaster (CityCode, CityEn, CityJp, Latitude, Longitude, CountryCode)
            VALUES (?, ?, ?, ?, ?, ?)
        """, tuple(city.values()))
        conn.commit()
        print("✔ Inserted successfully")
    except Exception as e:
        print("❌ Error:", e)
    finally:
        conn.close()


# ▼ UPDATE
def update_city():
    print("\n--- Update City ---")
    code = input("CityCode to update: ")

    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM CityMaster WHERE CityCode = ?", (code,))
    row = cur.fetchone()

    if not row:
        print("❌ City not found")
        conn.close()
        return

    print("Current:", row)

    city = {}
    city["CityEn"] = input("CityEn (blank=skip): ") or row.CityEn
    city["CityJp"] = input("CityJp (blank=skip): ") or row.CityJp
    city["Latitude"] = float(input("Latitude (blank=skip): ") or row.Latitude)
    city["Longitude"] = float(input("Longitude (blank=skip): ") or row.Longitude)
    city["CountryCode"] = input("CountryCode (blank=skip): ") or row.CountryCode

    cur.execute("""
        UPDATE CityMaster
        SET CityEn=?, CityJp=?, Latitude=?, Longitude=?, CountryCode=?
        WHERE CityCode=?
    """, (city["CityEn"], city["CityJp"], city["Latitude"], city["Longitude"], city["CountryCode"], code))

    conn.commit()
    conn.close()
    print("✔ Updated successfully")


# ▼ DELETE
def delete_city():
    print("\n--- Delete City ---")
    code = input("CityCode to delete: ")

    conn = connect_db()
    cur = conn.cursor()
    cur.execute("DELETE FROM CityMaster WHERE CityCode = ?", (code,))
    conn.commit()
    conn.close()

    print("✔ Deleted (if existed)")


# ▼ SELECT
def list_cities():
    print("\n--- City List ---")
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM CityMaster ORDER BY CityCode")
    rows = cur.fetchall()
    conn.close()

    for r in rows:
        print(r)


# ▼ CSV Import（MERGE）
def import_csv():
    print("\n--- Import from CSV ---")
    path = input("CSV file path: ")

    conn = connect_db()
    cur = conn.cursor()

    with open(path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            cur.execute("""
                MERGE CityMaster AS target
                USING (SELECT ? AS CityCode) AS src
                ON target.CityCode = src.CityCode
                WHEN MATCHED THEN
                    UPDATE SET
                        CityEn = ?, CityJp = ?, Latitude = ?, Longitude = ?, CountryCode = ?
                WHEN NOT MATCHED THEN
                    INSERT (CityCode, CityEn, CityJp, Latitude, Longitude, CountryCode)
                    VALUES (?, ?, ?, ?, ?, ?);
            """, (
                row["CityCode"],
                row["CityEn"], row["CityJp"], float(row["Latitude"]), float(row["Longitude"]), row["CountryCode"],
                row["CityCode"], row["CityEn"], row["CityJp"], float(row["Latitude"]), float(row["Longitude"]), row["CountryCode"]
            ))

    conn.commit()
    conn.close()
    print("✔ CSV imported")


# ▼ メインメニュー
def main():
    while True:
        print("\n===== CityMaster Maintenance (SQL Server) =====")
        print("1. Insert City")
        print("2. Update City")
        print("3. Delete City")
        print("4. List Cities")
        print("5. Import from CSV")
        print("0. Exit")

        choice = input("Select: ")

        if choice == "1":
            insert_city()
        elif choice == "2":
            update_city()
        elif choice == "3":
            delete_city()
        elif choice == "4":
            list_cities()
        elif choice == "5":
            import_csv()
        elif choice == "0":
            break
        else:
            print("Invalid selection")


if __name__ == "__main__":
    main()
