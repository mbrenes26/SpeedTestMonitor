
# ⚙️ Configuración del Script Principal - SpeedTest Monitor

Este documento explica cómo está estructurado el script `speedtest_monitor.ps1`, qué debes personalizar y cómo adaptarlo a diferentes entornos.

---

## 📁 Ubicación recomendada del script

Ubica el archivo `speedtest_monitor.ps1` en:

```
C:\SpeedTest\speedtest_monitor.ps1
```

---

## 🔧 Elementos de configuración dentro del script

### 1. Ruta del ejecutable SpeedTest

```powershell
$speedTestExePath = "C:\SpeedTest\speedtest.exe"
```

🔁 Modifica esta ruta si colocas el archivo en otra ubicación.

---

### 2. Ruta del archivo de salida JSON (dashboard)

```powershell
$dataJsonPath = "C:\SpeedTest\data.json"
```

Este archivo se actualiza automáticamente después de cada medición.

---

### 3. Bot de Telegram

```powershell
$botToken = 'TU-BOT-TOKEN'
$chatId   = 'TU-CHAT-ID'
```

🔁 Reemplaza estos valores con los que obtuviste siguiendo la guía en [`telegram_bot.md`](./telegram_bot.md)

---

## 🧠 ¿Qué hace este script?

Cada vez que se ejecuta:

1. Llama al ejecutable `speedtest.exe` y obtiene el resultado en formato JSON.
2. Extrae:
   - Velocidad de descarga (Mbps)
   - Velocidad de subida (Mbps)
   - Latencia (ms)
   - ISP y servidor
   - URL del resultado
3. Guarda todo en una base de datos local SQLite (`SpeedTestResults.db`)
4. Exporta los datos recientes a `data.json` para el dashboard web.
5. Si la descarga o subida es menor a 6 Mbps, envía una alerta a Telegram.

---

## ⚠️ Recomendación

Agrega control de errores con `try/catch`, logs de errores en disco (`SpeedTestErrors.log`) y asegura que:

- El módulo `PSSQLite` esté cargado.
- La base de datos esté en la misma carpeta (o actualizar `$dbPath`).
- Los permisos estén correctos si usas tareas programadas.

---

## 🚨 Umbral de alerta

Por defecto, el script alerta cuando:

```powershell
if (($data.DownloadSpeed -lt 6) -or ($data.UploadSpeed -lt 6)) { ... }
```

Puedes cambiar estos valores si tu conexión normalmente es más rápida o más lenta.

---

## 🛠️ Ejecutar manualmente para pruebas

```powershell
pwsh -File C:\SpeedTest\speedtest_monitor.ps1
```

---

## 🎯 Resultado esperado

Al ejecutarlo, deberías ver:

- ✅ Resultado en consola (resumen)
- ✅ Registro en base de datos
- ✅ Archivo `data.json` actualizado
- ✅ Alerta en Telegram (si aplica)

---

## 📦 Automatización recomendada

Usar una tarea programada que ejecute el script cada 30 minutos:

```powershell
pwsh -File C:\SpeedTest\speedtest_monitor.ps1
```

Ver [scheduled_tasks.md](./scheduled_tasks.md) para más detalles.

---
