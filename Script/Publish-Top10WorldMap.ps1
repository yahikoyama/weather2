# ==========================================
# Publish-Top10WorldMap.ps1
# ==========================================

$RepoPath = "C:\Users\winserverroot\weather2"

$SourceImage = "C:\weather\output\top10_worldmap.png"
$TargetImage = "$RepoPath\images\top10_worldmap.png"

# 最新画像存在確認
if (!(Test-Path $SourceImage))
{
    Write-Host "ERROR: $SourceImage not found."
    exit 1
}

# 最新画像をGitHubリポジトリへコピー
Copy-Item `
    $SourceImage `
    $TargetImage `
    -Force

# リポジトリへ移動
Set-Location $RepoPath

# 最新取得
git pull origin main

# 変更を追加
git add images/top10_worldmap.png
git add Historical_en/*.png

# コミット
git commit -m "Update weekly top10 world map"

# プッシュ
git push origin main

Write-Host "Completed."