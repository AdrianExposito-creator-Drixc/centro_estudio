#!/usr/bin/env python3
"""
WORK 2027 - INTEGRACIÓN GITHUB AUTOMÁTICA
=========================================
Gestión automática de commits, push y sincronización con GitHub
Integrado con VS Code Copilot para control total por IA

Autor: Adrián Drix
Proyecto: Work 2027
Versión: 2.0 - GitHub Integration
"""

import os
import sys
import json
import datetime
import subprocess
import re
from pathlib import Path
from typing import Dict, List, Tuple, Optional

class Work2027GitHubIntegration:
    """Integración automática con GitHub para Work 2027"""

    def __init__(self):
        self.workspace_path = Path("/home/drixc/centro_estudio")
        self.today = datetime.datetime.now()
        self.onedrive_path = Path.home() / "OneDrive" / "Work2027"
        self.git_config_path = self.workspace_path / ".work2027_git_config.json"

        # Configuración por defecto
        self.default_config = {
            "auto_commit": True,
            "auto_push": True,
            "commit_message_template": "🚀 Work 2027: {tipo} - {fecha}",
            "branch_work2027": "work2027-auto",
            "commit_frequency": "daily",  # daily, hourly, on_change
            "files_to_track": [
                "*.py", "*.md", "*.json", "*.sh",
                ".vscode/settings.json", ".vscode/tasks.json"
            ],
            "exclude_patterns": [
                "__pycache__", "*.pyc", "node_modules",
                ".env", "*.log", "temp/", "resultado_*.json"
            ]
        }

        self.load_git_config()

    def load_git_config(self):
        """Carga la configuración Git personalizada"""
        if self.git_config_path.exists():
            with open(self.git_config_path, 'r', encoding='utf-8') as f:
                self.config = json.load(f)
        else:
            self.config = self.default_config.copy()
            self.save_git_config()

    def save_git_config(self):
        """Guarda la configuración Git"""
        with open(self.git_config_path, 'w', encoding='utf-8') as f:
            json.dump(self.config, f, indent=2, ensure_ascii=False)

    def verificar_repositorio_git(self) -> bool:
        """Verifica si el directorio es un repositorio Git"""
        try:
            result = subprocess.run([
                "git", "rev-parse", "--git-dir"
            ], capture_output=True, text=True, cwd=self.workspace_path)

            return result.returncode == 0
        except:
            return False

    def inicializar_repositorio(self) -> bool:
        """Inicializa repositorio Git si no existe"""
        if self.verificar_repositorio_git():
            return True

        try:
            print("🔧 Inicializando repositorio Git...")

            # Init
            subprocess.run([
                "git", "init"
            ], check=True, cwd=self.workspace_path)

            # Configurar usuario si no existe
            try:
                subprocess.run([
                    "git", "config", "user.name", "Work 2027 Auto"
                ], check=True, cwd=self.workspace_path)

                subprocess.run([
                    "git", "config", "user.email", "work2027@adriandrix.local"
                ], check=True, cwd=self.workspace_path)
            except:
                pass  # Usuario ya configurado

            # Crear .gitignore
            gitignore_content = """# Work 2027 - Auto Generated .gitignore
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
.venv/
.env
.env.local
.env.production
.env.development
venv/
ENV/

# IDEs
.vscode/launch.json
.idea/
*.swp
*.swo

# Work 2027 específicos
resultado_*.json
*.log
temp/
backup/

# Sistema
.DS_Store
Thumbs.db
"""

            gitignore_path = self.workspace_path / ".gitignore"
            if not gitignore_path.exists():
                with open(gitignore_path, 'w', encoding='utf-8') as f:
                    f.write(gitignore_content)

            print("✅ Repositorio Git inicializado")
            return True

        except subprocess.CalledProcessError as e:
            print(f"❌ Error inicializando Git: {e}")
            return False

    def obtener_archivos_modificados(self) -> List[str]:
        """Obtiene lista de archivos modificados"""
        try:
            # Archivos tracked modificados
            result = subprocess.run([
                "git", "diff", "--name-only", "HEAD"
            ], capture_output=True, text=True, cwd=self.workspace_path)

            modified = result.stdout.strip().split('\n') if result.stdout.strip() else []

            # Archivos untracked
            result = subprocess.run([
                "git", "ls-files", "--others", "--exclude-standard"
            ], capture_output=True, text=True, cwd=self.workspace_path)

            untracked = result.stdout.strip().split('\n') if result.stdout.strip() else []

            # Filtrar por patrones incluidos
            all_files = modified + untracked
            filtered_files = []

            for archivo in all_files:
                if not archivo:
                    continue

                # Verificar patrones de inclusión
                include = False
                for pattern in self.config["files_to_track"]:
                    if self.matches_pattern(archivo, pattern):
                        include = True
                        break

                # Verificar patrones de exclusión
                exclude = False
                for pattern in self.config["exclude_patterns"]:
                    if self.matches_pattern(archivo, pattern):
                        exclude = True
                        break

                if include and not exclude:
                    filtered_files.append(archivo)

            return filtered_files

        except subprocess.CalledProcessError:
            return []

    def matches_pattern(self, filepath: str, pattern: str) -> bool:
        """Verifica si un archivo coincide con un patrón"""
        if pattern.startswith("*."):
            extension = pattern[2:]
            return filepath.endswith(f".{extension}")
        elif pattern.endswith("/"):
            return filepath.startswith(pattern) or f"/{pattern}" in filepath
        else:
            return pattern in filepath

    def generar_mensaje_commit(self, archivos: List[str]) -> str:
        """Genera mensaje de commit automático inteligente"""
        fecha = self.today.strftime("%Y-%m-%d")

        # Analizar tipos de archivos
        tipos = {
            "python": sum(1 for f in archivos if f.endswith('.py')),
            "config": sum(1 for f in archivos if f.endswith('.json') or '.vscode' in f),
            "docs": sum(1 for f in archivos if f.endswith('.md')),
            "scripts": sum(1 for f in archivos if f.endswith('.sh')),
        }

        # Determinar tipo principal
        tipo_principal = max(tipos.items(), key=lambda x: x[1])[0]

        tipo_emoji = {
            "python": "🐍 Código Python",
            "config": "⚙️ Configuración",
            "docs": "📚 Documentación",
            "scripts": "🔧 Scripts"
        }

        mensaje_base = self.config["commit_message_template"].format(
            tipo=tipo_emoji.get(tipo_principal, "📝 Actualización"),
            fecha=fecha
        )

        # Añadir detalles
        detalles = []
        if tipos["python"] > 0:
            detalles.append(f"Python: {tipos['python']} archivos")
        if tipos["config"] > 0:
            detalles.append(f"Config: {tipos['config']} archivos")
        if tipos["docs"] > 0:
            detalles.append(f"Docs: {tipos['docs']} archivos")
        if tipos["scripts"] > 0:
            detalles.append(f"Scripts: {tipos['scripts']} archivos")

        if detalles:
            mensaje_completo = f"{mensaje_base}\n\n- {chr(10).join(['- ' + d for d in detalles])}"
        else:
            mensaje_completo = mensaje_base

        # Añadir info automática
        mensaje_completo += f"\n\n🤖 Auto-commit by Work 2027 | {self.today.strftime('%H:%M:%S')}"

        return mensaje_completo

    def ejecutar_commit_automatico(self) -> Dict[str, any]:
        """Ejecuta commit automático de archivos modificados"""
        resultado = {
            "exito": False,
            "archivos_committed": [],
            "mensaje_commit": "",
            "hash_commit": "",
            "error": None
        }

        try:
            # Obtener archivos modificados
            archivos = self.obtener_archivos_modificados()

            if not archivos:
                resultado["error"] = "No hay archivos para commitear"
                return resultado

            print(f"📝 Archivos para commit: {len(archivos)}")
            for archivo in archivos[:5]:  # Mostrar máximo 5
                print(f"   - {archivo}")
            if len(archivos) > 5:
                print(f"   - ... y {len(archivos) - 5} más")

            # Add archivos
            for archivo in archivos:
                subprocess.run([
                    "git", "add", archivo
                ], check=True, cwd=self.workspace_path)

            # Generar mensaje
            mensaje = self.generar_mensaje_commit(archivos)

            # Commit
            commit_result = subprocess.run([
                "git", "commit", "-m", mensaje
            ], capture_output=True, text=True, cwd=self.workspace_path)

            if commit_result.returncode == 0:
                # Obtener hash del commit
                hash_result = subprocess.run([
                    "git", "rev-parse", "HEAD"
                ], capture_output=True, text=True, cwd=self.workspace_path)

                resultado.update({
                    "exito": True,
                    "archivos_committed": archivos,
                    "mensaje_commit": mensaje,
                    "hash_commit": hash_result.stdout.strip()[:8],
                })

                print(f"✅ Commit exitoso: {resultado['hash_commit']}")
            else:
                resultado["error"] = commit_result.stderr

        except subprocess.CalledProcessError as e:
            resultado["error"] = str(e)

        return resultado

    def ejecutar_push_automatico(self) -> Dict[str, any]:
        """Ejecuta push automático al repositorio remoto"""
        resultado = {
            "exito": False,
            "branch": "",
            "commits_pushed": 0,
            "error": None
        }

        try:
            # Verificar si hay remote configurado
            remotes_result = subprocess.run([
                "git", "remote", "-v"
            ], capture_output=True, text=True, cwd=self.workspace_path)

            if not remotes_result.stdout.strip():
                resultado["error"] = "No hay repositorio remoto configurado"
                return resultado

            # Obtener branch actual
            branch_result = subprocess.run([
                "git", "branch", "--show-current"
            ], capture_output=True, text=True, cwd=self.workspace_path)

            current_branch = branch_result.stdout.strip()

            # Verificar commits pendientes
            commits_result = subprocess.run([
                "git", "log", "--oneline", f"origin/{current_branch}..HEAD"
            ], capture_output=True, text=True, cwd=self.workspace_path)

            commits_pendientes = commits_result.stdout.strip().split('\n') if commits_result.stdout.strip() else []

            if not commits_pendientes or commits_pendientes == ['']:
                resultado["error"] = "No hay commits pendientes para push"
                return resultado

            print(f"📤 Pushing {len(commits_pendientes)} commits a {current_branch}...")

            # Push
            push_result = subprocess.run([
                "git", "push", "origin", current_branch
            ], capture_output=True, text=True, cwd=self.workspace_path)

            if push_result.returncode == 0:
                resultado.update({
                    "exito": True,
                    "branch": current_branch,
                    "commits_pushed": len(commits_pendientes),
                })
                print(f"✅ Push exitoso: {len(commits_pendientes)} commits a {current_branch}")
            else:
                resultado["error"] = push_result.stderr

        except subprocess.CalledProcessError as e:
            resultado["error"] = str(e)

        return resultado

    def sincronizar_con_github(self) -> Dict[str, any]:
        """Ejecuta sincronización completa con GitHub"""
        resultado_final = {
            "timestamp": self.today.isoformat(),
            "repositorio_inicializado": False,
            "commit_resultado": {},
            "push_resultado": {},
            "resumen": ""
        }

        print("🔄 Iniciando sincronización GitHub Work 2027...")

        # 1. Verificar/inicializar repositorio
        if not self.verificar_repositorio_git():
            if self.inicializar_repositorio():
                resultado_final["repositorio_inicializado"] = True
            else:
                resultado_final["resumen"] = "❌ Error inicializando repositorio Git"
                return resultado_final

        # 2. Commit automático
        if self.config["auto_commit"]:
            resultado_final["commit_resultado"] = self.ejecutar_commit_automatico()

        # 3. Push automático
        if self.config["auto_push"] and resultado_final["commit_resultado"].get("exito", False):
            resultado_final["push_resultado"] = self.ejecutar_push_automatico()

        # 4. Generar resumen
        resumen_parts = []

        if resultado_final["commit_resultado"].get("exito"):
            archivos = len(resultado_final["commit_resultado"]["archivos_committed"])
            hash_commit = resultado_final["commit_resultado"]["hash_commit"]
            resumen_parts.append(f"✅ Commit: {archivos} archivos ({hash_commit})")

        if resultado_final["push_resultado"].get("exito"):
            commits = resultado_final["push_resultado"]["commits_pushed"]
            branch = resultado_final["push_resultado"]["branch"]
            resumen_parts.append(f"✅ Push: {commits} commits → {branch}")

        if not resumen_parts:
            resumen_parts.append("ℹ️ No hay cambios para sincronizar")

        resultado_final["resumen"] = " | ".join(resumen_parts)

        print(f"🎯 Sincronización completada: {resultado_final['resumen']}")

        return resultado_final

    def generar_comando_copilot(self, resultado: Dict) -> str:
        """Genera comando para GitHub Copilot Chat sobre la sincronización"""

        comando = f"""🤖 GitHub Copilot Chat - Resumen de Sincronización Work 2027

**Fecha**: {self.today.strftime('%d/%m/%Y %H:%M:%S')}

## 📊 Estado de Sincronización GitHub

"""

        if resultado["commit_resultado"].get("exito"):
            commit_info = resultado["commit_resultado"]
            comando += f"""### ✅ Commit Realizado
- **Hash**: {commit_info['hash_commit']}
- **Archivos**: {len(commit_info['archivos_committed'])}
- **Mensaje**: {commit_info['mensaje_commit'].split(chr(10))[0]}

"""

        if resultado["push_resultado"].get("exito"):
            push_info = resultado["push_resultado"]
            comando += f"""### ✅ Push Exitoso
- **Branch**: {push_info['branch']}
- **Commits enviados**: {push_info['commits_pushed']}

"""

        comando += f"""
## 🎯 Próximas Acciones Sugeridas

Para continuar con el desarrollo Work 2027, puedes usar estos comandos:

- `/work2027-summary` - Resumen del progreso actual
- `/work2027-code-review` - Revisar cambios recientes
- `/work2027-optimize` - Optimizar código para automatización
- `/work2027-document` - Actualizar documentación

## 🔄 Configuración Actual

- **Auto-commit**: {'✅' if self.config['auto_commit'] else '❌'}
- **Auto-push**: {'✅' if self.config['auto_push'] else '❌'}
- **Frecuencia**: {self.config['commit_frequency']}

¿Hay algo específico en lo que quieras que te ayude con el código sincronizado?"""

        return comando

def main():
    """Función principal"""
    print("🔗 WORK 2027 - INTEGRACIÓN GITHUB AUTOMÁTICA")
    print("=" * 50)

    try:
        git_integration = Work2027GitHubIntegration()
        resultado = git_integration.sincronizar_con_github()

        # Generar comando para Copilot
        comando_copilot = git_integration.generar_comando_copilot(resultado)

        # Guardar resultado
        result_path = git_integration.workspace_path / f"github_sync_result_{git_integration.today.strftime('%Y%m%d_%H%M%S')}.json"
        with open(result_path, 'w', encoding='utf-8') as f:
            json.dump(resultado, f, indent=2, ensure_ascii=False)

        print(f"\n📊 Resultado guardado en: {result_path}")
        print("\n" + "="*50)
        print("🤖 COMANDO PARA GITHUB COPILOT CHAT:")
        print("="*50)
        print(comando_copilot)
        print("="*50)

        return 0 if any(r.get("exito", False) for r in [resultado["commit_resultado"], resultado["push_resultado"]]) else 1

    except Exception as e:
        print(f"❌ Error en integración GitHub: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())