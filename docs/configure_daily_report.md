
# 📝 Configuración del Reporte Diario - SpeedTest Monitor

Este documento describe cómo funciona el script `enviarReporteDiario.ps1` y cómo puedes personalizarlo para enviar automáticamente un resumen diario del desempeño de tu conexión a través de Telegram.

---

## 📁 Ubicación recomendada del script

Ubica el archivo `enviarReporteDiario.ps1` en:

```
C:\SpeedTest\enviarReporteDiario.ps1
```

---

## 🔧 Elementos configurables

### 1. Ruta de la base de datos

```powershell
$dbPath = Join-Path -Path $PSScriptRoot -ChildPath "SpeedTestResults.db"
```

🔁 Modifica si usas una ruta diferente.

---

### 2. Bot de Telegram

```powershell
$botToken = 'TU-BOT-TOKEN'
$chatId   = 'TU-CHAT-ID'
```

🔁 Reemplaza por los datos de tu bot. Consulta [`telegram_bot.md`](./telegram_bot.md) si necesitas ayuda.

---

## 🧠 ¿Qué hace este script?

Cuando se ejecuta:

1. Consulta todos los registros del día actual en la base de datos.
2. Calcula:
   - Promedio, mínimo y máximo de velocidad de descarga (Mbps)
   - Promedio, mínimo y máximo de velocidad de subida (Mbps)
   - Promedio de latencia (ms)
   - Total de mediciones del día
3. Genera un resumen formateado.
4. Envía el resumen vía Telegram.

---

## 🛠️ Ejecución manual de prueba

```powershell
pwsh -File C:\SpeedTest\enviarReporteDiario.ps1
```

✅ Esto debería generar el mensaje y enviarlo al bot de Telegram configurado.

---

## 🔄 Automatización con Tareas Programadas

Se recomienda programar el script para ejecutarse **una vez al día**, por ejemplo a las **7:00 PM**.

Puedes crear la tarea manualmente o usar el script `create-scheduledTask.ps1`.

```powershell
# Ejemplo de tarea programada:
pwsh -File C:\SpeedTest\enviarReporteDiario.ps1
```

Ver guía [`scheduled_tasks.md`](./scheduled_tasks.md) para más detalles.

---

## 🔐 Seguridad

- No publiques el `botToken` en repositorios públicos.
- Puedes usar variables de entorno o archivos `.ps1` ignorados por Git para almacenar tokens sensibles.

---

## 🎯 Resultado esperado

- ✅ Mensaje recibido en Telegram con estadísticas del día actual
- ✅ Informe legible y profesional
- ✅ Trazabilidad diaria sin necesidad de abrir el dashboard

---
