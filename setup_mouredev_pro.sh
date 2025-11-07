#!/bin/bash

# ================================================
# 🚀 SCRIPT DE CONFIGURACIÓN MOUREDEV PRO
# ================================================
# Automatiza la organización del entorno de estudio
# para el curso de Python de MoureDev Pro
#
# Autor: Adrián
# Fecha: $(date +"%d/%m/%Y")
# ================================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directorio base
BASE_DIR="$HOME/centro_estudio/mouredev_pro"

echo -e "${CYAN}================================================"
echo -e "🚀 CONFIGURACIÓN AUTOMÁTICA MOUREDEV PRO"
echo -e "================================================${NC}"

# Función para mostrar progreso
show_progress() {
    echo -e "${GREEN}✅ $1${NC}"
}

show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

show_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Crear directorio base si no existe
if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
    show_progress "Directorio base creado: $BASE_DIR"
fi

cd "$BASE_DIR" || exit

# Array con información de las sesiones
declare -A SESIONES
SESIONES=(
    ["01_hola_mundo"]="Introducción a Python y primer programa"
    ["02_variables"]="Variables, tipos de datos y conversiones"
    ["03_operadores"]="Operadores aritméticos, lógicos y de comparación"
    ["04_strings"]="Cadenas de texto y métodos de string"
    ["05_listas"]="Listas, métodos y operaciones"
    ["06_tuplas"]="Tuplas e inmutabilidad"
    ["07_sets"]="Conjuntos y operaciones de conjunto"
    ["08_diccionarios"]="Diccionarios, claves y valores"
    ["09_condicionales"]="Estructuras condicionales if/elif/else"
    ["10_bucles"]="Bucles for y while"
    ["11_funciones"]="Definición y uso de funciones"
    ["12_modulos"]="Importación y creación de módulos"
    ["13_list_comprehension"]="Comprensión de listas"
    ["14_funciones_orden_superior"]="Funciones lambda y de orden superior"
    ["15_errores_excepciones"]="Manejo de errores y excepciones"
    ["16_datetime"]="Fechas y tiempo"
    ["17_manejo_archivos"]="Lectura y escritura de archivos"
    ["18_expresiones_regulares"]="Regex y patrones"
    ["19_manejo_json"]="Trabajar con JSON"
    ["20_pip"]="Gestor de paquetes pip"
    ["21_clases_objetos"]="Programación orientada a objetos"
    ["22_web_scraping"]="Extracción de datos web"
    ["23_entornos_virtuales"]="Gestión de entornos virtuales"
    ["24_estadisticas"]="Análisis estadístico básico"
    ["25_pandas"]="Manipulación de datos con Pandas"
    ["26_python_web"]="Desarrollo web con Python"
    ["27_mongodb"]="Base de datos MongoDB"
    ["28_api"]="Consumo de APIs"
    ["29_construccion_api"]="Construcción de APIs"
    ["30_proyecto_final"]="Proyecto final integrador"
)

echo -e "${PURPLE}🏗️  Creando estructura de carpetas...${NC}"

# Crear estructura de carpetas
for sesion in "${!SESIONES[@]}"; do
    if [ ! -d "$sesion" ]; then
        mkdir -p "$sesion"
        show_progress "Carpeta creada: $sesion"
    else
        show_info "Carpeta ya existe: $sesion"
    fi
done

echo -e "\n${PURPLE}📝 Generando archivos de notas y ejercicios...${NC}"

# Función para crear archivo de notas
create_notas_file() {
    local sesion=$1
    local descripcion=$2
    local numero=$(echo $sesion | grep -o '[0-9]\+')
    local tema=$(echo $sesion | sed 's/[0-9]*_//')
    local archivo="$sesion/notas_$sesion.md"

    if [ ! -f "$archivo" ]; then
        cat > "$archivo" << EOF
# 📘 Sesión $numero – $(echo $tema | tr '_' ' ' | sed 's/\b\w/\u&/g')

## 📚 Conceptos clave
$descripcion

## 🎯 Objetivos de aprendizaje
- [ ] Concepto principal 1
- [ ] Concepto principal 2
- [ ] Aplicación práctica

## 💡 Puntos importantes
- **Concepto clave**: Explicación breve
- **Sintaxis**: Ejemplos de código
- **Casos de uso**: Cuándo utilizar

## ⚠️ Errores comunes
- Error típico 1: Explicación
- Error típico 2: Explicación

## 🧪 Mini test de repaso
1. Pregunta conceptual 1
2. Pregunta práctica 2
3. Pregunta de aplicación 3

## 🔗 Enlaces útiles
- [Documentación oficial Python](https://docs.python.org/3/)
- [MoureDev - Curso Python](https://mouredev.pro)
- [Ejercicios adicionales](https://github.com/mouredev/Hello-Python)

---

### 💬 Notas personales (Adrián)
- [ ] Revisar conceptos básicos
- [ ] Practicar ejercicios
- [ ] Implementar ejemplo propio

*Última actualización: $(date +"%d/%m/%Y")*
EOF
        show_progress "Notas creadas: $archivo"
    else
        show_info "Notas ya existen: $archivo"
    fi
}

# Función para crear archivo de dudas y refuerzo
create_dudas_file() {
    local sesion=$1
    local numero=$(echo $sesion | grep -o '[0-9]\+')
    local tema=$(echo $sesion | sed 's/[0-9]*_//')
    local archivo="$sesion/dudas_y_refuerzo.md"

    if [ ! -f "$archivo" ]; then
        cat > "$archivo" << EOF
# 🧩 Dudas y refuerzos – $(echo $tema | tr '_' ' ' | sed 's/\b\w/\u&/g')

## 🤔 Conceptos a reforzar
- Concepto que necesita más práctica
- Diferencias entre conceptos similares
- Aplicaciones prácticas

## 🔄 Ejercicios de refuerzo
### Ejercicio 1: Básico
\`\`\`python
# TODO: Implementar ejercicio básico
pass
\`\`\`

### Ejercicio 2: Intermedio
\`\`\`python
# TODO: Implementar ejercicio intermedio
pass
\`\`\`

### Ejercicio 3: Avanzado
\`\`\`python
# TODO: Implementar ejercicio avanzado
pass
\`\`\`

## ❓ Dudas pendientes
1. Duda específica 1
2. Duda específica 2
3. Duda específica 3

## 🎯 Plan de refuerzo
- [ ] Repasar teoría básica
- [ ] Completar ejercicios adicionales
- [ ] Buscar ejemplos alternativos
- [ ] Practicar en proyectos personales

## 📝 Notas de errores
### Error encontrado:
**Descripción**:
**Solución**:
**Fecha**: $(date +"%d/%m/%Y")

---

*Registro de dudas y refuerzos - Sesión $numero*
EOF
        show_progress "Dudas creadas: $archivo"
    else
        show_info "Dudas ya existen: $archivo"
    fi
}

# Función para crear archivo de ejercicios
create_ejercicios_file() {
    local sesion=$1
    local numero=$(echo $sesion | grep -o '[0-9]\+')
    local tema=$(echo $sesion | sed 's/[0-9]*_//')
    local archivo="$sesion/ejercicios_sesion_$sesion.py"

    if [ ! -f "$archivo" ]; then
        cat > "$archivo" << 'EOF'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Ejercicios de la Sesión XX - TEMA
Curso: MoureDev Pro - Python desde cero
Autor: Adrián
Fecha: FECHA_ACTUAL
"""

# ================================================
# EJERCICIOS SESIÓN XX - TEMA
# ================================================

def main():
    """Función principal que ejecuta todos los ejercicios"""
    print("=" * 50)
    print(f"🐍 EJERCICIOS SESIÓN XX - TEMA")
    print("=" * 50)

    # TODO: Implementar ejercicios específicos de la sesión

    # Ejercicio 1: Descripción
    print("\n📝 Ejercicio 1:")
    ejercicio_1()

    # Ejercicio 2: Descripción
    print("\n📝 Ejercicio 2:")
    ejercicio_2()

    # Ejercicio 3: Descripción
    print("\n📝 Ejercicio 3:")
    ejercicio_3()

    print("\n✅ Todos los ejercicios completados")

def ejercicio_1():
    """Descripción del ejercicio 1"""
    # TODO: Implementar ejercicio 1
    pass

def ejercicio_2():
    """Descripción del ejercicio 2"""
    # TODO: Implementar ejercicio 2
    pass

def ejercicio_3():
    """Descripción del ejercicio 3"""
    # TODO: Implementar ejercicio 3
    pass

# ================================================
# FUNCIONES DE APOYO
# ================================================

def mostrar_resultado(titulo, resultado):
    """Función auxiliar para mostrar resultados"""
    print(f"🔹 {titulo}: {resultado}")

def separador():
    """Imprime una línea separadora"""
    print("-" * 30)

# ================================================
# EJECUCIÓN PRINCIPAL
# ================================================

if __name__ == "__main__":
    main()
EOF

        # Reemplazar placeholders con datos reales
        sed -i "s/XX/$numero/g" "$archivo"
        sed -i "s/TEMA/$(echo $tema | tr '_' ' ' | sed 's/\b\w/\u&/g')/g" "$archivo"
        sed -i "s/FECHA_ACTUAL/$(date +"%d\/%m\/%Y")/g" "$archivo"

        show_progress "Ejercicios creados: $archivo"
    else
        show_info "Ejercicios ya existen: $archivo"
    fi
}

# Generar archivos para todas las sesiones
for sesion in "${!SESIONES[@]}"; do
    descripcion="${SESIONES[$sesion]}"

    create_notas_file "$sesion" "$descripcion"
    create_dudas_file "$sesion"
    create_ejercicios_file "$sesion"
done

# Crear o actualizar README principal
echo -e "\n${PURPLE}📄 Actualizando README principal...${NC}"

cat > "README_mouredev_pro.md" << EOF
# 🐍 MoureDev Pro - Python desde Cero

## 📚 Resumen del Curso
Curso completo de Python desde los fundamentos hasta proyectos avanzados, siguiendo la metodología de MoureDev Pro.

## 🗂️ Estructura de Sesiones

| Sesión | Tema | Estado | Archivos |
|--------|------|--------|----------|
EOF

# Agregar información de cada sesión al README
for i in {01..30}; do
    # Buscar la sesión correspondiente
    for sesion in "${!SESIONES[@]}"; do
        numero=$(echo $sesion | grep -o '[0-9]\+')
        if [ "$numero" = "$i" ]; then
            descripcion="${SESIONES[$sesion]}"
            tema=$(echo $sesion | sed 's/[0-9]*_//' | tr '_' ' ' | sed 's/\b\w/\u&/g')

            # Verificar si existen archivos
            if [ -f "$sesion/ejercicios_sesion_$sesion.py" ]; then
                estado="🟢 Configurado"
            else
                estado="⚪ Pendiente"
            fi

            echo "| $i | $tema | $estado | \`ejercicios_sesion_$sesion.py\`, \`notas_$sesion.md\`, \`dudas_y_refuerzo.md\` |" >> "README_mouredev_pro.md"
            break
        fi
    done
done

cat >> "README_mouredev_pro.md" << EOF

## 🚀 Cómo usar este entorno

### 1. Estructura de cada sesión
Cada carpeta contiene:
- **\`ejercicios_sesion_XX.py\`**: Ejercicios prácticos de la sesión
- **\`notas_XX.md\`**: Resumen teórico y conceptos clave
- **\`dudas_y_refuerzo.md\`**: Registro de dudas y ejercicios adicionales

### 2. Flujo de trabajo recomendado
1. 📖 Leer las notas teóricas
2. 💻 Completar los ejercicios prácticos
3. 📝 Anotar dudas en el archivo correspondiente
4. 🔄 Reforzar conceptos con ejercicios adicionales

### 3. Sincronización con Notion
Para mantener el progreso actualizado:
- Usar el script \`sync_notas_mouredev.sh\`
- Actualizar la tabla de progreso en Notion
- Marcar sesiones completadas

## 🔧 Scripts de automatización
- **\`setup_mouredev_pro.sh\`**: Configuración inicial del entorno
- **\`sync_notas_mouredev.sh\`**: Sincronización con Notion
- **\`check_progress.py\`**: Verificación de progreso

## 📱 Integración con herramientas
- **VS Code**: Configuración optimizada para Python
- **GitHub Copilot**: Asistencia en codificación
- **Notion**: Seguimiento de progreso y notas
- **Git**: Control de versiones

---

*Entorno configurado automáticamente el $(date +"%d/%m/%Y") por setup_mouredev_pro.sh*

📧 **Contacto**: Para dudas específicas del curso, consultar en MoureDev Pro
🔗 **Enlaces**: [MoureDev Pro](https://mouredev.pro) | [GitHub](https://github.com/mouredev/Hello-Python)
EOF

show_progress "README actualizado: README_mouredev_pro.md"

# Crear script de sincronización con Notion
echo -e "\n${PURPLE}⚙️ Creando script de sincronización...${NC}"

if [ ! -f "sync_notas_mouredev.sh" ]; then
    cat > "sync_notas_mouredev.sh" << 'EOF'
#!/bin/bash

# Script de sincronización con Notion
# Genera un reporte de progreso en formato markdown

echo "# 📊 Reporte de Progreso MoureDev Pro"
echo "Generado: $(date)"
echo ""

echo "## 🎯 Estadísticas generales"
total_sesiones=30
completadas=0
en_progreso=0

for i in {01..30}; do
    for dir in */; do
        if [[ $dir =~ ^${i}_.* ]]; then
            sesion=$(basename "$dir")
            if [ -f "$dir/ejercicios_sesion_$sesion.py" ]; then
                if grep -q "TODO" "$dir/ejercicios_sesion_$sesion.py"; then
                    ((en_progreso++))
                else
                    ((completadas++))
                fi
            fi
            break
        fi
    done
done

echo "- Total de sesiones: $total_sesiones"
echo "- Completadas: $completadas"
echo "- En progreso: $en_progreso"
echo "- Pendientes: $((total_sesiones - completadas - en_progreso))"
echo ""

echo "## 📋 Estado detallado por sesión"
echo "| Sesión | Estado | Última modificación |"
echo "|--------|--------|---------------------|"

for i in {01..30}; do
    for dir in */; do
        if [[ $dir =~ ^${i}_.* ]]; then
            sesion=$(basename "$dir")
            if [ -f "$dir/ejercicios_sesion_$sesion.py" ]; then
                if grep -q "TODO" "$dir/ejercicios_sesion_$sesion.py"; then
                    estado="🟡 En progreso"
                else
                    estado="🟢 Completado"
                fi
                fecha=$(date -r "$dir/ejercicios_sesion_$sesion.py" +"%d/%m/%Y")
            else
                estado="⚪ Pendiente"
                fecha="—"
            fi
            echo "| $sesion | $estado | $fecha |"
            break
        fi
    done
done
EOF

    chmod +x "sync_notas_mouredev.sh"
    show_progress "Script de sincronización creado: sync_notas_mouredev.sh"
else
    show_info "Script de sincronización ya existe"
fi

# Configurar permisos de ejecución para archivos Python
echo -e "\n${PURPLE}🔧 Configurando permisos...${NC}"

find . -name "*.py" -exec chmod +x {} \;
show_progress "Permisos configurados para archivos Python"

# Mostrar resumen final
echo -e "\n${CYAN}================================================"
echo -e "✅ CONFIGURACIÓN COMPLETADA"
echo -e "================================================${NC}"

echo -e "${GREEN}"
echo "📁 Estructura creada en: $BASE_DIR"
echo "📝 Archivos generados por sesión:"
echo "   • ejercicios_sesion_XX.py (plantilla de ejercicios)"
echo "   • notas_XX.md (resumen teórico)"
echo "   • dudas_y_refuerzo.md (registro de dudas)"
echo ""
echo "🚀 Próximos pasos:"
echo "   1. Revisar la estructura generada"
echo "   2. Comenzar con la sesión 01_hola_mundo"
echo "   3. Usar VS Code + Copilot para desarrollo"
echo "   4. Sincronizar progreso con Notion"
echo -e "${NC}"

echo -e "${YELLOW}💡 Comandos útiles:${NC}"
echo "   • ./sync_notas_mouredev.sh    (generar reporte de progreso)"
echo "   • code .                      (abrir en VS Code)"
echo "   • git add . && git commit     (guardar cambios)"

echo -e "\n${BLUE}🎉 ¡Entorno listo para empezar a aprender Python!${NC}"
