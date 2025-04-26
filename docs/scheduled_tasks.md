
# 🔄 Automatización con Tareas Programadas - SpeedTest Monitor

Este documento explica cómo configurar las tareas programadas necesarias para que SpeedTest Monitor funcione de manera completamente automática.

---

## 📋 Tareas necesarias

| Tarea | Descripción | Frecuencia |
|:---|:---|:---|
| Medición de velocidad | Ejecutar `speedtest_monitor.ps1` | Cada 30 minutos |
| Envío de reporte diario | Ejecutar `enviarReporteDiario.ps1` | Una vez al día (ej. 7:00 PM) |

---

## ⚙️ Crear tareas programadas manualmente

### Requisitos

- Debes tener permisos de administrador.
- PowerShell 7 (`pwsh.exe`) debe estar instalado.

### 1. Crear tarea para medición de velocidad

```powershell
$action = New-ScheduledTaskAction -Execute "C:\Program Files\PowerShell\7\pwsh.exe" -Argument "-ExecutionPolicy Bypass -File C:\SpeedTest\speedtest_monitor.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "5:00PM" -RepetitionInterval (New-TimeSpan -Minutes 30) -RepetitionDuration ([timespan]::MaxValue)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName "SpeedTest_Monitor" -Description "Ejecuta medición de velocidad cada 30 min" -Force
```

---

### 2. Crear tarea para reporte diario

```powershell
$action = New-ScheduledTaskAction -Execute "C:\Program Files\PowerShell\7\pwsh.exe" -Argument "-ExecutionPolicy Bypass -File C:\SpeedTest\enviarReporteDiario.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "7:00PM"
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName "SpeedTest_ReporteDiario" -Description "Envía reporte diario de velocidad a Telegram" -Force
```

---

## 🔥 Opcional: Script de creación automática

Puedes crear un script como `create-scheduledTask.ps1` que automatice ambas tareas en un solo paso.

---

## 📋 Verificar las tareas programadas

Puedes ver todas las tareas registradas con:

```powershell
Get-ScheduledTask | Where-Object {$_.TaskName -like "SpeedTest_*"}
```

O bien usando el Programador de Tareas de Windows (`taskschd.msc`)

---

## 🚨 Consejos

- Asegúrate que `pwsh.exe` esté bien referenciado.
- Revisa los permisos del usuario que ejecuta las tareas (`SYSTEM` recomendado).
- Si haces cambios en los scripts, actualiza también las tareas si es necesario.
- Usa nombres claros para las tareas.

---

## 🎯 Resultado esperado

- ✅ Mediciones de velocidad automáticas cada 30 minutos.
- ✅ Resumen diario en Telegram sin intervención manual.

---
