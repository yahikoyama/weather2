# 🧱 Руководство по установке weather2

## 📘 Обзор

### Структура каталогов (локально)

```
c:\weather
├─config                 # Конфигурационные файлы (DB, API, GitHub) и словари
├─Data                   # cities.csv (не используется, если восстановить резервную копию БД)
├─Data-Extraction-SQL    # Инструмент извлечения данных
├─DBBackup               # Резервная копия SQL Server
├─Logs                   # Не используется
├─output                 # index.html, jp_result.txt (генерируется в 14:00 JST)
├─Script                 # PowerShell-скрипты, BAT-файлы и Python-скрипты
├─Setup                  # Инструкции по установке и подготовке окружения
└─TaskScheduler          # XML-файлы планировщика задач Windows
```

```
c:\winserverroot\OneDrive
├─Historical        # Исторические данные JP
├─Historical_en     # Исторические данные EN
```

Файлы из `c:\winserverroot\OneDrive` загружаются в GitHub.  
Этот путь можно изменить в `c:\weather\Script\ps1` и `.bat`.

---

## 🛠 Подготовка

### 🔑 Получение OpenWeather API Key  
https://openweathermap.org/api  
Используется в `c:\weather\config\dbconfig.json`.

### 🔑 Получение GitHub Token  
Используется в `c:\weather\config\sync.json`.

### 📥 Загрузка файлов из GitHub  
Разместите файлы по следующим путям:

```
c:\weather\

c:\winserverroot\OneDrive
```

---

## 🚀 Шаги установки

### 1) Установка SQL Server 2022 Express

Скачать:  
https://www.microsoft.com/ja-jp/download/details.aspx?id=104781

SETUP.EXE  
- Запустить от имени администратора  
- Новая автономная установка SQL Server  
- Принять условия лицензии → Далее  
- НЕ отмечать «Использовать Microsoft Update для проверки обновлений»  
- Далее → Далее  
- Снять галочку «SQL Server Azure extension» → Далее  
- Оставить параметры по умолчанию → Далее  
- Выбрать «Default instance» → Далее  
- Учетные записи служб → оставить как есть → Далее  
- Выбрать Mixed Mode  
  Пароль: `test@123`  
  (Обязательно запомните пароль)

Пароль требуется в:

```
c:\weather\config\dbconfig.json
```

---

### 2) Установка SQL Server Management Studio (SSMS)

https://learn.microsoft.com/ja-jp/ssms/install/install

vs_SSMS.exe  
- Запустить от имени администратора  
- Продолжить  
- Не выбирать рабочие нагрузки → Установить

После запуска SSMS:  
Пропустить добавление учетной записи.

Параметры подключения:  
- Сервер: `(local)`  
- Аутентификация: SQL Server Authentication  
- Пользователь: `sa`  
- Пароль: `test@123`  
- Отметить «Запомнить пароль»  
- База данных: <Default>  
- Шифрование: необязательно

Если отображается Object Explorer — установка завершена успешно.

---

### 3) Восстановление базы данных

Object Explorer →  
Правый клик **Databases** → **Restore Database**

- Выбрать «Device» → «…»  
- Указать файл:  
  `C:\Weather\DBBackup\weather\2026mmdd.bak`  
- OK → OK

Если появится сообщение **«Database 'weather' restored successfully»**, восстановление завершено.

---

### 4) Изменение `c:\weather\config\dbconfig.json`

Открыть в Блокноте.

Изменить поля:  
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

Примечания:  
- Используйте `(local)` или IP-адрес сервера  
- Вставьте свой OpenWeather API Key  
- Имя базы данных должно совпадать с восстановленной  
- Пользователь — `sa`

---

### 5) Проверка получения данных вручную

Командная строка:

```
cd c:\weather\script
WeatherLogger.bat
```

Если возвращаемое значение **1** повторяется — данные успешно записываются в БД.

Также проверьте:

```
c:\weather\logs\
```

SQL-проверка:

```sql
SELECT *
  FROM [weather].[dbo].[WeatherLog]
  ORDER BY 1 DESC;
```

Если отображаются свежие данные — всё работает.

---

### 6) Добавление задачи Windows (автоматический сбор данных)

Планировщик задач → Создать задачу  
Имя: **get-temp-data**

**General**  
- Выполнять независимо от входа пользователя  
- Выполнять с наивысшими привилегиями

**Triggers**  
Ежедневно в:  
```
0:00 4:00 8:00 12:00 14:00 16:00 20:00
```

**Actions**  
Программа:  
```
C:\weather\Script\WeatherLogger.bat
```

Начать в:  
```
C:\weather\Script
```

**Settings**  
Снять галочку «Останавливать задачу, если она работает дольше…»

После регистрации нажать «Enable All Tasks History».  
«History (disabled)» изменится на «History».

---

### 7) Установка Python (для просмотра данных)

python‑3.14.6‑amd64.exe  
- Запустить от имени администратора  
- Отметить «Use admin privileges when installing py.exe»  
- Отметить «Add python.exe to PATH»  
- Нажать **Install Now**

---

### 8) Установка Python ODBC Driver (pyodbc)

PowerShell:

```
pip install pyodbc
```

Ожидаемый вывод:

```
Downloading pyodbc-5.3.0...
Installing collected packages: pyodbc
Successfully installed pyodbc-5.3.0
```

---

### 9) Просмотр полученных данных

Командная строка:

```
c:\weather\Script\weather\viewer.py
```

---

### 10) Автоматическое резервное копирование БД

Создать задачу DBbackup аналогично шагу 6.

Или импортировать:

```
c:\weather\TaskScheduler\DBbackup.xml
```

---

### 11) Экспорт текстового файла

Командная строка:

```
c:\weather\Script\export_jp.py
```

Вывод:

```
c:\weather\output\jp_result.txt
```

Файл `jp_result.txt` будет создан в каталоге `output`.

