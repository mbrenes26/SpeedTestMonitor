# =========================
# Configuración Inicial
# =========================

$scriptPath = $PSScriptRoot
$dbPath = Join-Path -Path $scriptPath -ChildPath "SpeedTestResults.db"

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
        Write-Host "✅ Resumen diario enviado a Telegram." -ForegroundColor Cyan
    }
    catch {
        Write-Warning "⚠️ Error enviando mensaje a Telegram: $($_.Exception.Message)"
    }
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

# Obtener fecha actual
$hoy = (Get-Date).ToString('yyyy-MM-dd')

# Consultar mediciones de hoy
$consultaDatos = Invoke-SqliteQuery -DataSource $dbPath -Query @"
SELECT 
    DownloadSpeed, 
    UploadSpeed, 
    Latency
FROM SpeedTestResults
WHERE Date LIKE '$hoy%'
"@

if ($consultaDatos.Count -eq 0) {
    Write-Host "⚠️ No hay datos disponibles para hoy."
    exit
}

# Calcular métricas
$download = $consultaDatos | Select-Object -ExpandProperty DownloadSpeed
$upload = $consultaDatos | Select-Object -ExpandProperty UploadSpeed
$latency = $consultaDatos | Select-Object -ExpandProperty Latency

$mensaje = @"
📅 Resumen Diario - $hoy

📥 Descarga:
- Promedio: $([math]::Round(($download | Measure-Object -Average).Average, 2)) Mbps
- Mínima: $([math]::Round(($download | Measure-Object -Minimum).Minimum, 2)) Mbps
- Máxima: $([math]::Round(($download | Measure-Object -Maximum).Maximum, 2)) Mbps

📤 Subida:
- Promedio: $([math]::Round(($upload | Measure-Object -Average).Average, 2)) Mbps
- Mínima: $([math]::Round(($upload | Measure-Object -Minimum).Minimum, 2)) Mbps
- Máxima: $([math]::Round(($upload | Measure-Object -Maximum).Maximum, 2)) Mbps

🕒 Latencia:
- Promedio: $([math]::Round(($latency | Measure-Object -Average).Average, 2)) ms

📝 Total de mediciones: $($consultaDatos.Count)
"@

Enviar-TelegramMensaje -botToken $botToken -chatId $chatId -mensaje $mensaje
