# ARCHITECTURE.md

## Project

Weekly Comfortable Region Ranking

Website:
https://yahikoyama.github.io/weather2/

Repository:
https://github.com/yahikoyama/weather2

---

## Purpose

Generate and publish weekly rankings of comfortable cities around the world.

---

## Workflow

### 1. Generate image

weekly_top10_worldmap.py

Creates:

C:\weather\output\top10_worldmap.png

and

weather2\Historical_en\weekly_comfortable_YYYY-MM-DD_YYYY-MM-DD_top10.png

---

### 2. Publish to GitHub

Publish-Top10WorldMap.ps1

Copies:

C:\weather\output\top10_worldmap.png

to

weather2\images\top10_worldmap.png

Then runs:

git pull
git add
git commit
git push

---

### 3. Historical archive

Historical_en/

Stores all weekly ranking images.

Do not delete archive files automatically.

---

## Important Paths

Latest image:

C:\weather\output\top10_worldmap.png

Repository image:

weather2\images\top10_worldmap.png

Archive:

weather2\Historical_en

---

## Important Rule

Before changing code:

1. Check Python scripts.
2. Check PowerShell scripts.
3. Check file paths.
4. Check GitHub Pages references.

Many issues are caused by path mismatches.
