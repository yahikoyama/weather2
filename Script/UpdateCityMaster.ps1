# ▼ 設定ファイル読み込み
$configPath = "C:\WeatherSystem\Config\dbconfig.json"
$config = Get-Content $configPath | ConvertFrom-Json

# ▼ DB接続文字列
$connectionString = "Server=$($config.Server);Database=$($config.Database);User ID=$($config.User);Password=$($config.Password);"

# ▼ OpenWeatherMap APIキー
$apiKey = $config.OpenWeatherApiKey

# ▼ ログファイル設定
$logDir = "C:\WeatherSystem\Logs"
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }

$logFile = "$logDir\update_city_{0}.log" -f (Get-Date -Format "yyyyMMdd")

function Write-Log($message) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp  $message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

Write-Log "=== UpdateCityMaster 実行開始 ==="

# ▼ CSV 読み込み
$csvPath = "C:\WeatherSystem\Data\cities.csv"
$csv = Import-Csv $csvPath
Write-Log "CSV読込: $csvPath"
Write-Log "都市数: $($csv.Count)"

# ▼ API呼び出しカウンタ
$callCount = 0

try {
    # ▼ DB接続
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    Write-Log "DB接続成功"

    foreach ($row in $csv) {

        Write-Log "都市処理開始: $($row.CityEn)"

        # ▼ 既存チェック
        $checkCmd = $connection.CreateCommand()
        $checkCmd.CommandText = "
            SELECT COUNT(*) FROM CityMaster WHERE CityCode = '$($row.CityCode)'
        "
        $exists = $checkCmd.ExecuteScalar()

        if ($exists -eq 0) {
            Write-Log "新規登録: $($row.CityCode) $($row.CityEn)"

            $insertCmd = $connection.CreateCommand()
            $insertCmd.CommandText = "
                INSERT INTO CityMaster (CityCode, CityEn, CityJp)
                VALUES ('$($row.CityCode)', '$($row.CityEn)', N'$($row.CityJp)')
            "
            $insertCmd.ExecuteNonQuery()
        }
        else {
            Write-Log "既存データ: $($row.CityCode)（スキップ）"
        }

        # ▼ 緯度経度チェック
        $geoCmd = $connection.CreateCommand()
        $geoCmd.CommandText = "
            SELECT Latitude, Longitude FROM CityMaster WHERE CityCode = '$($row.CityCode)'
        "
        $reader = $geoCmd.ExecuteReader()
        $reader.Read()
        $lat = $reader["Latitude"]
        $lon = $reader["Longitude"]
        $reader.Close()

        if ($lat -ne $null -and $lon -ne $null) {
            Write-Log "緯度経度登録済み → スキップ"
            continue
        }

        # ▼ API呼び出し制限チェック
        if ($callCount -ge 60) {
            Write-Log "API呼び出し60回 → 1分待機"
            Start-Sleep -Seconds 60
            $callCount = 0
        }

        # ▼ 緯度経度取得
        $geoUrl = "http://api.openweathermap.org/geo/1.0/direct?q=$($row.CityEn)&limit=1&appid=$apiKey"
        Write-Log "Geocoding API 呼び出し: $geoUrl"

        $geo = Invoke-RestMethod -Uri $geoUrl -Method Get
        $callCount++
        Start-Sleep -Milliseconds 1200

        if ($geo.Count -gt 0) {
            $lat = $geo[0].lat
            $lon = $geo[0].lon

            Write-Log "緯度経度取得成功: lat=$lat lon=$lon"

            $updateCmd = $connection.CreateCommand()
            $updateCmd.CommandText = "
                UPDATE CityMaster
                SET Latitude = $lat, Longitude = $lon
                WHERE CityCode = '$($row.CityCode)'
            "
            $updateCmd.ExecuteNonQuery()

            Write-Log "緯度経度更新完了: $($row.CityCode)"
        }
        else {
            Write-Log "緯度経度取得失敗: $($row.CityEn)"
        }
    }

    $connection.Close()
    Write-Log "DB接続終了"

}
catch {
    Write-Log "エラー発生: $_"
}

Write-Log "=== UpdateCityMaster 実行終了 ==="
