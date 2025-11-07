#!/usr/bin/env python3
"""
WORK 2027 - ANÁLISIS AUTOMÁTICO DE CÓDIGO
========================================
Análisis completo y métricas de calidad de código para Work 2027
Integrado con GitHub Copilot para sugerencias automáticas

Autor: Adrián Drix
Proyecto: Work 2027
Versión: 2.0 - Code Analysis
"""

import os
import sys
import json
import datetime
import subprocess
import ast
import re
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from collections import defaultdict

class Work2027CodeAnalyzer:
    """Analizador automático de código para Work 2027"""

    def __init__(self):
        self.workspace_path = Path("/home/drixc/centro_estudio")
        self.today = datetime.datetime.now()
        self.onedrive_path = Path.home() / "OneDrive" / "Work2027"
        self.analysis_path = self.onedrive_path / "03_Datos_y_Analytics" / "Code_Analysis"

        # Crear directorio de análisis
        self.analysis_path.mkdir(parents=True, exist_ok=True)

        # Métricas a calcular
        self.metrics = {
            "archivos_python": 0,
            "lineas_totales": 0,
            "lineas_codigo": 0,
            "lineas_comentarios": 0,
            "lineas_vacias": 0,
            "funciones_totales": 0,
            "clases_totales": 0,
            "imports_totales": 0,
            "complejidad_ciclomatica": 0,
            "duplicacion_codigo": 0,
            "cobertura_comentarios": 0.0,
            "archivos_con_errores": 0,
            "warnings_totales": 0
        }

        self.issues = []
        self.suggestions = []
        self.file_analysis = {}

    def buscar_archivos_python(self) -> List[Path]:
        """Busca todos los archivos Python en el workspace"""
        archivos = []

        for archivo in self.workspace_path.rglob("*.py"):
            # Excluir directorios comunes
            if any(excluded in str(archivo) for excluded in [
                "__pycache__", ".venv", "venv", "node_modules", ".git"
            ]):
                continue
            archivos.append(archivo)

        return archivos

    def analizar_archivo_python(self, archivo_path: Path) -> Dict[str, any]:
        """Analiza un archivo Python individual"""
        analisis = {
            "archivo": str(archivo_path.relative_to(self.workspace_path)),
            "tamaño_bytes": 0,
            "lineas_totales": 0,
            "lineas_codigo": 0,
            "lineas_comentarios": 0,
            "lineas_vacias": 0,
            "funciones": [],
            "clases": [],
            "imports": [],
            "complejidad": 0,
            "errores_sintaxis": [],
            "warnings": [],
            "sugerencias": []
        }

        try:
            # Leer archivo
            with open(archivo_path, 'r', encoding='utf-8') as f:
                contenido = f.read()
                lineas = contenido.split('\n')

            analisis["tamaño_bytes"] = len(contenido.encode('utf-8'))
            analisis["lineas_totales"] = len(lineas)

            # Análizar líneas
            for linea in lineas:
                linea_strip = linea.strip()
                if not linea_strip:
                    analisis["lineas_vacias"] += 1
                elif linea_strip.startswith('#'):
                    analisis["lineas_comentarios"] += 1
                else:
                    analisis["lineas_codigo"] += 1
                    # Buscar comentarios inline
                    if '#' in linea and not linea_strip.startswith('#'):
                        analisis["lineas_comentarios"] += 0.5

            # Análisis AST
            try:
                tree = ast.parse(contenido)
                analisis.update(self.analizar_ast(tree))
            except SyntaxError as e:
                analisis["errores_sintaxis"].append({
                    "linea": e.lineno,
                    "mensaje": str(e.msg),
                    "texto": e.text.strip() if e.text else ""
                })

            # Análisis de calidad
            analisis["warnings"].extend(self.verificar_calidad_codigo(contenido, lineas))
            analisis["sugerencias"].extend(self.generar_sugerencias(contenido, analisis))

        except Exception as e:
            analisis["errores_sintaxis"].append({
                "linea": 0,
                "mensaje": f"Error leyendo archivo: {str(e)}",
                "texto": ""
            })

        return analisis

    def analizar_ast(self, tree: ast.AST) -> Dict[str, any]:
        """Analiza el AST de un archivo Python"""
        resultado = {
            "funciones": [],
            "clases": [],
            "imports": [],
            "complejidad": 0
        }

        for nodo in ast.walk(tree):
            if isinstance(nodo, ast.FunctionDef):
                resultado["funciones"].append({
                    "nombre": nodo.name,
                    "linea": nodo.lineno,
                    "argumentos": len(nodo.args.args),
                    "decoradores": len(nodo.decorator_list),
                    "complejidad": self.calcular_complejidad_funcion(nodo)
                })
                resultado["complejidad"] += self.calcular_complejidad_funcion(nodo)

            elif isinstance(nodo, ast.ClassDef):
                resultado["clases"].append({
                    "nombre": nodo.name,
                    "linea": nodo.linea,
                    "metodos": len([n for n in nodo.body if isinstance(n, ast.FunctionDef)]),
                    "decoradores": len(nodo.decorator_list)
                })

            elif isinstance(nodo, (ast.Import, ast.ImportFrom)):
                if isinstance(nodo, ast.Import):
                    for alias in nodo.names:
                        resultado["imports"].append({
                            "tipo": "import",
                            "modulo": alias.name,
                            "alias": alias.asname,
                            "linea": nodo.lineno
                        })
                else:  # ImportFrom
                    for alias in nodo.names:
                        resultado["imports"].append({
                            "tipo": "from_import",
                            "modulo": nodo.module,
                            "nombre": alias.name,
                            "alias": alias.asname,
                            "linea": nodo.lineno
                        })

        return resultado

    def calcular_complejidad_funcion(self, nodo: ast.FunctionDef) -> int:
        """Calcula la complejidad ciclomática de una función"""
        complejidad = 1  # Complejidad base

        for subnodo in ast.walk(nodo):
            if isinstance(subnodo, (ast.If, ast.While, ast.For, ast.Try)):
                complejidad += 1
            elif isinstance(subnodo, ast.BoolOp):
                complejidad += len(subnodo.values) - 1

        return complejidad

    def verificar_calidad_codigo(self, contenido: str, lineas: List[str]) -> List[Dict]:
        """Verifica problemas de calidad en el código"""
        warnings = []

        # Líneas muy largas (>100 caracteres)
        for i, linea in enumerate(lineas, 1):
            if len(linea) > 100:
                warnings.append({
                    "tipo": "linea_larga",
                    "linea": i,
                    "mensaje": f"Línea muy larga ({len(linea)} caracteres)",
                    "severidad": "warning"
                })

        # Funciones sin docstring
        func_pattern = re.compile(r'def\s+(\w+)\s*\([^)]*\):')
        for i, linea in enumerate(lineas):
            if func_pattern.match(linea.strip()):
                # Verificar si la siguiente línea no vacía es un docstring
                siguiente_codigo = None
                for j in range(i+1, min(i+3, len(lineas))):
                    if lineas[j].strip():
                        siguiente_codigo = lineas[j].strip()
                        break

                if not (siguiente_codigo and siguiente_codigo.startswith(('"""', "'''", 'r"""', "r'''"))):
                    func_name = func_pattern.match(linea.strip()).group(1)
                    if not func_name.startswith('_'):  # Ignorar funciones privadas
                        warnings.append({
                            "tipo": "sin_docstring",
                            "linea": i+1,
                            "mensaje": f"Función '{func_name}' sin docstring",
                            "severidad": "info"
                        })

        # Variables con nombres poco descriptivos
        var_pattern = re.compile(r'\b([a-z])\s*=')
        for i, linea in enumerate(lineas, 1):
            matches = var_pattern.findall(linea)
            for var in matches:
                if var in ['i', 'j', 'k']:  # Excepciones comunes para loops
                    continue
                warnings.append({
                    "tipo": "variable_poco_descriptiva",
                    "linea": i,
                    "mensaje": f"Variable '{var}' tiene nombre poco descriptivo",
                    "severidad": "info"
                })

        return warnings

    def generar_sugerencias(self, contenido: str, analisis: Dict) -> List[Dict]:
        """Genera sugerencias de mejora para el código"""
        sugerencias = []

        # Sugerencias basadas en métricas
        if analisis["lineas_codigo"] > 200:
            sugerencias.append({
                "tipo": "archivo_grande",
                "mensaje": "Archivo muy grande. Considera dividirlo en módulos más pequeños.",
                "prioridad": "media"
            })

        if len(analisis["funciones"]) > 15:
            sugerencias.append({
                "tipo": "muchas_funciones",
                "mensaje": "Muchas funciones en un archivo. Considera crear una clase o dividir el módulo.",
                "prioridad": "baja"
            })

        # Sugerencias de complejidad
        for func in analisis["funciones"]:
            if func["complejidad"] > 10:
                sugerencias.append({
                    "tipo": "complejidad_alta",
                    "mensaje": f"Función '{func['nombre']}' tiene alta complejidad ({func['complejidad']}). Considera refactorizar.",
                    "prioridad": "alta"
                })

        # Sugerencias de imports
        imports_externos = [imp for imp in analisis["imports"] if not imp["modulo"].startswith('.')]
        if len(imports_externos) > 20:
            sugerencias.append({
                "tipo": "muchos_imports",
                "mensaje": "Muchos imports externos. Revisa si todos son necesarios.",
                "prioridad": "baja"
            })

        return sugerencias

    def ejecutar_analisis_completo(self) -> Dict[str, any]:
        """Ejecuta análisis completo del workspace"""
        print("🔍 Iniciando análisis completo de código Work 2027...")

        archivos_python = self.buscar_archivos_python()
        self.metrics["archivos_python"] = len(archivos_python)

        print(f"📁 Archivos Python encontrados: {len(archivos_python)}")

        # Analizar cada archivo
        for archivo in archivos_python:
            print(f"   🔍 Analizando: {archivo.name}")
            analisis = self.analizar_archivo_python(archivo)
            self.file_analysis[str(archivo.relative_to(self.workspace_path))] = analisis

            # Actualizar métricas globales
            self.metrics["lineas_totales"] += analisis["lineas_totales"]
            self.metrics["lineas_codigo"] += analisis["lineas_codigo"]
            self.metrics["lineas_comentarios"] += int(analisis["lineas_comentarios"])
            self.metrics["lineas_vacias"] += analisis["lineas_vacias"]
            self.metrics["funciones_totales"] += len(analisis["funciones"])
            self.metrics["clases_totales"] += len(analisis["clases"])
            self.metrics["imports_totales"] += len(analisis["imports"])
            self.metrics["complejidad_ciclomatica"] += analisis["complejidad"]

            if analisis["errores_sintaxis"]:
                self.metrics["archivos_con_errores"] += 1

            self.metrics["warnings_totales"] += len(analisis["warnings"])

            # Recopilar issues y sugerencias
            for error in analisis["errores_sintaxis"]:
                self.issues.append({
                    "archivo": analisis["archivo"],
                    "tipo": "error_sintaxis",
                    "linea": error["linea"],
                    "mensaje": error["mensaje"],
                    "severidad": "error"
                })

            for warning in analisis["warnings"]:
                self.issues.append({
                    "archivo": analisis["archivo"],
                    "tipo": warning["tipo"],
                    "linea": warning["linea"],
                    "mensaje": warning["mensaje"],
                    "severidad": warning["severidad"]
                })

            for sugerencia in analisis["sugerencias"]:
                self.suggestions.append({
                    "archivo": analisis["archivo"],
                    "tipo": sugerencia["tipo"],
                    "mensaje": sugerencia["mensaje"],
                    "prioridad": sugerencia["prioridad"]
                })

        # Calcular métricas derivadas
        if self.metrics["lineas_totales"] > 0:
            self.metrics["cobertura_comentarios"] = (
                self.metrics["lineas_comentarios"] / self.metrics["lineas_totales"]
            ) * 100

        # Generar resumen
        resultado = {
            "timestamp": self.today.isoformat(),
            "metricas": self.metrics,
            "archivos_analizados": list(self.file_analysis.keys()),
            "issues_totales": len(self.issues),
            "sugerencias_totales": len(self.suggestions),
            "calidad_general": self.calcular_calidad_general(),
            "top_issues": self.get_top_issues(),
            "top_sugerencias": self.get_top_suggestions()
        }

        print("✅ Análisis completado")
        return resultado

    def calcular_calidad_general(self) -> Dict[str, any]:
        """Calcula una puntuación de calidad general"""
        puntuacion = 100

        # Penalizaciones
        if self.metrics["archivos_con_errores"] > 0:
            puntuacion -= min(30, self.metrics["archivos_con_errores"] * 10)

        if self.metrics["warnings_totales"] > 0:
            puntuacion -= min(20, self.metrics["warnings_totales"] * 2)

        if self.metrics["cobertura_comentarios"] < 20:
            puntuacion -= 15

        if self.metrics["complejidad_ciclomatica"] / max(1, self.metrics["funciones_totales"]) > 5:
            puntuacion -= 10

        # Clasificar calidad
        if puntuacion >= 80:
            calidad = "Excelente"
        elif puntuacion >= 60:
            calidad = "Buena"
        elif puntuacion >= 40:
            calidad = "Regular"
        else:
            calidad = "Necesita mejoras"

        return {
            "puntuacion": max(0, puntuacion),
            "clasificacion": calidad,
            "factores_positivos": self.get_factores_positivos(),
            "areas_mejora": self.get_areas_mejora()
        }

    def get_factores_positivos(self) -> List[str]:
        """Identifica factores positivos del código"""
        factores = []

        if self.metrics["archivos_con_errores"] == 0:
            factores.append("Sin errores de sintaxis")

        if self.metrics["cobertura_comentarios"] > 25:
            factores.append("Buena cobertura de comentarios")

        if self.metrics["funciones_totales"] > self.metrics["clases_totales"] * 3:
            factores.append("Buen uso de funciones vs clases")

        if self.metrics["complejidad_ciclomatica"] / max(1, self.metrics["funciones_totales"]) < 3:
            factores.append("Baja complejidad promedio")

        return factores

    def get_areas_mejora(self) -> List[str]:
        """Identifica áreas de mejora principales"""
        areas = []

        if self.metrics["archivos_con_errores"] > 0:
            areas.append(f"Corregir {self.metrics['archivos_con_errores']} archivos con errores")

        if self.metrics["warnings_totales"] > 10:
            areas.append("Reducir warnings de calidad de código")

        if self.metrics["cobertura_comentarios"] < 15:
            areas.append("Mejorar documentación y comentarios")

        return areas

    def get_top_issues(self, limite: int = 5) -> List[Dict]:
        """Obtiene los issues más críticos"""
        # Ordenar por severidad: error > warning > info
        severidad_orden = {"error": 3, "warning": 2, "info": 1}

        issues_ordenados = sorted(
            self.issues,
            key=lambda x: severidad_orden.get(x["severidad"], 0),
            reverse=True
        )

        return issues_ordenados[:limite]

    def get_top_suggestions(self, limite: int = 5) -> List[Dict]:
        """Obtiene las sugerencias más importantes"""
        # Ordenar por prioridad: alta > media > baja
        prioridad_orden = {"alta": 3, "media": 2, "baja": 1}

        sugerencias_ordenadas = sorted(
            self.suggestions,
            key=lambda x: prioridad_orden.get(x["prioridad"], 0),
            reverse=True
        )

        return sugerencias_ordenadas[:limite]

    def generar_reporte_detallado(self, resultado: Dict) -> str:
        """Genera reporte detallado en formato Markdown"""
        fecha_str = self.today.strftime("%d/%m/%Y %H:%M:%S")

        reporte = f"""# 🔍 ANÁLISIS DE CÓDIGO WORK 2027

**Fecha**: {fecha_str}
**Generado por**: Work 2027 Code Analyzer

## 📊 Métricas Generales

| Métrica | Valor |
|---------|-------|
| **Archivos Python** | {resultado['metricas']['archivos_python']} |
| **Líneas totales** | {resultado['metricas']['lineas_totales']:,} |
| **Líneas de código** | {resultado['metricas']['lineas_codigo']:,} |
| **Líneas comentarios** | {resultado['metricas']['lineas_comentarios']:,} |
| **Funciones** | {resultado['metricas']['funciones_totales']} |
| **Clases** | {resultado['metricas']['clases_totales']} |
| **Complejidad total** | {resultado['metricas']['complejidad_ciclomatica']} |

## 🎯 Calidad General

**Puntuación**: {resultado['calidad_general']['puntuacion']}/100 ⭐ {resultado['calidad_general']['clasificacion']}

### ✅ Factores Positivos
"""

        for factor in resultado['calidad_general']['factores_positivos']:
            reporte += f"- {factor}\n"

        reporte += "\n### 🔧 Áreas de Mejora\n"
        for area in resultado['calidad_general']['areas_mejora']:
            reporte += f"- {area}\n"

        reporte += f"""
## 🚨 Issues Críticos ({resultado['issues_totales']} total)

"""

        for issue in resultado['top_issues']:
            emoji = {"error": "❌", "warning": "⚠️", "info": "ℹ️"}
            reporte += f"### {emoji.get(issue['severidad'], '📌')} {issue['archivo']}:{issue['linea']}\n"
            reporte += f"**{issue['tipo']}**: {issue['mensaje']}\n\n"

        reporte += f"""
## 💡 Sugerencias de Mejora ({resultado['sugerencias_totales']} total)

"""

        for sugerencia in resultado['top_sugerencias']:
            emoji = {"alta": "🔴", "media": "🟡", "baja": "🟢"}
            reporte += f"### {emoji.get(sugerencia['prioridad'], '📌')} {sugerencia['archivo']}\n"
            reporte += f"**{sugerencia['tipo']}**: {sugerencia['mensaje']}\n\n"

        reporte += f"""
## 📈 Distribución del Código

- **Código**: {resultado['metricas']['lineas_codigo']:,} líneas ({(resultado['metricas']['lineas_codigo']/max(1,resultado['metricas']['lineas_totales']))*100:.1f}%)
- **Comentarios**: {resultado['metricas']['lineas_comentarios']:,} líneas ({resultado['metricas']['cobertura_comentarios']:.1f}%)
- **Líneas vacías**: {resultado['metricas']['lineas_vacias']:,} líneas

## 🎯 Próximas Acciones Recomendadas

1. **Corregir errores críticos** identificados en el análisis
2. **Implementar sugerencias** de alta prioridad
3. **Mejorar documentación** donde sea necesario
4. **Refactorizar funciones** con alta complejidad
5. **Ejecutar análisis regularmente** para mantener calidad

---
*Generado automáticamente por Work 2027 Code Analyzer*
"""

        return reporte

    def guardar_resultados(self, resultado: Dict, reporte: str) -> Tuple[str, str]:
        """Guarda los resultados del análisis"""
        timestamp = self.today.strftime("%Y%m%d_%H%M%S")

        # Guardar JSON con datos completos
        json_path = self.analysis_path / f"analisis_codigo_{timestamp}.json"
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump({
                "resultado": resultado,
                "analisis_detallado": self.file_analysis,
                "issues_completos": self.issues,
                "sugerencias_completas": self.suggestions
            }, f, indent=2, ensure_ascii=False)

        # Guardar reporte Markdown
        md_path = self.analysis_path / f"reporte_calidad_{timestamp}.md"
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(reporte)

        return str(json_path), str(md_path)

def main():
    """Función principal"""
    print("🔍 WORK 2027 - ANÁLISIS AUTOMÁTICO DE CÓDIGO")
    print("=" * 50)

    try:
        analyzer = Work2027CodeAnalyzer()
        resultado = analyzer.ejecutar_analisis_completo()
        reporte = analyzer.generar_reporte_detallado(resultado)

        json_path, md_path = analyzer.guardar_resultados(resultado, reporte)

        print(f"\n📊 Análisis completado:")
        print(f"- Archivos analizados: {resultado['metricas']['archivos_python']}")
        print(f"- Calidad general: {resultado['calidad_general']['puntuacion']}/100 ({resultado['calidad_general']['clasificacion']})")
        print(f"- Issues encontrados: {resultado['issues_totales']}")
        print(f"- Sugerencias generadas: {resultado['sugerencias_totales']}")

        print(f"\n📁 Resultados guardados:")
        print(f"- JSON: {json_path}")
        print(f"- Reporte: {md_path}")

        print(f"\n🤖 Para GitHub Copilot Chat:")
        print("Usa el comando: /work2027-analyze")
        print("O solicita: 'Revisa el último análisis de código Work 2027'")

        return 0

    except Exception as e:
        print(f"❌ Error en análisis: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())