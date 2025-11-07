#!/bin/bash

# =============================================================================
# CONFIGURADOR DE SINCRONIZACIÓN WORK 2027 - ONEDRIVE
# =============================================================================
# Este script configura la sincronización automática entre VS Code y OneDrive
# para que Copilot Windows pueda generar reportes automáticos del código

echo "🔧 Configurando sincronización Work 2027 - OneDrive..."

# Variables de configuración
WORKSPACE_PATH="/home/drixc/centro_estudio"
ONEDRIVE_PATH="$HOME/OneDrive/Work2027/01_Python"
REPORTS_PATH="$HOME/OneDrive/Work2027/05_Finanzas_y_Documentos/Reportes_Codigo"

# Crear directorios si no existen
echo "📁 Creando estructura de directorios..."
mkdir -p "$ONEDRIVE_PATH"
mkdir -p "$REPORTS_PATH"

# Crear archivo de configuración para VS Code
echo "⚙️ Configurando VS Code settings..."
cat > "$WORKSPACE_PATH/.vscode/settings.json" << EOF
{
    "copilot.advanced": {
        "debug.overrideEngine": "codex"
    },
    "copilot.enable": {
        "*": true,
        "yaml": true,
        "plaintext": true,
        "markdown": true,
        "python": true
    },
    "github.copilot.advanced": {
        "debug.showScores": true
    },
    "github.copilot.chat.localeOverride": "es",
    "files.associations": {
        "*.work2027": "python",
        "*_work2027.py": "python"
    },
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "python.defaultInterpreterPath": "./venv/bin/python",
    "workbench.colorCustomizations": {
        "statusBar.background": "#2D5A27",
        "statusBar.foreground": "#FFFFFF",
        "titleBar.activeBackground": "#2D5A27"
    }
}
EOF

# Crear script de sincronización automática
echo "🔄 Creando script de sincronización..."
cat > "$WORKSPACE_PATH/sync_work2027_onedrive.sh" << 'EOF'
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
EOF

# Hacer ejecutable el script de sincronización
chmod +x "$WORKSPACE_PATH/sync_work2027_onedrive.sh"

# Crear tarea automática (opcional)
echo "⏰ Configurando tarea automática..."
cat > "$WORKSPACE_PATH/.vscode/tasks.json" << EOF
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Work 2027: Sincronizar con OneDrive",
            "type": "shell",
            "command": "./sync_work2027_onedrive.sh",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": []
        },
        {
            "label": "Work 2027: Configurar Copilot",
            "type": "shell",
            "command": "echo",
            "args": ["✅ GitHub Copilot configurado para Work 2027"],
            "group": "build"
        }
    ]
}
EOF

echo ""
echo "🎉 ¡Configuración Work 2027 completada!"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo "1. Abre GitHub Copilot Chat (Ctrl + Shift + I)"
echo "2. Copia y pega el prompt desde: .vscode/prompt_conexion_work2027.py"
echo "3. Ejecuta 'Work 2027: Sincronizar con OneDrive' desde Command Palette"
echo ""
echo "🔗 ARCHIVOS CREADOS:"
echo "- .vscode/copilot_work2027_context.md"
echo "- .vscode/prompt_conexion_work2027.py"
echo "- .vscode/settings.json"
echo "- .vscode/tasks.json"
echo "- sync_work2027_onedrive.sh"
echo ""
echo "🚀 ¡Tu ecosystem Work 2027 está listo!"
