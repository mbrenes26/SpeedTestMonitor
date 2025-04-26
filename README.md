
# 📈 SpeedTest Monitor

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mbrenes26)

Sistema completo para el monitoreo automatizado de la velocidad de internet, con alertas en Telegram y dashboard web en tiempo real.
...

Sistema completo para el monitoreo automatizado de la velocidad de internet, con alertas en Telegram y dashboard web en tiempo real.

---

## 🚀 Características Principales

- Ejecución automática de mediciones de velocidad usando `speedtest.exe`
- Almacenamiento local de resultados en base de datos SQLite
- Alertas inmediatas a Telegram si la velocidad baja de umbrales críticos
- Generación automática de archivo `data.json` para frontend web
- Dashboard web responsive (modo claro/oscuro, filtros de fechas)
- Reporte diario enviado a Telegram con resumen de desempeño
- Arquitectura modular, portable y lista para escalar

---

## 📂 Estructura del Proyecto

```plaintext
SpeedTestMonitor/
├── scripts/
│   ├── speedtest_monitor.ps1
│   ├── enviarReporteDiario.ps1
│   └── create-scheduledTask.ps1 (opcional)
├── web/
│   ├── index.html
│   ├── dashboard.js
│   └── dashboard.css
├── docs/
│   ├── installation.md
│   ├── telegram_bot.md
│   ├── configure_speedtest_monitor.md
│   ├── configure_daily_report.md
│   ├── dashboard_web.md (futuro)
│   ├── scheduled_tasks.md
│   └── project_structure.md (futuro)
├── README.md
└── LICENSE (opcional)
```

---

## 🛠️ Tecnologías y Dependencias

- **PowerShell 7+**
- **PSSQLite** (módulo de PowerShell)
- **SQLite** local
- **speedtest.exe** CLI de Ookla
- **Telegram Bot API**
- **Chart.js** para gráficos web
- **Servidor IIS** o **WebServer** (opcional)

---

## 📋 Documentación

La documentación completa está disponible en la carpeta `/docs/` e incluye:

- Guía de instalación
- Creación del bot de Telegram
- Configuración del sistema de mediciones
- Configuración del reporte diario
- Automatización de tareas programadas
- Estructura del dashboard web

---

## 📦 Instalación Rápida

```bash
git clone https://github.com/mbrenes26/SpeedTestMonitor.git
cd SpeedTestMonitor
# Seguir los pasos en docs/installation.md
```

---

## 🎯 Estado del Proyecto

✅ Captura automática de mediciones  
✅ Almacenamiento seguro en SQLite  
✅ Alertas por baja velocidad en Telegram  
✅ Dashboard web interactivo y responsive  
✅ Reporte diario automatizado  

---

## 📬 Contacto

Proyecto desarrollado y documentado por [**Mario** 🚀](https://www.linkedin.com/in/mbrenes26) 
¡Un ejemplo de automatización, monitoreo y documentación profesional!

---
