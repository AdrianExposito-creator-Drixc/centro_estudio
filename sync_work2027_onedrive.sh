#!/bin/bash

# Script de sincronización automática Work 2027
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
WORKSPACE_PATH="/home/drixc/centro_estudio"
ONEDRIVE_PATH="$HOME/OneDrive/Work2027/01_Python"
REPORTS_PATH="$HOME/OneDrive/Work2027/05_Finanzas_y_Documentos/Reportes_Codigo"

echo "🔄 Sincronizando Work 2027 con OneDrive..."

# Copiar archivos Python modificados
rsync -av --include="*.py" --include="*.md" --include="*.json" --exclude="*" \
    "$WORKSPACE_PATH/" "$ONEDRIVE_PATH/"

# Generar reporte de código para Microsoft 365 Copilot
cat > "$REPORTS_PATH/reporte_codigo_$TIMESTAMP.md" << REPORT_EOF
# Reporte de Código Work 2027
**Fecha**: $(date '+%d/%m/%Y %H:%M:%S')
**Generado por**: GitHub Copilot VS Code

## Archivos Modificados Recientemente
REPORT_EOF

# Listar archivos Python modificados en las últimas 24 horas
find "$WORKSPACE_PATH" -name "*.py" -mtime -1 -type f | while read file; do
    echo "- $(basename "$file")" >> "$REPORTS_PATH/reporte_codigo_$TIMESTAMP.md"
done

# Agregar estadísticas
echo "" >> "$REPORTS_PATH/reporte_codigo_$TIMESTAMP.md"
echo "## Estadísticas" >> "$REPORTS_PATH/reporte_codigo_$TIMESTAMP.md"
echo "- **Archivos Python totales**: $(find "$WORKSPACE_PATH" -name "*.py" | wc -l)" >> "$REPORTS_PATH/reporte_codigo_$TIMESTAMP.md"
echo "- **Líneas de código**: $(find "$WORKSPACE_PATH" -name "*.py" -exec wc -l {} \; | awk '{sum+=$1} END {print sum}')" >> "$REPORTS_PATH/reporte_codigo_$TIMESTAMP.md"
echo "- **Última sincronización**: $(date)" >> "$REPORTS_PATH/reporte_codigo_$TIMESTAMP.md"

echo "✅ Sincronización completada: $TIMESTAMP"
