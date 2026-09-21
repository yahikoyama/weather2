# 🧱 دليل تثبيت weather2

## 📘 نظرة عامة

### هيكل المجلدات (محلي)

```
c:\weather
├─config                 # ملفات الإعداد (قاعدة البيانات، API، GitHub) والقواميس
├─Data                   # cities.csv (غير مستخدم عند استعادة نسخة قاعدة البيانات)
├─Data-Extraction-SQL    # أداة استخراج البيانات
├─DBBackup               # ملف النسخة الاحتياطية لـ SQL Server
├─Logs                   # غير مستخدم
├─output                 # index.html، jp_result.txt (يتم إنشاؤه الساعة 14:00 بتوقيت اليابان)
├─Script                 # سكربتات PowerShell، ملفات BAT، سكربتات Python
├─Setup                  # تعليمات التثبيت وإعداد البيئة
└─TaskScheduler          # تعريفات XML لجدولة مهام Windows
```

```
c:\winserverroot\OneDrive
├─Historical        # بيانات تاريخية (اليابانية)
├─Historical_en     # بيانات تاريخية (الإنجليزية)
```

يتم رفع الملفات الموجودة في `c:\winserverroot\OneDrive` إلى GitHub.  
يمكن تغيير هذا المسار داخل ملفات `ps1` و `.bat` في `c:\weather\Script`.

---

## 🛠 التحضير

### 🔑 الحصول على مفتاح OpenWeather API  
https://openweathermap.org/api  
يُستخدم في `c:\weather\config\dbconfig.json`.

### 🔑 الحصول على GitHub Token  
يُستخدم في `c:\weather\config\sync.json`.

### 📥 تنزيل الملفات من GitHub  
ضع الملفات في المسارات التالية:

```
c:\weather\

c:\winserverroot\OneDrive
```

---

## 🚀 خطوات التثبيت

### 1) تثبيت SQL Server 2022 Express

رابط التنزيل:  
https://www.microsoft.com/ja-jp/download/details.aspx?id=104781

SETUP.EXE  
- تشغيل كمسؤول  
- تنفيذ تثبيت مستقل جديد لـ SQL Server  
- قبول شروط الترخيص → التالي  
- عدم تحديد خيار “استخدام Microsoft Update للتحقق من التحديثات”  
- التالي → التالي  
- إلغاء تحديد “SQL Server Azure extension” → التالي  
- ترك إعدادات الميزات كما هي → التالي  
- اختيار “Default instance” → التالي  
- ترك حسابات الخدمات كما هي → التالي  
- اختيار وضع Mixed Mode  
  كلمة المرور: `test@123`  
  (يجب حفظ كلمة المرور)

تُستخدم كلمة المرور في:

```
c:\weather\config\dbconfig.json
```

---

### 2) تثبيت SQL Server Management Studio (SSMS)

https://learn.microsoft.com/ja-jp/ssms/install/install

vs_SSMS.exe  
- تشغيل كمسؤول  
- متابعة  
- عدم اختيار أي Workload → تثبيت

بعد تشغيل SSMS:  
تخطي إضافة الحساب في البداية.

إعدادات الاتصال:  
- اسم الخادم: `(local)`  
- المصادقة: SQL Server Authentication  
- اسم المستخدم: `sa`  
- كلمة المرور: `test@123`  
- تحديد خيار “تذكر كلمة المرور”  
- قاعدة البيانات: <افتراضي>  
- التشفير: اختياري

إذا ظهر Object Explorer فهذا يعني أن التثبيت ناجح.

---

### 3) استعادة قاعدة البيانات

Object Explorer →  
انقر بزر الماوس الأيمن على **Databases** → **Restore Database**

- اختيار “Device” → الضغط على “…”  
- اختيار الملف:  
  `C:\Weather\DBBackup\weather\2026mmdd.bak`  
- الضغط OK → OK

إذا ظهرت الرسالة **"Database 'weather' restored successfully"** فهذا يعني أن العملية تمت بنجاح.

---

### 4) تعديل `c:\weather\config\dbconfig.json`

افتح الملف باستخدام Notepad.

قم بتعديل الحقول التالية:  
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

ملاحظات:  
- استخدم `(local)` أو عنوان IP للخادم  
- ضع مفتاح OpenWeather API الخاص بك  
- يجب أن يتطابق اسم قاعدة البيانات مع قاعدة البيانات المستعادة  
- المستخدم هو `sa`

---

### 5) اختبار جلب البيانات يدويًا

Command Prompt:

```
cd c:\weather\script
WeatherLogger.bat
```

إذا ظهر الرقم **1** بشكل متكرر فهذا يعني أن البيانات تُسجّل في قاعدة البيانات.

تحقق أيضًا من:

```
c:\weather\logs\
```

استعلام SQL:

```sql
SELECT *
  FROM [weather].[dbo].[WeatherLog]
  ORDER BY 1 DESC;
```

إذا ظهرت بيانات حديثة فهذا يعني أن النظام يعمل بشكل صحيح.

---

### 6) إضافة مهمة Windows (لجلب البيانات تلقائيًا)

Task Scheduler → إنشاء مهمة جديدة  
الاسم: **get-temp-data**

**General**  
- التشغيل سواء كان المستخدم مسجّل الدخول أم لا  
- التشغيل بأعلى صلاحيات

**Triggers**  
يوميًا في:

```
0:00 4:00 8:00 12:00 14:00 16:00 20:00
```

**Actions**  
البرنامج:

```
C:\weather\Script\WeatherLogger.bat
```

Start in:

```
C:\weather\Script
```

**Settings**  
إلغاء تحديد “إيقاف المهمة إذا استغرقت وقتًا طويلًا”

بعد التسجيل، اضغط “Enable All Tasks History”.  
سيتحول “History (disabled)” إلى “History”.

---

### 7) تثبيت Python (لعرض البيانات)

python‑3.14.6‑amd64.exe  
- تشغيل كمسؤول  
- تحديد “Use admin privileges when installing py.exe”  
- تحديد “Add python.exe to PATH”  
- الضغط على **Install Now**

---

### 8) تثبيت برنامج تشغيل Python ODBC (pyodbc)

PowerShell:

```
pip install pyodbc
```

المخرجات المتوقعة:

```
Downloading pyodbc-5.3.0...
Installing collected packages: pyodbc
Successfully installed pyodbc-5.3.0
```

---

### 9) عرض البيانات المسترجعة

Command Prompt:

```
c:\weather\Script\weather\viewer.py
```

---

### 10) النسخ الاحتياطي التلقائي لقاعدة البيانات

إنشاء مهمة DBbackup مشابهة للخطوة 6

أو استيراد:

```
c:\weather\TaskScheduler\DBbackup.xml
```

---

### 11) إخراج ملف نصي

Command Prompt:

```
c:\weather\Script\export_jp.py
```

المخرجات:

```
c:\weather\output\jp_result.txt
```

سيتم إنشاء الملف `jp_result.txt` داخل مجلد `output`.

