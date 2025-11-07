#!/bin/bash
# ==========================================
# 📚 EXPANSIÓN MOUREDEV PRO → 30 DAYS OF PYTHON
# Integra la estructura completa de 30 módulos
# Autor: Adrián Expósito Carrasquilla (WORK 2027)
# ==========================================

set -e

BASE_DIR=~/centro_estudio/mouredev_pro

echo "🚀 Expandiendo contenedor MoureDev Pro a 30 módulos..."
echo ""

# === MÓDULOS 02-30 (el 01 ya existe) ===
declare -A MODULOS=(
    ["02"]="variables_y_funciones|Variables, Built-in Functions"
    ["03"]="operadores|Operators (Aritméticos, Lógicos, Comparación)"
    ["04"]="strings|Strings (Métodos, Formateo, Slicing)"
    ["05"]="listas|Lists (Creación, Métodos, Comprensión)"
    ["06"]="tuplas|Tuples (Inmutabilidad, Desempaquetado)"
    ["07"]="sets|Sets (Operaciones, Métodos)"
    ["08"]="diccionarios|Dictionaries (Claves, Valores, Métodos)"
    ["09"]="condicionales|Conditionals (if/elif/else)"
    ["10"]="bucles|Loops (for, while, range)"
    ["11"]="funciones|Functions (def, return, parámetros)"
    ["12"]="modulos|Modules (import, creación de módulos)"
    ["13"]="list_comprehension|List Comprehension"
    ["14"]="funciones_orden_superior|Higher Order Functions (map, filter, reduce)"
    ["15"]="errores_excepciones|Errors & Exceptions (try/except)"
    ["16"]="datetime|DateTime (Fechas, Tiempo, Formateo)"
    ["17"]="manejo_archivos|File Handling (open, read, write)"
    ["18"]="expresiones_regulares|Regular Expressions (regex)"
    ["19"]="manejo_json|File Handling JSON"
    ["20"]="pip|Python Package Manager (pip)"
    ["21"]="clases_objetos|Classes and Objects (POO Básica)"
    ["22"]="web_scraping|Web Scraping (requests, BeautifulSoup)"
    ["23"]="entornos_virtuales|Virtual Environments (venv)"
    ["24"]="estadisticas|Statistics (mean, median, mode)"
    ["25"]="pandas|Pandas (DataFrames, Series)"
    ["26"]="python_web|Python Web (Flask básico)"
    ["27"]="mongodb|MongoDB with Python"
    ["28"]="api|API (Construcción básica)"
    ["29"]="construccion_api|Building API (avanzado)"
    ["30"]="proyecto_final|Final Project (Integración completa)"
)

# Crear estructura para cada módulo
for num in {02..30}; do
    # Extraer nombre y descripción
    info="${MODULOS[$num]}"
    nombre=$(echo "$info" | cut -d'|' -f1)
    descripcion=$(echo "$info" | cut -d'|' -f2)

    modulo_dir="$BASE_DIR/${num}_${nombre}"

    # Crear directorio si no existe
    if [[ ! -d "$modulo_dir" ]]; then
        mkdir -p "$modulo_dir"
        echo "📁 Creado: ${num}_${nombre}/"

        # Crear archivos base
        touch "$modulo_dir/ejercicios_sesion_${num}_${nombre}.py"
        touch "$modulo_dir/notas_${num}_${nombre}.md"
        touch "$modulo_dir/dudas_y_refuerzo.md"

        # Añadir header al archivo Python
        cat > "$modulo_dir/ejercicios_sesion_${num}_${nombre}.py" << EOF
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ==========================================
# SESIÓN ${num} - MoureDev Pro / 30 Days of Python
# Tema: ${descripcion}
# Autor: Adrián Expósito Carrasquilla
# Fecha: $(date +"%d de %B de %Y")
# ==========================================

"""
📚 Módulo ${num}: ${descripcion}

Ejercicios y práctica del tema.
"""

# TODO: Añadir ejercicios después de ver la clase

if __name__ == "__main__":
    print("🧠 Módulo ${num}: ${descripcion}")
    print("⚠️  Pendiente de completar tras la clase")
EOF

        # Añadir header al archivo de notas
        cat > "$modulo_dir/notas_${num}_${nombre}.md" << EOF
# 📝 Notas del Módulo ${num} - ${descripcion}

**Fecha:** Pendiente
**Autor:** Adrián Expósito Carrasquilla
**Curso:** MoureDev Pro - Python desde cero

---

## ✅ Conceptos aprendidos

*(A completar después de la clase)*

---

## 🎯 Ejercicios completados

*(Listado de ejercicios realizados)*

---

## 📌 Puntos clave a recordar

*(Conceptos importantes del módulo)*

---

## 🔄 Próximo módulo

**Día $((10#$num + 1))**

---

> 💡 **Nota personal:** Pendiente de clase y práctica.
EOF

        # Añadir template al archivo de dudas
        cat > "$modulo_dir/dudas_y_refuerzo.md" << EOF
# 🔍 Dudas y Refuerzo - Módulo ${num}

**Fecha:** Pendiente
**Estado:** ⏳ No iniciado

---

## ❓ Dudas durante el módulo

*(A registrar durante la clase)*

---

## 🧠 Conceptos a reforzar

*(Conceptos que requieren práctica adicional)*

---

## 📚 Ejercicios adicionales recomendados

*(Práctica extra sugerida)*

---

## 🎯 Nivel de comprensión

| Concepto | Nivel |
|----------|-------|
| Pendiente | ⭐⭐⭐⭐⭐ |

---

> 💬 **Para revisar más adelante:** Pendiente de clase.
EOF

    else
        echo "⏭️  Saltado: ${num}_${nombre}/ (ya existe)"
    fi
done

echo ""
echo "✅ Expansión completada"
echo ""
echo "📂 Estructura completa en: $BASE_DIR"
echo ""
echo "🎯 Próximos pasos:"
echo "   1. Completa cada módulo tras ver la clase correspondiente"
echo "   2. Ejecuta sync_notas_mouredev.sh para sincronizar con Notion"
echo "   3. Usa el dashboard de progreso para seguimiento"
echo ""
