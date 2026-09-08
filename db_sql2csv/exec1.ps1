. ".\config.ps1";
. ".\sql1.ps1";
. ".\util-db.ps1";

# DBから取得
SQLServerSelect $dataSource $database $userId $password $sql;