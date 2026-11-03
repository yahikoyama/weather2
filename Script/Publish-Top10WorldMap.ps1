# ==========================================
# Publish-Top10WorldMap.ps1
# ==========================================

$RepoPath = "C:\Users\winserverroot\weather2"

cd $RepoPath

git pull origin main

git add images/top10_worldmap.png

git add Historical_en/*.png

git commit -m "Update weekly top10 world map"

git push origin main