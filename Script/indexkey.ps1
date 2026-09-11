$bytes = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$key = [System.BitConverter]::ToString($bytes).Replace("-", "").ToLower()
$key
