function SQLServerSelect([string]$dataSource, [string]$database, [string]$userId, [string]$password, [string]$sql){

    # SqlConnectionStringBuilder を使用してSQL接続の設定を保存
    [System.Data.SqlClient.SqlConnectionStringBuilder]$connectionString = New-Object -TypeName System.Data.SqlClient.SqlConnectionStringBuilder;
    [object]$connectionString['Data Source'] = $dataSource;
    [object]$connectionString['Initial Catalog'] = $database;
    [object]$connectionString['User ID'] = $userId;
    [object]$connectionString['Password'] = $password;

    # DataTableを利用してSQL実行結果を一時格納
    [System.Data.DataTable]$resultsDataTable = New-Object System.Data.DataTable;

    # SQLConnection、SQLCommandを設定
    [System.Data.SQLClient.SQLConnection]$sqlConnection = New-Object System.Data.SQLClient.SQLConnection($connectionString);
    [System.Data.SQLClient.SQLCommand]$sqlCommand = New-Object System.Data.SQLClient.SQLCommand($sql, $sqlConnection);

    # データベースへ接続
    [object]$sqlConnection.Open();

    # ExecuteReaderを実行してDataTableにデータを格納
    [object]$resultsDataTable.Load($sqlCommand.ExecuteReader());

    # CSV形式で標準出力
    $resultsDataTable | ConvertTo-Csv -NoTypeInformation;

    # データベース接続解除
    [object]$sqlConnection.Close();
}