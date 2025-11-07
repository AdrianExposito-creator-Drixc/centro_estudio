#!/usr/bin/env python3
"""
INTEGRACIÓN MICROSOFT 365 - WORK 2027
=====================================
Script para integración automática con Microsoft 365 Copilot
Genera prompts y comandos optimizados para el flujo Work 2027

Autor: Adrián Drix
Proyecto: Work 2027
"""

import os
import json
import datetime
from pathlib import Path
from typing import Dict, List

class Work2027M365Integration:
    """Integración automática con Microsoft 365 Copilot"""

    def __init__(self):
        self.today = datetime.datetime.now()
        self.onedrive_path = Path.home() / "OneDrive" / "Work2027"
        self.prompts_path = self.onedrive_path / "02_IA_Copilot" / "Prompts_M365"
        self.templates_path = self.onedrive_path / "02_IA_Copilot" / "Templates"

        # Crear directorios
        self.prompts_path.mkdir(parents=True, exist_ok=True)
        self.templates_path.mkdir(parents=True, exist_ok=True)

    def generar_prompt_maestro(self) -> str:
        """Genera el prompt maestro para Microsoft 365 Copilot"""
        fecha_str = self.today.strftime("%d/%m/%Y")

        prompt = f"""🤖 PROMPT MAESTRO WORK 2027 - MICROSOFT 365 COPILOT

**Fecha**: {fecha_str}
**Contexto**: Sistema de automatización personal y profesional

## 🎯 INSTRUCCIONES PRINCIPALES

Actúa como mi asistente ejecutivo personal Work 2027. Tienes acceso a mi OneDrive con la siguiente estructura:

📁 **OneDrive/Work2027/**
- `01_Python/` → Scripts y código (generado por GitHub Copilot VS Code)
- `02_IA_Copilot/` → Prompts y configuraciones IA
- `03_Datos_y_Analytics/` → Análisis y visualizaciones
- `04_Web_y_Apps/` → Desarrollo web
- `05_Finanzas_y_Documentos/` → Gestión documental y reportes
- `06_Backup_y_Sincronizacion/` → Respaldos automáticos

## 🔄 WORKFLOW DIARIO AUTOMÁTICO

**Cada día debes:**

1. **📊 REVISAR LOGS DIARIOS**
   - Leer `05_Finanzas_y_Documentos/Logs_Diarios/LOG_WORK2027_*.md`
   - Analizar progreso en desarrollo Python
   - Identificar patrones y tendencias

2. **📄 GENERAR INFORME EJECUTIVO**
   - Crear documento Word profesional
   - Título: "Informe Work 2027 - {fecha_str}"
   - Incluir gráficos de progreso si es posible
   - Guardar en `05_Finanzas_y_Documentos/Informes_Ejecutivos/`

3. **📈 ANÁLISIS DE PRODUCTIVIDAD**
   - Calcular métricas de productividad
   - Comparar con días anteriores
   - Sugerir optimizaciones

4. **📧 RESUMEN EJECUTIVO**
   - Crear resumen de 3-5 puntos clave
   - Highlight de logros del día
   - Tareas pendientes prioritarias

## 🎨 FORMATO DE INFORMES

**Usa este template para informes diarios:**

```
# 📊 INFORME WORK 2027 - [FECHA]

## 🚀 Resumen Ejecutivo
- **Productividad**: [Alta/Media/Baja]
- **Archivos procesados**: [X archivos]
- **Líneas de código**: [X,XXX líneas]
- **Proyectos activos**: [X proyectos]

## 📈 Métricas del Día
[Insertar gráfico de barras con progreso]

## 🎯 Logros Destacados
- [Logro 1]
- [Logro 2]
- [Logro 3]

## 📋 Próximas Acciones
- [ ] [Acción prioritaria 1]
- [ ] [Acción prioritaria 2]
- [ ] [Acción prioritaria 3]

## 💡 Recomendaciones IA
[Sugerencias basadas en patrones detectados]
```

## 🔧 COMANDOS RÁPIDOS

**Para activar funciones específicas, usa:**

- `@Work2027 informe diario` → Generar informe del día
- `@Work2027 análisis semanal` → Resumen de la semana
- `@Work2027 backup reportes` → Respaldar documentos importantes
- `@Work2027 sync status` → Estado de sincronización
- `@Work2027 optimize workflow` → Sugerir mejoras de flujo

## ⚙️ CONFIGURACIÓN PERSONALIZADA

**Mis preferencias:**
- Idioma: Español
- Formato fechas: DD/MM/YYYY
- Estilo: Profesional pero cercano
- Gráficos: Preferir barras y líneas
- Colores: Verde (#2D5A27) para Work 2027

## 🚨 ALERTAS AUTOMÁTICAS

**Notifícame cuando:**
- No hay actividad de código por >24h
- Detectes patrones de baja productividad
- Haya archivos importantes sin respaldo
- Se requiera actualización de informes

---
*Este prompt maestro se actualiza automáticamente cada día via GitHub Copilot VS Code*"""

        return prompt

    def crear_templates_documentos(self):
        """Crea templates para documentos automáticos"""

        # Template para informes diarios
        template_diario = """# 📊 INFORME WORK 2027 - {fecha}

## 🚀 Resumen Ejecutivo
- **Estado del proyecto**: {estado}
- **Productividad**: {productividad}
- **Archivos procesados**: {archivos_total}
- **Líneas de código**: {lineas_codigo:,}
- **Proyectos activos**: {proyectos_activos}

## 📈 Métricas de Desarrollo

### Actividad de Código
- **Archivos nuevos**: {archivos_nuevos}
- **Archivos modificados**: {archivos_modificados}
- **Commits realizados**: {commits}

### Distribución por Proyecto
{distribucion_proyectos}

## 🎯 Logros del Día
{logros}

## 📋 Tareas Completadas
{tareas_completadas}

## ⏭️ Próximas Acciones
{proximas_acciones}

## 💡 Recomendaciones IA
{recomendaciones}

---
**Generado automáticamente**: {timestamp}
**Próxima actualización**: {proxima_actualizacion}
"""

        # Template para análisis semanal
        template_semanal = """# 📈 ANÁLISIS SEMANAL WORK 2027

## 🗓️ Período: {fecha_inicio} - {fecha_fin}

## 📊 Métricas Generales
- **Días activos**: {dias_activos}/7
- **Total líneas código**: {total_lineas:,}
- **Archivos creados**: {total_archivos_nuevos}
- **Proyectos desarrollados**: {total_proyectos}

## 🏆 Highlights de la Semana
{highlights}

## 📉 Áreas de Mejora
{areas_mejora}

## 🎯 Objetivos Próxima Semana
{objetivos_semana}

## 📋 Plan de Acción
{plan_accion}
"""

        # Guardar templates
        with open(self.templates_path / "template_informe_diario.md", 'w', encoding='utf-8') as f:
            f.write(template_diario)

        with open(self.templates_path / "template_analisis_semanal.md", 'w', encoding='utf-8') as f:
            f.write(template_semanal)

    def generar_comandos_rapidos(self) -> Dict[str, str]:
        """Genera comandos rápidos para Microsoft 365"""
        comandos = {
            "informe_diario": """@Copilot, genera el informe diario Work 2027:
1. Lee el último LOG_WORK2027_*.md
2. Usa template_informe_diario.md
3. Crea documento Word profesional
4. Guarda en Informes_Ejecutivos/""",

            "analisis_semanal": """@Copilot, crea análisis semanal Work 2027:
1. Revisa últimos 7 LOG_WORK2027_*.md
2. Calcula métricas agregadas
3. Identifica tendencias y patrones
4. Genera recomendaciones""",

            "backup_reportes": """@Copilot, respalda documentos Work 2027:
1. Copia Informes_Ejecutivos/ a Backup/
2. Comprime logs antiguos
3. Verifica integridad archivos
4. Confirma completado""",

            "sync_status": """@Copilot, verifica sincronización Work 2027:
1. Compara timestamps VS Code ↔ OneDrive
2. Identifica archivos pendientes
3. Reporta estado sincronización
4. Sugiere acciones correctivas""",

            "optimize_workflow": """@Copilot, optimiza workflow Work 2027:
1. Analiza patrones de trabajo últimos 30 días
2. Identifica cuellos de botella
3. Sugiere automatizaciones adicionales
4. Propón mejoras de eficiencia"""
        }

        return comandos

    def crear_configuracion_completa(self):
        """Crea la configuración completa de integración"""
        print("🔧 Creando configuración Microsoft 365...")

        # 1. Prompt maestro
        prompt_maestro = self.generar_prompt_maestro()
        with open(self.prompts_path / "prompt_maestro_m365.md", 'w', encoding='utf-8') as f:
            f.write(prompt_maestro)

        # 2. Templates
        self.crear_templates_documentos()

        # 3. Comandos rápidos
        comandos = self.generar_comandos_rapidos()
        with open(self.prompts_path / "comandos_rapidos.json", 'w', encoding='utf-8') as f:
            json.dump(comandos, f, indent=2, ensure_ascii=False)

        # 4. Configuración de automatización
        config_auto = {
            "workflow_diario": {
                "hora_ejecucion": "09:00",
                "comandos": ["informe_diario", "sync_status"],
                "notificaciones": True
            },
            "workflow_semanal": {
                "dia_ejecucion": "lunes",
                "hora_ejecucion": "08:00",
                "comandos": ["analisis_semanal", "backup_reportes"],
                "notificaciones": True
            },
            "alertas": {
                "inactividad_codigo": "24h",
                "respaldo_documentos": "7d",
                "revision_metricas": "3d"
            }
        }

        with open(self.prompts_path / "config_automatizacion.json", 'w', encoding='utf-8') as f:
            json.dump(config_auto, f, indent=2, ensure_ascii=False)

        print("✅ Configuración Microsoft 365 creada exitosamente")

        return {
            "prompt_maestro": str(self.prompts_path / "prompt_maestro_m365.md"),
            "templates": str(self.templates_path),
            "comandos": str(self.prompts_path / "comandos_rapidos.json"),
            "config": str(self.prompts_path / "config_automatizacion.json")
        }

def main():
    """Función principal"""
    print("🤖 WORK 2027 - INTEGRACIÓN MICROSOFT 365")
    print("=" * 45)

    integration = Work2027M365Integration()
    result = integration.crear_configuracion_completa()

    print("\n📁 Archivos creados:")
    for nombre, ruta in result.items():
        print(f"- {nombre}: {ruta}")

    print("\n🚀 PRÓXIMOS PASOS:")
    print("1. Abre Microsoft 365 (Word/Excel/PowerPoint)")
    print("2. Copia el prompt maestro desde prompt_maestro_m365.md")
    print("3. Pégalo en Copilot Microsoft 365")
    print("4. Confirma con: '@Work2027 configuración lista'")

    return 0

if __name__ == "__main__":
    main()