#!/usr/bin/env python3
"""
GENERADOR DE LOGS DIARIOS WORK 2027
===================================
Script principal para automatización de reportes diarios
Integración: VS Code + GitHub Copilot + Microsoft 365 Copilot + OneDrive

Autor: Adrián Drix
Proyecto: Work 2027
Fecha: Noviembre 2024
"""

import os
import sys
import json
import datetime
import subprocess
from pathlib import Path
from typing import Dict, List, Tuple
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

class Work2027LogGenerator:
    """Generador automático de logs diarios para Work 2027"""

    def __init__(self):
        self.today = datetime.datetime.now()
        self.workspace_path = Path("/home/drixc/centro_estudio")
        self.onedrive_path = Path.home() / "OneDrive" / "Work2027"
        self.reports_path = self.onedrive_path / "05_Finanzas_y_Documentos" / "Logs_Diarios"
        self.python_path = self.onedrive_path / "01_Python"

        # Crear directorios si no existen
        self.reports_path.mkdir(parents=True, exist_ok=True)
        self.python_path.mkdir(parents=True, exist_ok=True)

    def escanear_cambios_codigo(self) -> Dict[str, List[str]]:
        """Escanea archivos Python modificados en las últimas 24 horas"""
        cambios = {
            "archivos_nuevos": [],
            "archivos_modificados": [],
            "total_lineas": 0,
            "proyectos_activos": []
        }

        print("🔍 Escaneando cambios en el código...")

        # Buscar archivos Python modificados
        for archivo in self.workspace_path.rglob("*.py"):
            if archivo.stat().st_mtime > (self.today - datetime.timedelta(days=1)).timestamp():
                if archivo.stat().st_ctime > (self.today - datetime.timedelta(days=1)).timestamp():
                    cambios["archivos_nuevos"].append(str(archivo.relative_to(self.workspace_path)))
                else:
                    cambios["archivos_modificados"].append(str(archivo.relative_to(self.workspace_path)))

                # Contar líneas
                try:
                    with open(archivo, 'r', encoding='utf-8') as f:
                        cambios["total_lineas"] += len(f.readlines())
                except:
                    pass

        # Detectar proyectos activos
        proyectos = set()
        for archivo in cambios["archivos_nuevos"] + cambios["archivos_modificados"]:
            proyecto = archivo.split('/')[0] if '/' in archivo else "root"
            proyectos.add(proyecto)

        cambios["proyectos_activos"] = list(proyectos)

        return cambios

    def obtener_estadisticas_git(self) -> Dict[str, str]:
        """Obtiene estadísticas de Git si el directorio es un repositorio"""
        stats = {}

        try:
            # Cambios en el día
            resultado = subprocess.run([
                "git", "log", "--since='1 day ago'", "--oneline"
            ], capture_output=True, text=True, cwd=self.workspace_path)

            if resultado.returncode == 0:
                commits = resultado.stdout.strip().split('\n') if resultado.stdout.strip() else []
                stats["commits_hoy"] = len(commits)
                stats["ultimo_commit"] = commits[0] if commits else "Sin commits hoy"
            else:
                stats["commits_hoy"] = "N/A (no es repo Git)"
                stats["ultimo_commit"] = "N/A"

        except Exception as e:
            stats["commits_hoy"] = f"Error: {str(e)}"
            stats["ultimo_commit"] = "Error al obtener info"

        return stats

    def generar_resumen_copilot(self, cambios: Dict) -> str:
        """Genera un resumen optimizado para Microsoft 365 Copilot"""
        fecha_str = self.today.strftime("%d/%m/%Y")
        hora_str = self.today.strftime("%H:%M:%S")

        resumen = f"""# 📊 REPORTE DIARIO WORK 2027
**Fecha**: {fecha_str} | **Hora**: {hora_str}
**Generado por**: GitHub Copilot VS Code → Microsoft 365 Copilot

## 🚀 Resumen Ejecutivo
- **Archivos nuevos**: {len(cambios['archivos_nuevos'])}
- **Archivos modificados**: {len(cambios['archivos_modificados'])}
- **Líneas de código**: {cambios['total_lineas']:,}
- **Proyectos activos**: {len(cambios['proyectos_activos'])}

## 📁 Proyectos en Desarrollo
"""

        for proyecto in cambios['proyectos_activos']:
            archivos_proyecto = [f for f in cambios['archivos_nuevos'] + cambios['archivos_modificados']
                               if f.startswith(proyecto)]
            resumen += f"- **{proyecto}**: {len(archivos_proyecto)} archivos\n"

        resumen += f"""
## 📝 Archivos Nuevos ({len(cambios['archivos_nuevos'])})
"""

        for archivo in cambios['archivos_nuevos'][:10]:  # Máximo 10
            resumen += f"- `{archivo}`\n"

        if len(cambios['archivos_nuevos']) > 10:
            resumen += f"- ... y {len(cambios['archivos_nuevos']) - 10} archivos más\n"

        resumen += f"""
## ✏️ Archivos Modificados ({len(cambios['archivos_modificados'])})
"""

        for archivo in cambios['archivos_modificados'][:10]:  # Máximo 10
            resumen += f"- `{archivo}`\n"

        if len(cambios['archivos_modificados']) > 10:
            resumen += f"- ... y {len(cambios['archivos_modificados']) - 10} archivos más\n"

        # Agregar estadísticas Git
        git_stats = self.obtener_estadisticas_git()
        resumen += f"""
## 🔄 Control de Versiones
- **Commits hoy**: {git_stats.get('commits_hoy', 'N/A')}
- **Último commit**: {git_stats.get('ultimo_commit', 'N/A')}

## 🤖 Próximas Acciones Sugeridas
- [ ] Revisar código con GitHub Copilot (`/work2027-code-review`)
- [ ] Optimizar scripts para automatización (`/work2027-optimize`)
- [ ] Generar documentación (`/work2027-document`)
- [ ] Sincronizar con Microsoft 365 Copilot

---
*Generado automáticamente por Work 2027 | Próxima sincronización: {(self.today + datetime.timedelta(days=1)).strftime('%d/%m/%Y %H:%M')}*
"""

        return resumen

    def guardar_log_diario(self, resumen: str) -> str:
        """Guarda el log diario en formato Markdown"""
        fecha_archivo = self.today.strftime("%Y-%m-%d")
        archivo_log = self.reports_path / f"LOG_WORK2027_{fecha_archivo}.md"

        print(f"💾 Guardando log diario: {archivo_log}")

        with open(archivo_log, 'w', encoding='utf-8') as f:
            f.write(resumen)

        return str(archivo_log)

    def sincronizar_onedrive(self) -> bool:
        """Sincroniza archivos con OneDrive"""
        print("🔄 Sincronizando con OneDrive...")

        try:
            # Copiar archivos Python modificados
            subprocess.run([
                "rsync", "-av",
                "--include=*.py", "--include=*.md", "--include=*.json",
                "--exclude=*",
                str(self.workspace_path) + "/",
                str(self.python_path) + "/"
            ], check=True)

            print("✅ Sincronización OneDrive completada")
            return True

        except subprocess.CalledProcessError as e:
            print(f"❌ Error en sincronización: {e}")
            return False

    def generar_comando_copilot_m365(self) -> str:
        """Genera el comando para Microsoft 365 Copilot"""
        fecha_str = self.today.strftime("%d/%m/%Y")

        comando = f"""@Copilot Microsoft 365, por favor:

1. 📁 Abre la carpeta OneDrive/Work2027/05_Finanzas_y_Documentos/Logs_Diarios/
2. 📄 Lee el archivo LOG_WORK2027_{self.today.strftime('%Y-%m-%d')}.md
3. 📊 Crea un documento Word profesional titulado "Informe Work 2027 - {fecha_str}"
4. 📈 Incluye gráficos de progreso si es posible
5. 💼 Guarda en OneDrive/Work2027/05_Finanzas_y_Documentos/Informes_Ejecutivos/

Contexto: Este es mi reporte diario de desarrollo automatizado Work 2027.
"""

        return comando

    def enviar_notificacion(self, archivo_log: str) -> bool:
        """Envía notificación por correo (opcional)"""
        # Esta función se puede implementar según las preferencias de correo
        print("📧 Notificación: Log diario generado exitosamente")
        print(f"📍 Ubicación: {archivo_log}")
        return True

    def ejecutar_workflow_completo(self) -> Dict[str, any]:
        """Ejecuta el workflow completo de generación de logs"""
        print("🚀 Iniciando Workflow Work 2027...")
        print(f"📅 Fecha: {self.today.strftime('%d/%m/%Y %H:%M:%S')}")

        # 1. Escanear cambios
        cambios = self.escanear_cambios_codigo()

        # 2. Generar resumen
        resumen = self.generar_resumen_copilot(cambios)

        # 3. Guardar log
        archivo_log = self.guardar_log_diario(resumen)

        # 4. Sincronizar OneDrive
        sync_ok = self.sincronizar_onedrive()

        # 5. Generar comando M365
        comando_m365 = self.generar_comando_copilot_m365()

        # 6. Enviar notificación
        notif_ok = self.enviar_notificacion(archivo_log)

        resultado = {
            "exito": True,
            "archivo_log": archivo_log,
            "cambios": cambios,
            "sincronizacion_onedrive": sync_ok,
            "notificacion": notif_ok,
            "comando_m365": comando_m365,
            "timestamp": self.today.isoformat()
        }

        print("✅ Workflow Work 2027 completado exitosamente!")
        print(f"📁 Log guardado en: {archivo_log}")
        print("\n🤖 COMANDO PARA MICROSOFT 365 COPILOT:")
        print("=" * 50)
        print(comando_m365)
        print("=" * 50)

        return resultado

def main():
    """Función principal"""
    print("🎯 WORK 2027 - GENERADOR DE LOGS DIARIOS")
    print("=" * 45)

    try:
        generator = Work2027LogGenerator()
        resultado = generator.ejecutar_workflow_completo()

        # Guardar resultado en JSON para procesamiento posterior
        json_path = generator.reports_path / f"resultado_{generator.today.strftime('%Y%m%d_%H%M%S')}.json"
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(resultado, f, indent=2, ensure_ascii=False)

        print(f"\n📊 Resultado guardado en: {json_path}")
        return 0

    except Exception as e:
        print(f"❌ Error en el workflow: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())