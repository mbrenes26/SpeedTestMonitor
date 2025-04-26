
# ⚙️ Guía de Instalación - SpeedTest Monitor

Este documento describe paso a paso cómo instalar y configurar el sistema completo de SpeedTest Monitor en Windows Server o Windows 10/11.

---

## 📋 Requisitos Previos

| Requisito | Versión Recomendada |
|:---|:---|
| PowerShell | 7 o superior |
| Git | 2.40+ |
| speedtest.exe | CLI oficial de Ookla |
| Módulo PSSQLite | Última versión |
| Acceso a Internet | Requerido |
| (Opcional) IIS u otro Web Server | Para dashboard web |

---

## 📁 Estructura Recomendada

```
C:\SpeedTest\
├── speedtest.exe
├── speedtest_monitor.ps1
├── enviarReporteDiario.ps1
├── SpeedTestResults.db
├── data.json
├── dashboard.css
├── dashboard.js
└── index.html
```

Puedes usar esta carpeta como raíz para ejecutar y servir archivos web desde IIS.

---

## ⬇️ Descargar SpeedTest CLI

1. Ir a [https://www.speedtest.net/apps/cli](https://www.speedtest.net/apps/cli)
2. Descargar el ZIP para **Windows x64**
3. Extraer y copiar el `speedtest.exe` a `C:\SpeedTest\`

---

## ✅ Aceptar la licencia de SpeedTest

Antes de usarlo automáticamente, ejecuta:

```powershell
& "C:\SpeedTest\speedtest.exe" --accept-license --accept-gdpr
```

Esto evita que aparezca la advertencia de aceptación manual del EULA/GDPR.

---

## 🔧 Instalar PSSQLite

Ejecuta en PowerShell:

```powershell
Install-Module -Name PSSQLite -Scope CurrentUser -Force -AllowClobber
```

Este módulo permite ejecutar consultas SQLite desde PowerShell.

---

## 📦 Clonar el repositorio (opcional)

```bash
git clone https://github.com/mbrenes26/SpeedTestMonitor.git
```

Esto descargará el proyecto completo si no lo tienes localmente.

---

## 🛠️ Ejecutar el script manualmente (test)

```powershell
pwsh -File C:\SpeedTest\speedtest_monitor.ps1
```

Verifica que:
- Se guarde la medición en la base de datos SQLite
- Se actualice el archivo `data.json`
- Si la velocidad es baja, se envíe alerta a Telegram

---

## 🖥️ Servir el dashboard web

1. Asegúrate de tener **IIS instalado**
2. Crea un sitio o carpeta virtual apuntando a `C:\SpeedTest\`
3. Navega a `http://localhost/` o `http://tu-servidor/` y verás el `index.html`

---

## 🔄 Crear tareas programadas

1. Usa el script `create-scheduledTask.ps1` para programar:
   - El script de medición cada 30 minutos
   - El reporte diario a las 7:00 PM

2. Asegúrate de usar `pwsh.exe` y de tener permisos de administrador.

---

## 📬 Configurar Telegram

Ver documentación en [`docs/telegram_bot.md`](./telegram_bot.md)

---

## 🎯 Final

¡Con esto tu sistema estará monitoreando y reportando automáticamente tu velocidad de internet!
