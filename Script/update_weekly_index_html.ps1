# ============================================
# Historical/html/index.html に最新週のリンクを追加（最新が一番上）
# ============================================

$baseFolder = "C:\Users\winserverroot\OneDrive\Historical\html"
$indexPath  = Join-Path $baseFolder "index.html"

# ============================================
# weekly_yyyyMMdd_yyyyMMdd.html を取得
# ============================================

$weeklyFiles = Get-ChildItem -Path $baseFolder -Filter "weekly_*.html"

if ($weeklyFiles.Count -eq 0) {
    Write-Host "No weekly HTML files found in $baseFolder"
    exit
}

# ファイル名から日付抽出
$weeklyList = foreach ($f in $weeklyFiles) {
    if ($f.BaseName -match "weekly_(\d{8})_(\d{8})") {
        [PSCustomObject]@{
            FileName = $f.Name
            FromDate = [datetime]::ParseExact($matches[1], "yyyyMMdd", $null)
            ToDate   = [datetime]::ParseExact($matches[2], "yyyyMMdd", $null)
        }
    }
}

# ============================================
# index.html を読み込み
# ============================================

$indexText = Get-Content $indexPath -Raw

# <ul> と </ul> の位置をタグで検索（行番号ではなく文字位置）
$ulStartPos = $indexText.IndexOf("<ul>")
$ulEndPos   = $indexText.IndexOf("</ul>")

if ($ulStartPos -lt 0 -or $ulEndPos -lt 0) {
    Write-Host "ERROR: <ul> or </ul> not found. index.html is broken."
    exit
}

# <ul> 内のテキストを抽出
$ulContent = $indexText.Substring($ulStartPos, $ulEndPos - $ulStartPos)

# 既存の <li> を抽出
$existingLi = Select-String -InputObject $ulContent -Pattern "<li>.*?</li>" -AllMatches |
              ForEach-Object { $_.Matches.Value }

# ============================================
# 既存の <li> をパースして日付抽出（FileName ベース）
# ============================================

$parsedLi = foreach ($line in $existingLi) {
    if ($line -match "weekly_(\d{8})_(\d{8})\.html") {
        [PSCustomObject]@{
            Line     = $line
            FileName = "weekly_$($matches[1])_$($matches[2]).html"
            FromDate = [datetime]::ParseExact($matches[1], "yyyyMMdd", $null)
            ToDate   = [datetime]::ParseExact($matches[2], "yyyyMMdd", $null)
        }
    }
}

# ============================================
# ★ 重複チェックを FileName で行う（絶対に重複しない）
# ============================================

foreach ($w in $weeklyList) {
    if ($parsedLi.FileName -notcontains $w.FileName) {
        $newLine = "  <li><a href=""$($w.FileName)"">$($w.FileName)</a></li>"
        $parsedLi += [PSCustomObject]@{
            Line     = $newLine
            FileName = $w.FileName
            FromDate = $w.FromDate
            ToDate   = $w.ToDate
        }
    }
}

# ============================================
# ★ 日付でソート（最新が一番上）
# ============================================

$sortedLi = $parsedLi | Sort-Object ToDate -Descending

# ============================================
# 新しい <ul> ブロックを作成
# ============================================

$newUlBlock = "<ul>`r`n"
foreach ($item in $sortedLi) {
    $newUlBlock += $item.Line + "`r`n"
}
$newUlBlock += "</ul>"

# ============================================
# index.html を再構築（タグ位置で置換）
# ============================================

$newIndexText = $indexText.Substring(0, $ulStartPos) +
                $newUlBlock +
                $indexText.Substring($ulEndPos + 5)

# 保存
$newIndexText | Out-File -FilePath $indexPath -Encoding UTF8

Write-Host "index.html updated successfully (sorted & deduplicated)."
