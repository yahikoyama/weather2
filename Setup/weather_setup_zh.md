# 🧱 weather2 安装指南

## 📘 概述

### 本地目录结构

```
c:\weather
├─config                 # 配置文件（DB、API、GitHub）及字典
├─Data                   # cities.csv（如果恢复数据库备份则不使用）
├─Data-Extraction-SQL    # 数据提取工具
├─DBBackup               # SQL Server 数据库备份文件
├─Logs                   # 未使用
├─output                 # index.html, jp_result.txt（每天日本时间14:00生成）
├─Script                 # PowerShell 脚本、批处理文件、Python 脚本
├─Setup                  # 安装说明与环境准备
└─TaskScheduler          # Windows 任务计划 XML 定义
```

```
c:\winserverroot\OneDrive
├─Historical        # 日本历史数据（JP）
├─Historical_en     # 英文历史数据（EN）
```

`c:\winserverroot\OneDrive` 下的文件会上传到 GitHub。  
该路径可在 `c:\weather\Script\ps1` 和 `.bat` 文件中修改。

---

## 🛠 前期准备

### 🔑 获取 OpenWeather API Key  
https://openweathermap.org/api  
用于 `c:\weather\config\dbconfig.json`。

### 🔑 获取 GitHub Token  
用于 `c:\weather\config\sync.json`。

### 📥 从 GitHub 下载文件  
请将文件放置在以下路径：

```
c:\weather\

c:\winserverroot\OneDrive
```

---

## 🚀 安装步骤

### 1) 安装 SQL Server 2022 Express

下载：  
https://www.microsoft.com/ja-jp/download/details.aspx?id=104781

SETUP.EXE  
- 以管理员身份运行  
- 执行新的 SQL Server 独立安装  
- 接受许可条款 → 下一步  
- 不勾选 “使用 Microsoft Update 检查更新”  
- 下一步 → 下一步  
- 取消勾选 “SQL Server Azure 扩展功能” → 下一步  
- 保持默认实例功能 → 下一步  
- 选择 “默认实例（Default instance）” → 下一步  
- 服务账户保持默认 → 下一步  
- 选择混合模式（Mixed Mode）  
  密码：`test@123`  
  （请务必记录下来）

此密码用于：

```
c:\weather\config\dbconfig.json
```

---

### 2) 安装 SQL Server Management Studio (SSMS)

https://learn.microsoft.com/ja-jp/ssms/install/install

vs_SSMS.exe  
- 以管理员身份运行  
- 继续  
- 不选择任何工作负载 → 安装

启动 SSMS 后：  
暂时跳过添加账户。

连接设置：  
- 服务器名称：`(local)`  
- 认证方式：SQL Server Authentication  
- 用户名：`sa`  
- 密码：`test@123`  
- 勾选 “记住密码”  
- 数据库：<默认>  
- 加密：可选

如果能看到 Object Explorer，则安装成功。

---

### 3) 恢复数据库

Object Explorer →  
右键 **Databases** → **Restore Database**

- 选择 “Device” → 点击 “…”  
- 选择文件：  
  `C:\Weather\DBBackup\weather\2026mmdd.bak`  
- 点击 OK → OK

若出现 **“Database 'weather' restored successfully”**，则恢复完成。

---

### 4) 编辑 `c:\weather\config\dbconfig.json`

使用记事本打开。

修改以下字段：  
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

说明：  
- 使用 `(local)` 或服务器 IP 地址  
- 填入你自己的 OpenWeather API Key  
- 数据库名称必须与恢复的数据库一致  
- 用户为 `sa`

---

### 5) 手动测试数据获取

命令提示符：

```
cd c:\weather\script
WeatherLogger.bat
```

如果返回值 **1** 持续出现，说明数据正在写入数据库。

检查：

```
c:\weather\logs\
```

SQL 查询：

```sql
SELECT *
  FROM [weather].[dbo].[WeatherLog]
  ORDER BY 1 DESC;
```

若能看到最新数据，则运行正常。

---

### 6) 添加 Windows 任务（自动获取数据）

任务计划程序 → 创建新任务  
名称：**get-temp-data**

**常规（General）**  
- 无论用户是否登录都运行  
- 以最高权限运行

**触发器（Triggers）**  
每天：

```
0:00 4:00 8:00 12:00 14:00 16:00 20:00
```

**操作（Actions）**  
程序：

```
C:\weather\Script\WeatherLogger.bat
```

起始位置：

```
C:\weather\Script
```

**设置（Settings）**  
取消勾选 “若任务运行时间过长则停止任务”

注册后点击 “启用所有任务历史记录”  
“历史记录（已禁用）” 将变为 “历史记录”。

---

### 7) 安装 Python（用于查看数据）

python‑3.14.6‑amd64.exe  
- 以管理员身份运行  
- 勾选 “Use admin privileges when installing py.exe”  
- 勾选 “Add python.exe to PATH”  
- 点击 **Install Now**

---

### 8) 安装 Python ODBC 驱动（pyodbc）

PowerShell：

```
pip install pyodbc
```

预期输出：

```
Downloading pyodbc-5.3.0...
Installing collected packages: pyodbc
Successfully installed pyodbc-5.3.0
```

---

### 9) 查看已获取的数据

命令提示符：

```
c:\weather\Script\weather\viewer.py
```

---

### 10) 自动执行数据库备份

按照步骤 6 创建 DBbackup 任务

或导入：

```
c:\weather\TaskScheduler\DBbackup.xml
```

---

### 11) 输出文本文件

命令提示符：

```
c:\weather\Script\export_jp.py
```

输出：

```
c:\weather\output\jp_result.txt
```

文件 `jp_result.txt` 将生成在 `output` 文件夹中。

