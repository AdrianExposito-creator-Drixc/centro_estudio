#!/bin/bash

# ================================================
# 🚀 EJECUTOR AUTOMÁTICO SESIÓN 02 - VARIABLES
# ================================================
# Script para ejecutar ejercicios de variables con logging automático
# Integración con entorno WORK 2027 + MoureDev Pro
#
# Autor: Adrián Expósito Carrasquilla
# Fecha: 06/11/2025
# ================================================

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables de configuración
SESION_DIR="/home/drixc/centro_estudio/mouredev_pro/02_variables"
SCRIPT_NAME="ejercicios_sesion_02_variables.py"
LOG_FILE="resultados_variables.log"
FECHA=$(date +"%d/%m/%Y %H:%M:%S")

echo -e "${CYAN}================================================"
echo -e "🐍 EJECUTOR SESIÓN 02 - VARIABLES"
echo -e "================================================${NC}"

# Verificar que estamos en el directorio correcto
if [ ! -d "$SESION_DIR" ]; then
    echo -e "${RED}❌ Error: No se encuentra el directorio $SESION_DIR${NC}"
    exit 1
fi

cd "$SESION_DIR" || exit 1

# Verificar que existe el archivo de ejercicios
if [ ! -f "$SCRIPT_NAME" ]; then
    echo -e "${RED}❌ Error: No se encuentra el archivo $SCRIPT_NAME${NC}"
    echo -e "${YELLOW}📁 Archivos disponibles en la carpeta:${NC}"
    ls -la *.py 2>/dev/null || echo "No hay archivos Python en esta carpeta"
    exit 1
fi

echo -e "${BLUE}📍 Directorio de trabajo: $SESION_DIR${NC}"
echo -e "${BLUE}📄 Archivo a ejecutar: $SCRIPT_NAME${NC}"
echo -e "${BLUE}📝 Log de resultados: $LOG_FILE${NC}"
echo -e "${BLUE}🕒 Fecha de ejecución: $FECHA${NC}"
echo ""

# Crear cabecera del log
echo "================================================" > "$LOG_FILE"
echo "🧩 SESIÓN 02 – VARIABLES Y FUNCIONES" >> "$LOG_FILE"
echo "📅 Fecha: $FECHA" >> "$LOG_FILE"
echo "📍 Archivo: $SCRIPT_NAME" >> "$LOG_FILE"
echo "👤 Autor: Adrián Expósito Carrasquilla" >> "$LOG_FILE"
echo "================================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo -e "${PURPLE}🚀 Ejecutando script de variables...${NC}"
echo ""

# Ejecutar el script y capturar tanto stdout como stderr
python3 "$SCRIPT_NAME" 2>&1 | tee -a "$LOG_FILE"
EXIT_CODE=${PIPESTATUS[0]}

echo "" >> "$LOG_FILE"
echo "================================================" >> "$LOG_FILE"
echo "📊 RESUMEN DE EJECUCIÓN" >> "$LOG_FILE"
echo "🕒 Finalizado: $(date +"%d/%m/%Y %H:%M:%S")" >> "$LOG_FILE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Estado: Ejecutado correctamente" >> "$LOG_FILE"
    echo -e "\n${GREEN}✅ Script ejecutado correctamente${NC}"
else
    echo "❌ Estado: Error en la ejecución (código: $EXIT_CODE)" >> "$LOG_FILE"
    echo -e "\n${RED}❌ Error en la ejecución (código: $EXIT_CODE)${NC}"
fi

echo "================================================" >> "$LOG_FILE"

echo ""
echo -e "${CYAN}================================================"
echo -e "📋 RESUMEN PARA WORK 2027"
echo -e "================================================${NC}"

echo -e "${YELLOW}📝 Información para Notion/Miro:${NC}"
echo -e "🧩 Sesión 02 – Variables y Funciones"
echo -e "📅 Fecha: $(date +"%d/%m/%Y")"
echo -e "📍 Archivo: $SCRIPT_NAME"
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "✅ Estado: Ejecutado correctamente"
    echo -e "🧠 Conceptos reforzados: conversión de tipos, input(), len(), type hinting"
else
    echo -e "❌ Estado: Error en ejecución - revisar log"
fi
echo -e "📄 Log guardado en: $LOG_FILE"

echo ""
echo -e "${BLUE}🔍 Comandos útiles:${NC}"
echo -e "• Ver log completo: ${CYAN}cat $LOG_FILE${NC}"
echo -e "• Editar script: ${CYAN}code $SCRIPT_NAME${NC}"
echo -e "• Re-ejecutar: ${CYAN}./run_variables.sh${NC}"
echo -e "• Ver resultados: ${CYAN}tail -20 $LOG_FILE${NC}"

echo ""
echo -e "${GREEN}🎯 Siguiente paso: Revisar conceptos en notas_02_variables.md${NC}"

# Si hay errores, mostrar sugerencias
if [ $EXIT_CODE -ne 0 ]; then
    echo ""
    echo -e "${YELLOW}🔧 Sugerencias para depuración:${NC}"
    echo -e "• Verificar sintaxis Python"
    echo -e "• Revisar imports y dependencias"
    echo -e "• Comprobar indentación"
    echo -e "• Ver log detallado: cat $LOG_FILE"
fi
