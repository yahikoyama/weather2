# ▼ 設定ファイル読み込み
$configPath = "C:\Weather\Config\dbconfig.json"
$config = Get-Content -Raw $configPath | ConvertFrom-Json

# ▼ DB接続文字列
$connectionString = "Server=$($config.Server);Database=$($config.Database);User ID=$($config.User);Password=$($config.Password);"

# ▼ OpenWeatherMap APIキー
$apiKey = $config.OpenWeatherApiKey

# ▼ ログファイル設定
$logDir = "C:\Weather\Logs"
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }

$logFile = "$logDir\weather_{0}.log" -f (Get-Date -Format "yyyyMMdd")

function Write-Log($message) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp  $message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

Write-Log "=== WeatherLogger 実行開始 ==="

# ▼ 時刻情報
$now = Get-Date
$timeSlot = $now.ToString("HHmm")
$logDate = $now.ToString("yyyy-MM-dd")

# ▼ API呼び出しカウンタ
$callCount = 0

try {
    # ▼ DB接続
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    Write-Log "DB接続成功"

    # ▼ 都市マスタ取得
    $cmd = $connection.CreateCommand()
    $cmd.CommandText = "SELECT CityCode, CityEn, Latitude, Longitude FROM CityMaster"
    $reader = $cmd.ExecuteReader()

    $cities = @()
    while ($reader.Read()) {
        $cities += [PSCustomObject]@{
            CityCode = $reader["CityCode"]
            CityEn   = $reader["CityEn"]
            Lat      = $reader["Latitude"]
            Lon      = $reader["Longitude"]
        }
    }
    $reader.Close()

    Write-Log "都市数: $($cities.Count)"

    foreach ($city in $cities) {

        Write-Log "都市処理開始: $($city.CityEn)"

        # ▼ API呼び出し制限チェック
        if ($callCount -ge 60) {
            Write-Log "API呼び出し60回到達 → 1分待機"
            Start-Sleep -Seconds 60
            $callCount = 0
        }

        # ▼ 緯度経度が無い場合は自動取得（NULL または 空文字）
        if ([string]::IsNullOrWhiteSpace($city.Lat) -or [string]::IsNullOrWhiteSpace($city.Lon)) {

            $geoUrl = "http://api.openweathermap.org/geo/1.0/direct?q=$($city.CityEn)&limit=1&appid=$apiKey"
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
                    WHERE CityCode = '$($city.CityCode)'
                "
                $updateCmd.ExecuteNonQuery()
            }
            else {
                Write-Log "緯度経度取得失敗: $($city.CityEn)"
                continue
            }
        }
        else {
            $lat = $city.Lat
            $lon = $city.Lon
        }

        # ▼ API呼び出し制限チェック
        if ($callCount -ge 60) {
            Write-Log "API呼び出し60回到達 → 1分待機"
            Start-Sleep -Seconds 60
            $callCount = 0
        }

        # ▼ 気象データ取得
        $weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=ja"
        Write-Log "Weather API 呼び出し: $weatherUrl"

        $weather = Invoke-RestMethod -Uri $weatherUrl -Method Get
        $callCount++
        Start-Sleep -Milliseconds 1200

        $temp = $weather.main.temp
        $humidity = $weather.main.humidity
        $weatherCode = $weather.weather[0].id

        Write-Log "取得結果: temp=$temp humidity=$humidity code=$weatherCode"

        # ▼ WeatherLog に登録
        $insertCmd = $connection.CreateCommand()
        $insertCmd.CommandText = "
            INSERT INTO WeatherLog (LogDate, CityCode, Temperature, Humidity, WeatherCode, TimeSlot)
            VALUES ('$logDate', '$($city.CityCode)', $temp, $humidity, $weatherCode, '$timeSlot')
        "
        $insertCmd.ExecuteNonQuery()

        Write-Log "DB登録完了: $($city.CityEn)"
    }

    $connection.Close()
    Write-Log "DB接続終了"

}
catch {
    Write-Log "エラー発生: $_"
}

Write-Log "=== WeatherLogger 実行終了 ==="
