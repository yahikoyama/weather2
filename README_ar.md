# 🌍 مؤشر الانزعاج العالمي (يتم التحديث كل 4 ساعات)

## 👉 **تقرير الطقس العالمي متعدد اللغات — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_en.html">
<img width="509" height="358" alt="image" src="https://github.com/user-attachments/assets/251437ea-a99f-455b-becd-485a7c1666ae" />

</a>

---

# 🌦️ تقرير الطقس اليومي (تحديث تلقائي)

| اللغة | الرابط | معدل التحديث |
|------|--------|---------------|
| 🇯🇵 اليابانية | https://yahikoyama.github.io/weather2/weather_report_now.html | كل 4 ساعات |
| 🇬🇧 الإنجليزية | https://yahikoyama.github.io/weather2/weather_report_now_en.html | كل 4 ساعات (JST) |
| 🇷🇺 الروسية | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | كل 4 ساعات (JST) |
| 🇨🇳 الصينية (مبسطة) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | كل 4 ساعات (JST) |
| 🇰🇷 الكورية | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | كل 4 ساعات (JST) |
| 🇻🇳 الفيتنامية | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | كل 4 ساعات (JST) |
| 🇦🇪 العربية | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | كل 4 ساعات (JST) |
| 🇧🇷 البرتغالية (البرازيل) | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | كل 4 ساعات (JST) |

---

# 📜 تقارير الطقس التاريخية

أرشيف بيانات الطقس اليومية ومؤشر الانزعاج (DI):

- 🇬🇧 الإنجليزية  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 اليابانية  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 الفهرس اليومي  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html

---

يقوم هذا المشروع بعرض مؤشر الانزعاج العالمي كل 4 ساعات.  
يمكنك معرفة المدن الحارة أو الباردة أو الرطبة أو المريحة.

---

# 📌 نظرة عامة

يستخدم المشروع بيانات **OpenWeatherMap API** في الوقت الفعلي،  
ويحسب **مؤشر الانزعاج (DI)** بناءً على **درجة الحرارة والرطوبة وحالة الطقس**.

- ⏱ **تحديث تلقائي كل 4 ساعات**  
- 🌐 **يدعم 8 لغات**  
- 📊 **أرشيف بيانات تاريخية**  
- ⚙️ **أتمتة كاملة باستخدام PowerShell + SQL Server + Python + GitHub Pages**

الاستخدامات:
- مراقبة الطقس  
- تقييم مخاطر الحرارة  
- مراقبة البيئة  
- تعلم الأتمتة (PowerShell / SQL / Python)

---

# 📘 وصف المشروع

يقوم المشروع بجمع بيانات الطقس العالمية تلقائيًا (درجة الحرارة، الرطوبة، حالة الطقس)،  
ويحسب **DI** وينشر تقارير HTML متعددة اللغات على **GitHub Pages**.

مناسب للتعلم:
- قواعد بيانات SQL  
- أتمتة PowerShell  
- معالجة البيانات باستخدام Python  
- إنشاء HTML متعدد اللغات  
- النشر عبر GitHub Pages

لإضافة مدينة جديدة، قم بإدراج سجل في جدول **CityMaster**.

---

# 🏗️ بنية النظام

### التقنيات المستخدمة
- Windows 11 Pro (أتمتة عبر Task Scheduler)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (حتى 10GB)
- Python 3.14 + pyodbc (برنامج تشغيل ODBC)

---

## 📦 محتويات مستودع GitHub

جميع الملفات التي كانت موجودة سابقًا في **weather.zip**  
متاحة الآن داخل المستودع على شكل مجلدات.

تشمل:

- كامل الشيفرة المصدرية  
- نصوص SQL ونسخ احتياطية لقاعدة البيانات  
- قوالب الإعداد (config.ps1، sql1.ps1، إلخ)  
- نصوص الأتمتة (BAT / PowerShell)  
- ملفات XML لـ Task Scheduler للتنفيذ التلقائي

قم بتعديل ملفات الإعداد حسب بيئتك،  
واستورد ملفات XML إذا كنت ترغب في الأتمتة.

📩 البريد الإلكتروني: **yahikoyama.777@gmail.com**

---

# 🌐 اللغات المتاحة

[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

---

# 🚀 البدء السريع

### 1. استنساخ المستودع

```bash
git clone https://github.com/yahikoyama/weather2

weather2/
├── Historical/                # أرشيف ياباني
├── Historical_en/             # أرشيف إنجليزي
├── SRC_DB_SETTING/            # نسخ احتياطي وإعدادات قاعدة البيانات
├── DBBackup/                  # النسخ الاحتياطي اليومي لـ SQL Server
├── weather_report_now.html    # تقرير ياباني
├── weather_report_now_en.html # تقرير إنجليزي
├── weather_report_now_ko.html # تقرير كوري
├── weather_report_now_ru.html # تقرير روسي
├── weather_report_now_zh.html # تقرير صيني
├── weather_report_now_vi.html # تقرير فيتنامي
├── weather_report_now_ar.html # تقرير عربي
├── weather_report_now_ptbr.html # تقرير برتغالي (البرازيل)


🌐 مهام إنشاء تقارير الطقس متعددة اللغات
| ملف XML | الوظيفة | الجدول |
| --- | --- | --- |
| get-temp-data.xml | جلب بيانات API → إدراجها في SQL Server | حسب المشغل |
| make-txt-file.xml | إنشاء بيانات نصية | كل 4 ساعات |
| export_jp_latest_sync_html.xml | إنشاء HTML متعدد اللغات → رفعه إلى GitHub | كل 4 ساعات |


| Historicaldata_daily.xml | إنشاء بيانات يومية | يوميًا الساعة 14:00 JST |

📜 مهام إنشاء البيانات التاريخية
| ملف XML | الوظيفة | الجدول |
| --- | --- | --- |
| calc_weekly_avg.xml | حساب متوسط الأسبوع → إنشاء HTML → رفعه إلى GitHub | أسبوعيًا |

🖥️ مهام إدارة الخادم
| ملف XML | الوظيفة | الجدول |
| --- | --- | --- |
| DBbackup.xml | نسخ احتياطي لـ SQL Server | دوري |
| DBbackupSync.xml | رفع النسخ الاحتياطية إلى GitHub | بعد النسخ الاحتياطي |
| reboot.xml | إعادة تشغيل النظام | دوري |

🔧 مهام أخرى
| ملف XML | الوظيفة | الجدول |
| --- | --- | --- |
| historical_index_for_claude.xml | إنشاء فهرس تاريخي لـ Claude | دوري |
| OneDriveToGithub.xml | جلب البيانات الساعة 14:00 → رفعها الساعة 15:00 | يوميًا |
| auto_check_weather_update_daily.xml | التحقق من تحديث HTML → إعادة التشغيل عند الحاجة | كل 4 ساعات |

🔎 كلمات مفتاحية SEO
مؤشر الانزعاج (DI)

WBGT

الطقس العالمي

طقس اليابان

الرطوبة / درجة الحرارة

OpenWeatherMap API

عرض بيانات الطقس

أتمتة GitHub Pages

أتمتة PowerShell

قاعدة بيانات الطقس SQL Server

📁 نصوص SQL (Data-Extraction-SQL)

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


☀️ WBGT — حساب مباشر عبر SQL
يمكن حساب WBGT باستخدام درجة الحرارة والرطوبة فقط، دون الحاجة إلى API خارجي.

الصيغة:

WBGT = 0.7T + 0.3(T × H / 100)


2°C — مناسبة لتقييم مخاطر الحرارة.

😓 مؤشر الانزعاج (DI)
discomfort_index_en.sql

discomfort_index_jp.sql

يحسب DI بناءً على درجة الحرارة والرطوبة،
ويعرض مستويات الراحة وفقًا للمعايير اليابانية والإنجليزية.

🌤 بيانات يومية
daily_data_en.sql

daily_data_jp.sql

🏙 قائمة المدن
city_list_en.sql

city_list_jp.sql

🌦 رموز الطقس
weathercode_en.sql

weathercode_jp.sql

weathercode_list_en.sql

weathercode_list_jp.sql
