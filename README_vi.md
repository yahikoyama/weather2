\# Báo cáo Thời tiết (GitHub Pages)

https://yahikoyama.github.io/weather2/



Dự án này sử dụng dữ liệu thời tiết trên toàn thế giới  

để \*\*học SQL và lập trình thông qua hệ thống thực tế\*\*.



Dựa trên dữ liệu nhiệt độ, độ ẩm và tình trạng thời tiết  

được lấy từ OpenWeatherMap API, hệ thống sẽ  

\*\*tự động tính toán Chỉ số Khó chịu (Discomfort Index: DI)\*\*  

và trực quan hóa khu vực nào trên thế giới đang mát mẻ.  

Thông tin này cũng hữu ích cho việc nghiên cứu và đối phó với biến đổi khí hậu.



Nếu bạn muốn thêm thành phố mới, hãy thêm bản ghi vào bảng \*\*CityMaster\*\*.



\---



\## ■ Tổng quan hệ thống



Hệ thống được xây dựng theo mô hình Client/Server.



\- Windows 11 Pro (sử dụng Task Scheduler)

\- PowerShell 5.1

\- Microsoft SQL Server Express 2022 (tối đa 10GB)

\- Python 3.14 (sử dụng trình điều khiển ODBC pyodbc)



\*\*weather.zip\*\* bao gồm:

\- Toàn bộ mã nguồn

\- Tệp sao lưu cơ sở dữ liệu



Hãy cấu hình các tệp \*\*conf\*\* phù hợp với môi trường của bạn  

và \*\*nhập tệp XML\*\* của Task Scheduler để tự động hóa.



\---



\## ■ Báo cáo cập nhật hàng ngày (cập nhật mỗi 4 giờ)

https://yahikoyama.github.io/weather2/weather\_report\_now.html



\---



\## ■ Danh sách báo cáo lịch sử (Historical)

https://yahikoyama.github.io/weather2/Historical/



\---



\## ■ Liên hệ

yahikoyama.777@gmail.com



