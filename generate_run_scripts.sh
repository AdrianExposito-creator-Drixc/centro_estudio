#!/bin/bash

# ================================================
# 🚀 GENERADOR DE SCRIPTS DE EJECUCIÓN
# ================================================
# Crea scripts run_sesionXX.sh para todas las sesiones
# Integración perfecta con VS Code + Copilot + WORK 2027
#
# Autor: Adrián Expósito Carrasquilla
# Fecha: 06/11/2025
# ================================================

BASE_DIR="/home/drixc/centro_estudio/mouredev_pro"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}================================================"
echo -e "🔧 GENERADOR DE SCRIPTS DE EJECUCIÓN"
echo -e "================================================${NC}"

# Array con información de las sesiones
declare -A SESIONES
SESIONES=(
    ["01_hola_mundo"]="Hola Mundo"
    ["02_variables"]="Variables"
    ["03_operadores"]="Operadores"
    ["04_strings"]="Strings"
    ["05_listas"]="Listas"
    ["06_tuplas"]="Tuplas"
    ["07_sets"]="Sets"
    ["08_diccionarios"]="Diccionarios"
    ["09_condicionales"]="Condicionales"
    ["10_bucles"]="Bucles"
    ["11_funciones"]="Funciones"
    ["12_modulos"]="Modulos"
    ["13_list_comprehension"]="List Comprehension"
    ["14_funciones_orden_superior"]="Funciones Orden Superior"
    ["15_errores_excepciones"]="Errores Excepciones"
    ["16_datetime"]="Datetime"
    ["17_manejo_archivos"]="Manejo Archivos"
    ["18_expresiones_regulares"]="Expresiones Regulares"
    ["19_manejo_json"]="Manejo JSON"
    ["20_pip"]="PIP"
    ["21_clases_objetos"]="Clases Objetos"
    ["22_web_scraping"]="Web Scraping"
    ["23_entornos_virtuales"]="Entornos Virtuales"
    ["24_estadisticas"]="Estadisticas"
    ["25_pandas"]="Pandas"
    ["26_python_web"]="Python Web"
    ["27_mongodb"]="MongoDB"
    ["28_api"]="API"
    ["29_construccion_api"]="Construccion API"
    ["30_proyecto_final"]="Proyecto Final"
)

cd "$BASE_DIR" || exit 1

# Función para crear script de ejecución personalizado
create_run_script() {
    local sesion=$1
    local nombre=$2
    local numero=$(echo $sesion | grep -o '[0-9]\+')
    local script_name="run_${sesion}.sh"
    local py_file="ejercicios_sesion_$sesion.py"

    if [ ! -d "$sesion" ]; then
        echo -e "${YELLOW}⚠️  Carpeta $sesion no existe${NC}"
        return
    fi

    cd "$sesion" || return

    cat > "$script_name" << EOF
#!/bin/bash

# ================================================
# 🚀 EJECUTOR AUTOMÁTICO SESIÓN $numero - $nombre
# ================================================
# Script para ejecutar ejercicios de $nombre con logging automático
# Integración con entorno WORK 2027 + MoureDev Pro
#
# Autor: Adrián Expósito Carrasquilla
# Fecha: $(date +"%d/%m/%Y")
# ================================================

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables de configuración
SESION_DIR="\$(pwd)"
SCRIPT_NAME="$py_file"
LOG_FILE="resultados_${sesion}.log"
FECHA=\$(date +"%d/%m/%Y %H:%M:%S")

echo -e "\${CYAN}================================================"
echo -e "🐍 EJECUTOR SESIÓN $numero - ${nombre^^}"
echo -e "================================================\${NC}"

# Verificar que existe el archivo de ejercicios
if [ ! -f "\$SCRIPT_NAME" ]; then
    echo -e "\${RED}❌ Error: No se encuentra el archivo \$SCRIPT_NAME\${NC}"
    echo -e "\${YELLOW}📁 Archivos disponibles en la carpeta:\${NC}"
    ls -la *.py 2>/dev/null || echo "No hay archivos Python en esta carpeta"
    exit 1
fi

echo -e "\${BLUE}📍 Directorio: \$SESION_DIR\${NC}"
echo -e "\${BLUE}📄 Archivo: \$SCRIPT_NAME\${NC}"
echo -e "\${BLUE}📝 Log: \$LOG_FILE\${NC}"
echo -e "\${BLUE}🕒 Fecha: \$FECHA\${NC}"
echo ""

# Crear cabecera del log
echo "================================================" > "\$LOG_FILE"
echo "🧩 SESIÓN $numero – ${nombre^^}" >> "\$LOG_FILE"
echo "📅 Fecha: \$FECHA" >> "\$LOG_FILE"
echo "📍 Archivo: \$SCRIPT_NAME" >> "\$LOG_FILE"
echo "👤 Autor: Adrián Expósito Carrasquilla" >> "\$LOG_FILE"
echo "================================================" >> "\$LOG_FILE"
echo "" >> "\$LOG_FILE"

echo -e "\${PURPLE}🚀 Ejecutando script de $nombre...\${NC}"
echo ""

# Ejecutar el script y capturar salida
python3 "\$SCRIPT_NAME" 2>&1 | tee -a "\$LOG_FILE"
EXIT_CODE=\${PIPESTATUS[0]}

echo "" >> "\$LOG_FILE"
echo "================================================" >> "\$LOG_FILE"
echo "📊 RESUMEN DE EJECUCIÓN" >> "\$LOG_FILE"
echo "🕒 Finalizado: \$(date +"%d/%m/%Y %H:%M:%S")" >> "\$LOG_FILE"

if [ \$EXIT_CODE -eq 0 ]; then
    echo "✅ Estado: Ejecutado correctamente" >> "\$LOG_FILE"
    echo -e "\n\${GREEN}✅ Script ejecutado correctamente\${NC}"
else
    echo "❌ Estado: Error en la ejecución (código: \$EXIT_CODE)" >> "\$LOG_FILE"
    echo -e "\n\${RED}❌ Error en la ejecución (código: \$EXIT_CODE)\${NC}"
fi

echo "================================================" >> "\$LOG_FILE"

echo ""
echo -e "\${CYAN}================================================"
echo -e "📋 RESUMEN PARA WORK 2027"
echo -e "================================================\${NC}"

echo -e "\${YELLOW}📝 Información para Notion/Miro:\${NC}"
echo -e "🧩 Sesión $numero – $nombre"
echo -e "📅 Fecha: \$(date +"%d/%m/%Y")"
echo -e "📍 Archivo: \$SCRIPT_NAME"
if [ \$EXIT_CODE -eq 0 ]; then
    echo -e "✅ Estado: Ejecutado correctamente"
    echo -e "🧠 Conceptos reforzados: [Revisar en notas_${sesion}.md]"
else
    echo -e "❌ Estado: Error en ejecución - revisar log"
fi
echo -e "📄 Log guardado en: \$LOG_FILE"

echo ""
echo -e "\${BLUE}🔍 Comandos útiles:\${NC}"
echo -e "• Ver log: \${CYAN}cat \$LOG_FILE\${NC}"
echo -e "• Editar: \${CYAN}code \$SCRIPT_NAME\${NC}"
echo -e "• Re-ejecutar: \${CYAN}./\$0\${NC}"
echo -e "• Ver notas: \${CYAN}code notas_${sesion}.md\${NC}"

echo ""
echo -e "\${GREEN}🎯 Siguiente paso: Revisar conceptos en notas_${sesion}.md\${NC}"
EOF

    chmod +x "$script_name"
    echo -e "${GREEN}✅ Script creado: $sesion/$script_name${NC}"

    cd ..
}

# Generar scripts para todas las sesiones
echo -e "${PURPLE}📝 Generando scripts de ejecución...${NC}"
echo ""

for sesion in "${!SESIONES[@]}"; do
    nombre="${SESIONES[$sesion]}"
    create_run_script "$sesion" "$nombre"
done

echo ""
echo -e "${CYAN}================================================"
echo -e "✅ GENERACIÓN COMPLETADA"
echo -e "================================================${NC}"

echo -e "${GREEN}"
echo "🚀 Scripts generados para todas las sesiones"
echo "📁 Ubicación: $BASE_DIR/XX_tema/"
echo "📝 Nomenclatura: run_XX_tema.sh"
echo ""
echo "🔍 Ejemplo de uso:"
echo "   cd $BASE_DIR/02_variables"
echo "   ./run_02_variables.sh"
echo ""
echo "💡 Cada script incluye:"
echo "   • Ejecución automática del archivo Python"
echo "   • Logging completo en resultados_XX.log"
echo "   • Resumen para integración con WORK 2027"
echo "   • Comandos útiles para desarrollo"
echo -e "${NC}"

echo -e "${YELLOW}🎯 Próximos pasos sugeridos:${NC}"
echo "1. Probar ejecución: ./02_variables/run_02_variables.sh"
echo "2. Revisar logs generados"
echo "3. Integrar con VS Code tasks"
echo "4. Sincronizar con Notion"
