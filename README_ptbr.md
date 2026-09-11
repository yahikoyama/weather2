# 🌍 Índice Global de Desconforto (atualizado a cada 4 horas)

## 👉 **Relatório climático global multilíngue — EN / JP / RU / ZH / KO / VI / AR / PT‑BR**
### https://yahikoyama.github.io/weather2/

<a href="https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html">
<img width="512" height="355" alt="image" src="https://github.com/user-attachments/assets/5932b5b8-e5b5-4cee-8f66-c68e56b2034f" />

</a>

---

# 🌦️ Relatórios diários do clima (atualização automática)

| Idioma | URL | Frequência |
|--------|-----|------------|
| 🇯🇵 Japonês | https://yahikoyama.github.io/weather2/weather_report_now.html | A cada 4 horas |
| 🇬🇧 Inglês | https://yahikoyama.github.io/weather2/weather_report_now_en.html | A cada 4 horas (JST) |
| 🇷🇺 Russo | https://yahikoyama.github.io/weather2/weather_report_now_ru.html | A cada 4 horas (JST) |
| 🇨🇳 Chinês (Simplificado) | https://yahikoyama.github.io/weather2/weather_report_now_zh.html | A cada 4 horas (JST) |
| 🇰🇷 Coreano | https://yahikoyama.github.io/weather2/weather_report_now_ko.html | A cada 4 horas (JST) |
| 🇻🇳 Vietnamita | https://yahikoyama.github.io/weather2/weather_report_now_vi.html | A cada 4 horas (JST) |
| 🇦🇪 Árabe | https://yahikoyama.github.io/weather2/weather_report_now_ar.html | A cada 4 horas (JST) |
| 🇧🇷 Português (Brasil) | https://yahikoyama.github.io/weather2/weather_report_now_ptbr.html | A cada 4 horas (JST) |

---

# 📜 Relatórios históricos do clima

Arquivo de dados diários do clima e índice de desconforto (DI):

- 🇬🇧 Inglês  
  https://yahikoyama.github.io/weather2/Historical_en/

- 🇯🇵 Japonês  
  https://yahikoyama.github.io/weather2/Historical/

- 📅 Índice diário  
  https://yahikoyama.github.io/weather2/Historical/index_daily.html

---

Este projeto visualiza o índice global de desconforto a cada 4 horas.  
Você pode verificar quais cidades estão quentes, frias, úmidas ou confortáveis.

---

# 📌 Visão geral

O projeto utiliza dados em tempo real da **OpenWeatherMap API**,  
calculando o **Índice de Desconforto (DI)** com base em **temperatura, umidade e condições climáticas**.

- ⏱ **Atualização automática a cada 4 horas**  
- 🌐 **Suporte para 8 idiomas**  
- 📊 **Arquivo histórico disponível**  
- ⚙️ **Automação completa com PowerShell + SQL Server + Python + GitHub Pages**

Aplicações:
- Monitoramento climático  
- Avaliação de risco de calor  
- Observação ambiental  
- Estudo de automação (PowerShell / SQL / Python)

---

# 📘 Descrição do projeto

O projeto coleta automaticamente dados climáticos globais (temperatura, umidade, condições climáticas),  
calcula o **DI** e publica relatórios HTML multilíngues no **GitHub Pages**.

Também é útil para aprendizado:
- Banco de dados SQL  
- Automação com PowerShell  
- Processamento de dados com Python  
- Geração de HTML multilíngue  
- Publicação via GitHub Pages

Para adicionar novas cidades, insira registros na tabela **CityMaster**.

---

# 🏗️ Arquitetura do sistema

### Tecnologias utilizadas
- Windows 11 Pro (automação via Task Scheduler)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (até 10GB)
- Python 3.14 + pyodbc (driver ODBC)

---

## 📦 Conteúdo do repositório GitHub

Todos os arquivos que estavam anteriormente no **weather.zip**  
agora estão disponíveis no repositório em pastas organizadas.

Inclui:

- Código-fonte completo  
- Scripts SQL e backups do banco de dados  
- Modelos de configuração (config.ps1, sql1.ps1 etc.)  
- Scripts de automação (BAT / PowerShell)  
- XML do Task Scheduler para execução automática

Configure os arquivos conforme seu ambiente  
e importe os XMLs do Task Scheduler se desejar automação.

📩 Contato: **yahikoyama.777@gmail.com**

---

# 🌐 Idiomas disponíveis

[日本語](README_ja.md) | [中文](README_zh.md) | [Français](README_fr.md) | [한국어](README_ko.md) | [Русский](README_ru.md) | [Tiếng Việt](README_vi.md)

---

# 🚀 Início rápido

### 1. Clonar o repositório

weather2/
├── Historical/                # Arquivo japonês
├── Historical_en/             # Arquivo inglês
├── SRC_DB_SETTING/            # Backup e configuração do banco de dados
├── DBBackup/                  # Backup diário do SQL Server
├── weather_report_now.html    # Relatório japonês
├── weather_report_now_en.html # Relatório inglês
├── weather_report_now_ko.html # Relatório coreano
├── weather_report_now_ru.html # Relatório russo
├── weather_report_now_zh.html # Relatório chinês
├── weather_report_now_vi.html # Relatório vietnamita
├── weather_report_now_ar.html # Relatório árabe
├── weather_report_now_ptbr.html # Relatório português (Brasil)


🌐 Tarefas de geração de relatórios multilíngues
| Arquivo XML | Função | Agendamento |
| --- | --- | --- |
| get-temp-data.xml | Obter dados da API → inserir no SQL Server | Por gatilho |
| make-txt-file.xml | Gerar dados de texto | A cada 4 horas |
| export_jp_latest_sync_html.xml | Gerar HTML multilíngue → enviar ao GitHub | A cada 4 horas |
| Historicaldata_daily.xml | Gerar dados diários | Diariamente às 14:00 JST |

📜 Tarefas de geração de dados históricos
| Arquivo XML | Função | Agendamento |
| --- | --- | --- |
| calc_weekly_avg.xml | Calcular média semanal → gerar HTML → enviar ao GitHub | Semanalmente |


🖥️ Tarefas de administração do servidor
| Arquivo XML | Função | Agendamento |
| --- | --- | --- |
| DBbackup.xml | Backup do SQL Server | Regular |
| DBbackupSync.xml | Enviar backup ao GitHub | Após o backup |
| reboot.xml | Reiniciar o sistema | Regular |


🔧 Outras tarefas
| Arquivo XML | Função | Agendamento |
| --- | --- | --- |
| historical_index_for_claude.xml | Gerar índice histórico para Claude | Regular |
| OneDriveToGithub.xml | Obter dados às 14:00 → enviar às 15:00 | Diariamente |
| auto_check_weather_update_daily.xml | Verificar atualização do HTML → executar novamente se necessário | A cada 4 horas |

🔎 Palavras-chave SEO
Índice de desconforto (DI)

WBGT

Clima global

Clima do Japão

Umidade / Temperatura

OpenWeatherMap API

Visualização climática

Automação GitHub Pages

Automação PowerShell

Banco de dados climático SQL Server

📁 Scripts SQL (Data-Extraction-SQL)

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

☀️ WBGT — cálculo direto via SQL
O WBGT pode ser calculado apenas com temperatura e umidade, sem API externa.

Fórmula:WBGT = 0.7T + 0.3(T × H / 100)

Precisão de ±1–2°C — suficiente para avaliar risco térmico.

😓 Índice de desconforto (DI)
discomfort_index_en.sql

discomfort_index_jp.sql

Calcula o DI com base em temperatura e umidade,
e exibe níveis de conforto conforme padrões inglês e japonês.

🌤 Dados diários
daily_data_en.sql

daily_data_jp.sql

🏙 Lista de cidades
city_list_en.sql

city_list_jp.sql

🌦 Códigos climáticos
weathercode_en.sql

weathercode_jp.sql

weathercode_list_en.sql

weathercode_list_jp.sql




```bash
git clone https://github.com/yahikoyama/weather2
