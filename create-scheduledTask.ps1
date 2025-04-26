# Configuración de la tarea
$taskName = "SpeedTest Monitor Task"
$scriptPath = "C:\speedTest\speedTestv4-2025.ps1"
$action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -Once -At "17:00" -RepetitionInterval (New-TimeSpan -Minutes 30) -RepetitionDuration (New-TimeSpan -Days 1)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName $taskName -Description "Ejecuta SpeedTest cada 30 minutos desde las 5:00 PM usando PowerShell Core (pwsh.exe)" -Force



#################################

$action = New-ScheduledTaskAction -Execute "C:\Program Files\PowerShell\7\pwsh.exe" -Argument "-ExecutionPolicy Bypass -File C:\SpeedTest\enviarReporteDiario.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 7:00PM
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName "EnviarReporteDiarioSpeedTest" -Description "Envía resumen diario de SpeedTest a Telegram" -Force

