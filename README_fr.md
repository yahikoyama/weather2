# Weather Report (GitHub Pages)
https://yahikoyama.github.io/weather2/

Ce projet est conçu pour étudier
**les systèmes de bases de données (SQL) et la programmation**
à partir de données météorologiques mondiales.

Le système récupère la température, l’humidité et les conditions météorologiques
via l’API OpenWeatherMap, puis calcule automatiquement
**l’indice d’inconfort (Discomfort Index : DI)**.
Il permet d’identifier les régions les plus fraîches du monde
et contribue à fournir des informations utiles pour lutter contre le réchauffement climatique.

Si vous souhaitez ajouter de nouvelles villes,
veuillez insérer des enregistrements dans la table **CityMaster**.

---

## ■ Aperçu du système

Ce système utilise une architecture Client/Serveur et fonctionne avec :

- Windows 11 Pro (Planificateur de tâches)
- PowerShell 5.1
- Microsoft SQL Server Express 2022 (taille maximale 10 Go)
- Python 3.14 (avec le pilote ODBC pyodbc)

Le fichier **weather.zip** contient :
- l’ensemble du code source  
- la sauvegarde de la base de données  

Veuillez configurer le fichier **conf** selon votre environnement
et importer le fichier **XML du planificateur de tâches**.

---

## ■ Rapport mis à jour quotidiennement (toutes les 4 heures)
https://yahikoyama.github.io/weather2/weather_report_now.html

---

## ■ Liste des rapports historiques (Historical)
https://yahikoyama.github.io/weather2/Historical/

---

## ■ Contact
yahikoyama.777@gmail.com
