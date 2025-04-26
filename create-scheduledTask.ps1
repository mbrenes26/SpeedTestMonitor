# Configuración de la tarea
$taskName = "SpeedTest Monitor Task"
$scriptPath = "C:\speedTest\speedTestv4-2025.ps1"

# Crear la acción
$action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# Crear el trigger adecuado
$trigger = New-ScheduledTaskTrigger -Once -At "17:00" -RepetitionInterval (New-TimeSpan -Minutes 30) -RepetitionDuration (New-TimeSpan -Days 1)

# Crear el principal
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Registrar la tarea
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName $taskName -Description "Ejecuta SpeedTest cada 30 minutos desde las 5:00 PM usando PowerShell Core (pwsh.exe)" -Force

Write-Host "✅ Tarea programada '$taskName' creada exitosamente para iniciar a las 5:00 PM." -ForegroundColor Green
