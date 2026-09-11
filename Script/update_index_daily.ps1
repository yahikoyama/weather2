# ============================================
# index_daily.html を更新（historical_YYYYMMDD.html の差分追加＋最新順ソート）
# ============================================

$baseFolder = "C:\Users\winserverroot\OneDrive\Historical\html"
$indexDailyPath = Join-Path $baseFolder "index_daily.html"

# index_daily.html 読み込み
$indexText = Get-Content $indexDailyPath -Raw

# index_daily の <li> 抽出
$indexLi = Select-String -InputObject $indexText -Pattern "<li>.*?</li>" -AllMatches |
           ForEach-Object { $_.Matches.Value }

# index_daily の日付抽出
$indexDates = @{}
foreach ($li in $indexLi) {
    if ($li -match "<a .*?>(\d{8})</a>") {
        $indexDates[$matches[1]] = $li
    }
}

# ============================================
# historical_YYYYMMDD.html のファイル一覧を取得
# ============================================

$historicalFiles = Get-ChildItem -Path $baseFolder -Filter "historical_*.html"

$sourceDates = @{}
foreach ($file in $historicalFiles) {
    if ($file.Name -match "historical_(\d{8})\.html") {
        $date = $matches[1]
        $li = "  <li><a href='./$($file.Name)'>$date</a></li>"
        $sourceDates[$date] = $li
    }
}

# ============================================
# 差分抽出（index_daily に無い日付だけ追加）
# ============================================

$allDates = @{}

# 既存
foreach ($d in $indexDates.Keys) {
    $allDates[$d] = $indexDates[$d]
}

# 差分追加
foreach ($d in $sourceDates.Keys) {
    if (-not $allDates.ContainsKey($d)) {
        $allDates[$d] = $sourceDates[$d]
    }
}

# ============================================
# 最新順にソート
# ============================================

$sortedDates = $allDates.Keys | Sort-Object -Descending

# ============================================
# 新しい <ul> ブロックを作成
# ============================================

$newUlBlock = "<ul>`r`n"
foreach ($d in $sortedDates) {
    $newUlBlock += $allDates[$d] + "`r`n"
}
$newUlBlock += "</ul>"

# ============================================
# index_daily.html を再構築
# ============================================

$ulStartPos = $indexText.IndexOf("<ul>")
$ulEndPos   = $indexText.IndexOf("</ul>")

$newIndexText = $indexText.Substring(0, $ulStartPos) +
                $newUlBlock +
                $indexText.Substring($ulEndPos + 5)

# 保存
$newIndexText | Out-File -FilePath $indexDailyPath -Encoding UTF8

Write-Host "index_daily.html を最新順で更新しました。" -ForegroundColor Green
