#!/bin/bash

# ================================================
# 🚀 EJECUTOR AUTOMÁTICO SESIÓN 11 - Funciones
# ================================================
# Script para ejecutar ejercicios de Funciones con logging automático
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
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables de configuración
SESION_DIR="$(pwd)"
SCRIPT_NAME="ejercicios_sesion_11_funciones.py"
LOG_FILE="resultados_11_funciones.log"
FECHA=$(date +"%d/%m/%Y %H:%M:%S")

echo -e "${CYAN}================================================"
echo -e "🐍 EJECUTOR SESIÓN 11 - FUNCIONES"
echo -e "================================================${NC}"

# Verificar que existe el archivo de ejercicios
if [ ! -f "$SCRIPT_NAME" ]; then
    echo -e "${RED}❌ Error: No se encuentra el archivo $SCRIPT_NAME${NC}"
    echo -e "${YELLOW}📁 Archivos disponibles en la carpeta:${NC}"
    ls -la *.py 2>/dev/null || echo "No hay archivos Python en esta carpeta"
    exit 1
fi

echo -e "${BLUE}📍 Directorio: $SESION_DIR${NC}"
echo -e "${BLUE}📄 Archivo: $SCRIPT_NAME${NC}"
echo -e "${BLUE}📝 Log: $LOG_FILE${NC}"
echo -e "${BLUE}🕒 Fecha: $FECHA${NC}"
echo ""

# Crear cabecera del log
echo "================================================" > "$LOG_FILE"
echo "🧩 SESIÓN 11 – FUNCIONES" >> "$LOG_FILE"
echo "📅 Fecha: $FECHA" >> "$LOG_FILE"
echo "📍 Archivo: $SCRIPT_NAME" >> "$LOG_FILE"
echo "👤 Autor: Adrián Expósito Carrasquilla" >> "$LOG_FILE"
echo "================================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo -e "${PURPLE}🚀 Ejecutando script de Funciones...${NC}"
echo ""

# Ejecutar el script y capturar salida
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
echo -e "🧩 Sesión 11 – Funciones"
echo -e "📅 Fecha: $(date +"%d/%m/%Y")"
echo -e "📍 Archivo: $SCRIPT_NAME"
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "✅ Estado: Ejecutado correctamente"
    echo -e "🧠 Conceptos reforzados: [Revisar en notas_11_funciones.md]"
else
    echo -e "❌ Estado: Error en ejecución - revisar log"
fi
echo -e "📄 Log guardado en: $LOG_FILE"

echo ""
echo -e "${BLUE}🔍 Comandos útiles:${NC}"
echo -e "• Ver log: ${CYAN}cat $LOG_FILE${NC}"
echo -e "• Editar: ${CYAN}code $SCRIPT_NAME${NC}"
echo -e "• Re-ejecutar: ${CYAN}./$0${NC}"
echo -e "• Ver notas: ${CYAN}code notas_11_funciones.md${NC}"

echo ""
echo -e "${GREEN}🎯 Siguiente paso: Revisar conceptos en notas_11_funciones.md${NC}"
