# =========================
# Configuración Inicial
# =========================

$scriptPath = $PSScriptRoot
$dbPath = Join-Path -Path $scriptPath -ChildPath "SpeedTestResults.db"
$speedTestExePath = "C:\SpeedTest\speedtest.exe"  # Asegúrate que aquí esté tu ejecutable
$dataJsonPath = "C:\SpeedTest\data.json"

# =========================
# Configuración de Telegram
# =========================

$botToken = '8171457060:AAGuXG-KrEzqJ6JFIRKcJoY7kEavByG-PSQ'
$chatId = '1910137504'

# =========================
# Funciones
# =========================

function Enviar-TelegramMensaje {
    param (
        [string]$botToken,
        [string]$chatId,
        [string]$mensaje
    )

    try {
        $url = "https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=$([uri]::EscapeDataString($mensaje))"
        Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
        Write-Host "✅ Mensaje enviado a Telegram." -ForegroundColor Cyan
    }
    catch {
        Write-Warning "⚠️ Error enviando mensaje a Telegram: $($_.Exception.Message)"
    }
}


function Ejecutar-SpeedTest {
    param(
        [string]$SpeedTestExe,
        [string]$ServerId
    )

    try {
        $output = & $SpeedTestExe -s $ServerId --format=json 2>$null
        if (-not $output) {
            throw "No se recibió salida del SpeedTest."
        }

        # Convertir el JSON
        $result = $output | ConvertFrom-Json
        return $result
    }
    catch {
        Write-Warning "Error ejecutando SpeedTest: $($_.Exception.Message)"
        return $null
    }
}

function Guardar-EnSQLite {
    param(
        $data
    )

    if (-not (Test-Path $dbPath)) {
        # Crear base de datos si no existe
        $query = @"
CREATE TABLE IF NOT EXISTS SpeedTestResults (
    Id              INTEGER PRIMARY KEY AUTOINCREMENT,
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
        Invoke-SqliteQuery -DataSource $dbPath -Query $query
    }

    # Insertar datos
    $nowDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $insertQuery = @"
INSERT INTO SpeedTestResults 
(Date, Server, ISP, DownloadSpeed, Latency, UploadSpeed, PacketLoss, ResultURL)
VALUES 
('$nowDate', '$($data.Server)', '$($data.ISP)', $($data.DownloadSpeed), $($data.Latency), $($data.UploadSpeed), '$($data.PacketLoss)', '$($data.ResultURL)');
"@
    Invoke-SqliteQuery -DataSource $dbPath -Query $insertQuery
}

# =========================
# Ejecución Principal
# =========================

try {
    if (-not (Get-Module -ListAvailable -Name PSSQLite)) {
        Install-Module -Name PSSQLite -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module PSSQLite
}
catch {
    Write-Error "Error cargando módulo PSSQLite: $($_.Exception.Message)"
    exit
}

# Ejecutar SpeedTest
$speedTestResult = Ejecutar-SpeedTest -SpeedTestExe $speedTestExePath -ServerId 46808

if ($speedTestResult) {
    # Preparar los datos
    $data = [PSCustomObject]@{
        Server        = $speedTestResult.server.name
        ISP           = $speedTestResult.isp
        DownloadSpeed = [math]::Round($speedTestResult.download.bandwidth * 8 / 1MB, 2)  # Mbps
        Latency       = [math]::Round($speedTestResult.ping.latency, 2)                  # ms
        UploadSpeed   = [math]::Round($speedTestResult.upload.bandwidth * 8 / 1MB, 2)    # Mbps
        PacketLoss    = if ($speedTestResult.packetLoss -ne $null) { "$($speedTestResult.packetLoss * 100)%" } else { "0%" }
        ResultURL     = $speedTestResult.result.url
    }

    # Guardar en SQLite
    Guardar-EnSQLite -data $data

    try {
        $consultaDatos = Invoke-SqliteQuery -DataSource $dbPath -Query @"
    SELECT 
        Date AS FechaHora,
        ROUND(DownloadSpeed, 2) AS Download,
        ROUND(UploadSpeed, 2) AS Upload,
        ROUND(Latency, 2) AS Latency
    FROM SpeedTestResults
    ORDER BY Date ASC
    LIMIT 1000;
"@
    
        $consultaDatos | ConvertTo-Json -Depth 5 | Out-File -FilePath $dataJsonPath -Encoding utf8
    
        Write-Host "✅ Archivo data.json actualizado correctamente." -ForegroundColor Green
    }
    catch {
        Write-Warning "⚠️ Error actualizando data.json: $($_.Exception.Message)"
    }
    

    # 🚨 Enviar alerta si la velocidad de descarga baja de 6 Mbps
    if (($data.DownloadSpeed -lt 9) -or ($data.UploadSpeed -lt 9)) {
        $mensaje = @"
🚨 *Alerta de Velocidad Baja*
Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm')
Servidor: $($data.Server)
ISP: $($data.ISP)
Descarga: $($data.DownloadSpeed) Mbps
Subida: $($data.UploadSpeed) Mbps
Latencia: $($data.Latency) ms
"@

        Enviar-TelegramMensaje -botToken $botToken -chatId $chatId -mensaje $mensaje
    }


    # Mostrar resumen en pantalla
    Write-Host "✅ SpeedTest ejecutado y guardado:"
    $data | Format-Table -AutoSize
}
else {
    Write-Warning "No se pudo obtener resultados del SpeedTest."
}
