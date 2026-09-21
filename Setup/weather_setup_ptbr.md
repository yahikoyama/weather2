# 🧱 Guia de Instalação do weather2

## 📘 Visão Geral

### Estrutura de Diretórios (Local)

```
c:\weather
├─config                 # Arquivos de configuração (DB, API, GitHub) e dicionários
├─Data                   # cities.csv (não utilizado se você restaurar o backup do banco)
├─Data-Extraction-SQL    # Ferramenta de extração de dados
├─DBBackup               # Arquivo de backup do SQL Server
├─Logs                   # Não utilizado
├─output                 # index.html, jp_result.txt (gerado às 14:00 JST)
├─Script                 # Scripts PowerShell, arquivos BAT e scripts Python
├─Setup                  # Instruções de instalação e preparação do ambiente
└─TaskScheduler          # Definições XML do Agendador de Tarefas do Windows
```

```
c:\winserverroot\OneDrive
├─Historical        # Dados históricos JP
├─Historical_en     # Dados históricos EN
```

Os arquivos em `c:\winserverroot\OneDrive` são enviados ao GitHub.  
Este caminho pode ser alterado nos arquivos `ps1` e `.bat` em `c:\weather\Script`.

---

## 🛠 Preparação

### 🔑 Obter a OpenWeather API Key  
https://openweathermap.org/api  
Usada em `c:\weather\config\dbconfig.json`.

### 🔑 Obter o GitHub Token  
Usado em `c:\weather\config\sync.json`.

### 📥 Baixar arquivos do GitHub  
Coloque os arquivos nos seguintes caminhos:

```
c:\weather\

c:\winserverroot\OneDrive
```

---

## 🚀 Etapas de Instalação

### 1) Instalar SQL Server 2022 Express

Download:  
https://www.microsoft.com/ja-jp/download/details.aspx?id=104781

SETUP.EXE  
- Executar como Administrador  
- Instalação autônoma do SQL Server  
- Aceitar os termos → Próximo  
- NÃO marcar “Usar Microsoft Update para verificar atualizações”  
- Próximo → Próximo  
- Desmarcar “SQL Server Azure extension” → Próximo  
- Manter recursos padrão → Próximo  
- Selecionar “Default instance” → Próximo  
- Manter contas de serviço padrão → Próximo  
- Selecionar Mixed Mode  
  Senha: `test@123`  
  (Anote a senha)

A senha será usada em:

```
c:\weather\config\dbconfig.json
```

---

### 2) Instalar SQL Server Management Studio (SSMS)

https://learn.microsoft.com/ja-jp/ssms/install/install

vs_SSMS.exe  
- Executar como Administrador  
- Continuar  
- Não selecionar workloads → Instalar

Após abrir o SSMS:  
Ignore a adição de conta por enquanto.

Configurações de conexão:  
- Nome do servidor: `(local)`  
- Autenticação: SQL Server Authentication  
- Usuário: `sa`  
- Senha: `test@123`  
- Marcar “Remember password”  
- Banco de dados: <Default>  
- Criptografia: opcional

Se o Object Explorer aparecer, está tudo correto.

---

### 3) Restaurar o Banco de Dados

Object Explorer →  
Clique com botão direito em **Databases** → **Restore Database**

- Selecionar “Device” → clicar em “…”  
- Escolher o arquivo:  
  `C:\Weather\DBBackup\weather\2026mmdd.bak`  
- OK → OK

Se aparecer **“Database 'weather' restored successfully”**, está concluído.

---

### 4) Editar `c:\weather\config\dbconfig.json`

Abra no Notepad.

Modifique:  
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

Notas:  
- Use `(local)` ou o IP do servidor  
- Cole sua própria OpenWeather API Key  
- O nome do banco deve ser o mesmo restaurado  
- Usuário é `sa`

---

### 5) Teste manual de obtenção de dados

Prompt de comando:

```
cd c:\weather\script
WeatherLogger.bat
```

Se o retorno **1** aparecer repetidamente, os dados estão sendo inseridos no banco.

Verifique também:

```
c:\weather\logs\
```

Consulta SQL:

```sql
SELECT *
  FROM [weather].[dbo].[WeatherLog]
  ORDER BY 1 DESC;
```

Se houver dados recentes, está funcionando.

---

### 6) Adicionar tarefa no Windows (coleta automática)

Agendador de Tarefas → Criar nova tarefa  
Nome: **get-temp-data**

**General**  
- Executar independentemente do login do usuário  
- Executar com privilégios máximos

**Triggers**  
Diariamente às:

```
0:00 4:00 8:00 12:00 14:00 16:00 20:00
```

**Actions**  
Programa:

```
C:\weather\Script\WeatherLogger.bat
```

Iniciar em:

```
C:\weather\Script
```

**Settings**  
Desmarcar “Stop the task if it runs longer than…”

Após registrar, clique “Enable All Tasks History”.  
“History (disabled)” → “History”.

---

### 7) Instalar Python (para visualizar dados)

python‑3.14.6‑amd64.exe  
- Executar como Administrador  
- Marcar “Use admin privileges when installing py.exe”  
- Marcar “Add python.exe to PATH”  
- Clicar **Install Now**

---

### 8) Instalar driver ODBC do Python (pyodbc)

PowerShell:

```
pip install pyodbc
```

Saída esperada:

```
Downloading pyodbc-5.3.0...
Installing collected packages: pyodbc
Successfully installed pyodbc-5.3.0
```

---

### 9) Visualizar dados coletados

Prompt de comando:

```
c:\weather\Script\weather\viewer.py
```

---

### 10) Backup automático do banco

Crie uma tarefa DBbackup semelhante à etapa 6

Ou importe:

```
c:\weather\TaskScheduler\DBbackup.xml
```

---

### 11) Exportar arquivo de texto

Prompt de comando:

```
c:\weather\Script\export_jp.py
```

Saída:

```
c:\weather\output\jp_result.txt
```

O arquivo `jp_result.txt` será gerado na pasta `output`.

