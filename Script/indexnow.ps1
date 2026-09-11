$urls = @(
    "https://yahikoyama.github.io/weather2/",
    "https://yahikoyama.github.io/weather2/weather_report_now.html",
    "https://yahikoyama.github.io/weather2/sitemap.xml"
)

$api = "https://api.indexnow.org/indexnow"

$body = @{
    host = "yahikoyama.github.io"
    key = "123456789abcdef123456789abcdef"
    keyLocation = "https://yahikoyama.github.io/weather2/indexnow-key.txt"
    urlList = $urls
}

try {
    $json = $body | ConvertTo-Json -Depth 5
    $response = Invoke-RestMethod -Uri $api -Method Post -ContentType "application/json" -Body $json
    Write-Host "IndexNow送信完了（成功）"
}
catch {
    Write-Host "IndexNow送信エラー:"
    Write-Host $_.Exception.Message
}
