# 🌍 Chỉ số khó chịu toàn cầu (cập nhật mỗi 4 giờ)

## 👉 **Báo cáo thời tiết toàn cầu đa ngôn ngữ — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_vi.html">

<img width="521" height="359" alt="image" src="https://github.com/user-attachments/assets/2959d9be-1fee-4ec4-b39c-83ee34ef8b5c" />

</a>

---

# 🌦️ Báo cáo thời tiết hằng ngày (tự động cập nhật)

| Ngôn ngữ | URL | Tần suất cập nhật |
|---------|-----|-------------------|
| 🇯🇵 Tiếng Nhật | https://yahikoyama.github.io/weather2/weather_report_now.html | Mỗi 4 giờ |
| 🇬🇧 Tiếng Anh | https://yahikoyama.github.io/weather2/weather_report_now_en.html | Mỗi 4 giờ (JST) |
| 🇷🇺 Tiếng Nga | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | Mỗi 4 giờ (JST) |
| 🇨🇳 Tiếng Trung (Giản thể) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | Mỗi 4 giờ (JST) |
| 🇰🇷 Tiếng Hàn | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | Mỗi 4 giờ (JST) |
| 🇻🇳 Tiếng Việt | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | Mỗi 4 giờ (JST) |
| 🇦🇪 Tiếng Ả Rập | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | Mỗi 4 giờ (JST) |
| 🇧🇷 Tiếng Bồ Đào Nha (Brazil) | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | Mỗi 4 giờ (JST) |

---

# 📜 Báo cáo thời tiết lịch sử

Lưu trữ dữ liệu thời tiết và chỉ số khó chịu (DI) hằng ngày:

- 🇬🇧 Tiếng Anh  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 Tiếng Nhật  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 Chỉ số hằng ngày  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html

---

Dự án này trực quan hóa chỉ số khó chịu toàn cầu mỗi 4 giờ.  
Bạn có thể xem thành phố nào nóng, lạnh, ẩm hoặc dễ chịu.

---

# 📌 Tổng quan

Dự án sử dụng dữ liệu thời tiết thời gian thực từ **OpenWeatherMap API**,  
tính toán **Chỉ số khó chịu (DI)** dựa trên **nhiệt độ, độ ẩm và điều kiện thời tiết**.

- ⏱ **Tự động cập nhật mỗi 4 giờ**  
- 🌐 **Hỗ trợ 8 ngôn ngữ**  
- 📊 **Có lưu trữ dữ liệu lịch sử**  
- ⚙️ **Tự động hóa hoàn toàn bằng PowerShell + SQL Server + Python + GitHub Pages**

Ứng dụng cho:
- Giám sát thời tiết  
- Đánh giá nguy cơ nắng nóng  
- Quan sát môi trường  
- Học tập về tự động hóa (PowerShell / SQL / Python)

---

# 📘 Giới thiệu dự án

Dự án tự động thu thập dữ liệu thời tiết toàn cầu (nhiệt độ, độ ẩm, điều kiện thời tiết),  
tính toán **DI**, và xuất báo cáo HTML đa ngôn ngữ lên **GitHub Pages**.

Phù hợp cho việc học:
- Cơ sở dữ liệu SQL  
- Tự động hóa PowerShell  
- Xử lý dữ liệu bằng Python  
- Tạo HTML đa ngôn ngữ  
- Triển khai GitHub Pages

Để thêm thành phố mới, hãy chèn bản ghi vào bảng **CityMaster**.

---

# 🏗️ Kiến trúc hệ thống

### Công nghệ sử dụng
- Windows 11 Pro (tự động hóa bằng Task Scheduler)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (tối đa 10GB)
- Python 3.14 + pyodbc (trình điều khiển ODBC)

---

## 📦 Nội dung trong kho GitHub

Tất cả các tệp trước đây nằm trong **weather.zip**  
nay đã được cung cấp đầy đủ trong kho GitHub dưới dạng thư mục riêng.

Bao gồm:

- Mã nguồn đầy đủ  
- Tập lệnh SQL & bản sao lưu cơ sở dữ liệu  
- Mẫu cấu hình (config.ps1, sql1.ps1, v.v.)  
- Tập lệnh tự động hóa (BAT / PowerShell)  
- Tệp XML Task Scheduler để tự động chạy

Hãy cấu hình các tệp theo môi trường của bạn  
và nhập XML Task Scheduler nếu muốn tự động hóa.

📩 Liên hệ: **yahikoyama.777@gmail.com**

---

# 🌐 Ngôn ngữ hỗ trợ

[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

---

# 🚀 Bắt đầu nhanh

### 1. Sao chép kho mã

```bash
git clone https://github.com/yahikoyama/weather2

weather2/
├── Historical/                # Lưu trữ tiếng Nhật
├── Historical_en/             # Lưu trữ tiếng Anh
├── SRC_DB_SETTING/            # Sao lưu DB & tệp cấu hình
├── DBBackup/                  # Sao lưu SQL Server hằng ngày
├── weather_report_now.html    # Báo cáo tiếng Nhật
├── weather_report_now_en.html # Báo cáo tiếng Anh
├── weather_report_now_ko.html # Báo cáo tiếng Hàn
├── weather_report_now_ru.html # Báo cáo tiếng Nga
├── weather_report_now_zh.html # Báo cáo tiếng Trung
├── weather_report_now_vi.html # Báo cáo tiếng Việt
├── weather_report_now_ar.html # Báo cáo tiếng Ả Rập
├── weather_report_now_ptbr.html # Báo cáo tiếng Bồ Đào Nha (Brazil)


🌐 Nhiệm vụ tạo báo cáo thời tiết đa ngôn ngữ
| Tệp XML | Chức năng | Lịch chạy |
| --- | --- | --- |
| get-temp-data.xml | Lấy dữ liệu API → ghi vào SQL Server | Theo kích hoạt |
| make-txt-file.xml | Tạo dữ liệu văn bản | Mỗi 4 giờ |

| export_jp_latest_sync_html.xml | Tạo HTML đa ngôn ngữ → tải lên GitHub | Mỗi 4 giờ |
| Historicaldata_daily.xml | Tạo dữ liệu hằng ngày | 14:00 JST mỗi ngày |

📜 Nhiệm vụ tạo dữ liệu lịch sử
| Tệp XML | Chức năng | Lịch chạy |
| --- | --- | --- |
| calc_weekly_avg.xml | Tính trung bình tuần → tạo HTML → tải lên GitHub | Hằng tuần |

🖥️ Nhiệm vụ quản lý máy chủ
| Tệp XML | Chức năng | Lịch chạy |
| --- | --- | --- |
| DBbackup.xml | Sao lưu SQL Server | Định kỳ |
| DBbackupSync.xml | Tải bản sao lưu lên GitHub | Sau khi sao lưu |
| reboot.xml | Khởi động lại hệ thống | Định kỳ |

🔧 Nhiệm vụ khác
| Tệp XML | Chức năng | Lịch chạy |
| --- | --- | --- |
| historical_index_for_claude.xml | Tạo chỉ số lịch sử cho Claude | Định kỳ |
| OneDriveToGithub.xml | Lấy dữ liệu lúc 14:00 → tải lên lúc 15:00 | Hằng ngày |
| auto_check_weather_update_daily.xml | Kiểm tra cập nhật HTML → chạy lại nếu cần | Mỗi 4 giờ |

🔎 Từ khóa SEO
Chỉ số khó chịu (DI)

WBGT

Thời tiết toàn cầu

Thời tiết Nhật Bản

Độ ẩm / Nhiệt độ

OpenWeatherMap API

Trực quan hóa thời tiết

Tự động hóa GitHub Pages

Tự động hóa PowerShell

Cơ sở dữ liệu thời tiết SQL Server

📁 Tập lệnh SQL (Data-Extraction-SQL)
daily_data_en.sql
daily_data_jp.sql
wbgt_en.sql
wbgt_jp.sql
discomfort_index_en.sql
discomfort_index_jp.sql
city_list_en.sql
city_list_jp.sql
weathercode_en.sql
weathercode_jp.sql
weathercode_list_en.sql
weathercode_list_jp.sql

☀️ WBGT — tính trực tiếp bằng SQL
WBGT có thể tính chỉ bằng nhiệt độ và độ ẩm, không cần API bên ngoài.

Công thức:WBGT = 0.7T + 0.3(T × H / 100)

Độ chính xác ±1–2°C, phù hợp để đánh giá nguy cơ nắng nóng.

😓 Chỉ số khó chịu (DI)
discomfort_index_en.sql

discomfort_index_jp.sql

Tính DI dựa trên nhiệt độ và độ ẩm,
xuất mức độ thoải mái theo tiêu chuẩn tiếng Anh và tiếng Nhật.

🌤 Dữ liệu hằng ngày
daily_data_en.sql

daily_data_jp.sql

🏙 Danh sách thành phố
city_list_en.sql

city_list_jp.sql

🌦 Mã thời tiết
weathercode_en.sql

weathercode_jp.sql

weathercode_list_en.sql

weathercode_list_jp.sql
