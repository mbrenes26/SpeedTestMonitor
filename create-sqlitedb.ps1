# Asegura que el módulo esté disponible (instalar si no tienes)
#Install-Module -Name PSSQLite -Scope CurrentUser -Force -AllowClobber
import-module -name PSSQLite
# Ruta de la base de datos (en el mismo folder del script)
$dbPath = Join-Path -Path $PSScriptRoot -ChildPath "SpeedTestResults.db"

# Crear conexión a SQLite
$connectionString = "Data Source=$dbPath;Version=3;"
$connection = New-Object System.Data.SQLite.SQLiteConnection($connectionString)
$connection.Open()

# Crear tabla si no existe
$command = $connection.CreateCommand()
$command.CommandText = @"
CREATE TABLE IF NOT EXISTS SpeedTestResults (
    Id              INTEGER PRIMARY KEY AUTOINCREMENT,
    Iteration       INTEGER,
    Date            TEXT,
    Server          TEXT,
    ISP             TEXT,
    DownloadSpeed   REAL,
    Latency         REAL,
    UploadSpeed     REAL,
    PacketLoss      TEXT,
    ResultURL       TEXT
);
"@
$command.ExecuteNonQuery()

# Cerrar conexión
$connection.Close()
Write-Host "Base de datos y tabla creadas correctamente." -ForegroundColor Green
