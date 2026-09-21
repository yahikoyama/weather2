# 🧱 Hướng dẫn cài đặt weather2

## 📘 Tổng quan

### Cấu trúc thư mục (Local)

```
c:\weather
├─config                 # Tệp cấu hình (DB, API, GitHub) và từ điển
├─Data                   # cities.csv (không dùng nếu bạn khôi phục file backup DB)
├─Data-Extraction-SQL    # Công cụ trích xuất dữ liệu
├─DBBackup               # File backup SQL Server
├─Logs                   # Không sử dụng
├─output                 # index.html, jp_result.txt (tạo lúc 14:00 JST)
├─Script                 # Script PowerShell, file batch, và script Python
├─Setup                  # Hướng dẫn cài đặt và chuẩn bị môi trường
└─TaskScheduler          # Định nghĩa XML của Task Scheduler
```

```
c:\winserverroot\OneDrive
├─Historical        # Dữ liệu lịch sử JP
├─Historical_en     # Dữ liệu lịch sử EN
```

Các tệp trong `c:\winserverroot\OneDrive` sẽ được upload lên GitHub.  
Đường dẫn này có thể thay đổi trong `c:\weather\Script\ps1` và `.bat`.

---

## 🛠 Chuẩn bị

### 🔑 Lấy OpenWeather API Key  
https://openweathermap.org/api  
Dùng trong `c:\weather\config\dbconfig.json`.

### 🔑 Lấy GitHub Token  
Dùng trong `c:\weather\config\sync.json`.

### 📥 Tải tệp từ GitHub  
Đặt tệp vào đúng đường dẫn:

```
c:\weather\

c:\winserverroot\OneDrive
```

---

## 🚀 Các bước cài đặt

### 1) Cài đặt SQL Server 2022 Express

Tải xuống:  
https://www.microsoft.com/ja-jp/download/details.aspx?id=104781

SETUP.EXE  
- Chạy với quyền Administrator  
- Cài đặt SQL Server độc lập mới  
- Chấp nhận điều khoản → Next  
- KHÔNG chọn “Use Microsoft Update to check for updates”  
- Next → Next  
- Bỏ chọn “SQL Server Azure extension” → Next  
- Giữ nguyên tính năng mặc định → Next  
- Chọn “Default instance” → Next  
- Giữ nguyên tài khoản dịch vụ → Next  
- Chọn Mixed Mode  
  Mật khẩu: `test@123`  
  (Hãy ghi lại mật khẩu)

Mật khẩu này dùng trong:

```
c:\weather\config\dbconfig.json
```

---

### 2) Cài đặt SQL Server Management Studio (SSMS)

https://learn.microsoft.com/ja-jp/ssms/install/install

vs_SSMS.exe  
- Chạy với quyền Administrator  
- Continue  
- Không chọn workload nào → Install

Sau khi mở SSMS:  
Bỏ qua bước thêm tài khoản.

Thiết lập kết nối:  
- Server name: `(local)`  
- Authentication: SQL Server Authentication  
- Username: `sa`  
- Password: `test@123`  
- Chọn “Remember password”  
- Database: <Default>  
- Encryption: Optional

Nếu Object Explorer xuất hiện → OK.

---

### 3) Khôi phục cơ sở dữ liệu

Object Explorer →  
Chuột phải **Databases** → **Restore Database**

- Chọn “Device” → nhấn “…”  
- Chọn file:  
  `C:\Weather\DBBackup\weather\2026mmdd.bak`  
- OK → OK

Nếu thấy thông báo **“Database 'weather' restored successfully”**, là hoàn tất.

---

### 4) Chỉnh sửa `c:\weather\config\dbconfig.json`

Mở bằng Notepad.

Chỉnh các trường:  
- Server  
- Password  
- OpenWeatherApiKey

```json
{
    "Server": "(local)",
    "Database": "weather",
    "User": "sa",
    "Password": "test@123",
    "OpenWeatherApiKey": "????????"
}
```

Ghi chú:  
- Dùng `(local)` hoặc IP của server  
- Dán API Key của bạn  
- Tên database phải trùng với DB đã khôi phục  
- User là `sa`

---

### 5) Kiểm tra lấy dữ liệu thủ công

Command Prompt:

```
cd c:\weather\script
WeatherLogger.bat
```

Nếu giá trị trả về **1** liên tục → dữ liệu đang được ghi vào DB.

Kiểm tra thêm:

```
c:\weather\logs\
```

SQL:

```sql
SELECT *
  FROM [weather].[dbo].[WeatherLog]
  ORDER BY 1 DESC;
```

Nếu có dữ liệu mới → hoạt động bình thường.

---

### 6) Thêm tác vụ Windows (tự động lấy dữ liệu)

Task Scheduler → Create New Task  
Tên: **get-temp-data**

**General**  
- Chạy dù người dùng có đăng nhập hay không  
- Chạy với quyền cao nhất

**Triggers**  
Hàng ngày:

```
0:00 4:00 8:00 12:00 14:00 16:00 20:00
```

**Actions**  
Program:

```
C:\weather\Script\WeatherLogger.bat
```

Start in:

```
C:\weather\Script
```

**Settings**  
Bỏ chọn “Stop the task if it runs longer than…”

Sau khi tạo, nhấn “Enable All Tasks History”.  
“History (disabled)” → “History”.

---

### 7) Cài đặt Python (để xem dữ liệu)

python‑3.14.6‑amd64.exe  
- Chạy với quyền Administrator  
- Chọn “Use admin privileges when installing py.exe”  
- Chọn “Add python.exe to PATH”  
- Nhấn **Install Now**

---

### 8) Cài đặt Python ODBC Driver (pyodbc)

PowerShell:

```
pip install pyodbc
```

Kết quả mong đợi:

```
Downloading pyodbc-5.3.0...
Installing collected packages: pyodbc
Successfully installed pyodbc-5.3.0
```

---

### 9) Xem dữ liệu đã lấy

Command Prompt:

```
c:\weather\Script\weather\viewer.py
```

---

### 10) Tự động backup DB

Tạo tác vụ DBbackup giống bước 6

Hoặc import:

```
c:\weather\TaskScheduler\DBbackup.xml
```

---

### 11) Xuất file văn bản

Command Prompt:

```
c:\weather\Script\export_jp.py
```

Kết quả:

```
c:\weather\output\jp_result.txt
```

File `jp_result.txt` sẽ xuất hiện trong thư mục `output`.

