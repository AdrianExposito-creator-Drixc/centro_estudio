#!/bin/bash

# =============================================================================
# WORK 2027 - GENERADOR DE PAQUETE COMPLETO
# =============================================================================
# Genera el paquete Work2027_VSCopilot.zip con todos los componentes

echo "📦 GENERANDO PAQUETE WORK2027_VSCOPILOT COMPLETO"
echo "==============================================="

WORKSPACE_PATH="/home/drixc/centro_estudio"
PACKAGE_NAME="Work2027_VSCopilot_$(date '+%Y%m%d_%H%M%S')"
TEMP_DIR="/tmp/$PACKAGE_NAME"
FINAL_ZIP="$HOME/Downloads/$PACKAGE_NAME.zip"

# Crear directorio temporal
echo "📁 Creando estructura del paquete..."
mkdir -p "$TEMP_DIR"

# Copiar archivos principales
echo "📋 Copiando scripts principales..."
cp "$WORKSPACE_PATH/work2027_log_generator.py" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/work2027_code_analyzer.py" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/work2027_github_integration.py" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/work2027_m365_integration.py" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/work2027_master_workflow.sh" "$TEMP_DIR/"

# Copiar instaladores y scripts auxiliares
echo "⚙️ Copiando instaladores..."
cp "$WORKSPACE_PATH/install_work2027_complete.sh" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/setup_copilot_work2027.sh" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/sync_work2027_onedrive.sh" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/work2027_daily_run.sh" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/Install-Work2027.ps1" "$TEMP_DIR/" 2>/dev/null || echo "Script PowerShell no encontrado"

# Copiar configuraciones VS Code
echo "🔧 Copiando configuraciones VS Code..."
mkdir -p "$TEMP_DIR/.vscode"
cp "$WORKSPACE_PATH/.vscode/settings.json" "$TEMP_DIR/.vscode/"
cp "$WORKSPACE_PATH/.vscode/tasks.json" "$TEMP_DIR/.vscode/"
cp "$WORKSPACE_PATH/.vscode/copilot_work2027_context.md" "$TEMP_DIR/.vscode/"
cp "$WORKSPACE_PATH/.vscode/prompt_conexion_work2027.py" "$TEMP_DIR/.vscode/"

# Copiar documentación
echo "📚 Copiando documentación..."
cp "$WORKSPACE_PATH/README_WORK2027_COMPLETO.md" "$TEMP_DIR/"
cp "$WORKSPACE_PATH/WORK2027_GUIA_COMPLETA.md" "$TEMP_DIR/" 2>/dev/null || echo "Guía completa se generará en instalación"

# Crear archivo de versión
echo "📋 Creando información de versión..."
cat > "$TEMP_DIR/VERSION.txt" << EOF
Work 2027 - Ecosystem Completo VS Copilot
========================================

Versión: 2.0 - Complete Integration
Fecha: $(date '+%d/%m/%Y %H:%M:%S')
Autor: Adrián Drix

Componentes incluidos:
- GitHub Copilot integration (VS Code)
- Microsoft 365 Copilot integration
- Automatic log generation
- Code quality analysis
- GitHub auto-sync
- OneDrive synchronization
- Master workflow automation

Instalación: ./install_work2027_complete.sh
Uso diario: ./work2027_master_workflow.sh

Para soporte: Revisar README_WORK2027_COMPLETO.md
EOF

# Crear script de verificación
echo "🔍 Creando verificador de instalación..."
cat > "$TEMP_DIR/verify_installation.sh" << 'EOF'
#!/bin/bash

echo "🔍 VERIFICANDO INSTALACIÓN WORK 2027"
echo "===================================="

ERRORS=0

# Verificar archivos principales
FILES=(
    "work2027_log_generator.py"
    "work2027_code_analyzer.py"
    "work2027_github_integration.py"
    "work2027_m365_integration.py"
    "work2027_master_workflow.sh"
    "install_work2027_complete.sh"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - FALTANTE"
        ERRORS=$((ERRORS + 1))
    fi
done

# Verificar configuraciones VS Code
if [ -d ".vscode" ]; then
    echo "✅ Directorio .vscode"
    if [ -f ".vscode/settings.json" ]; then
        echo "✅ settings.json"
    else
        echo "❌ settings.json - FALTANTE"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "❌ Directorio .vscode - FALTANTE"
    ERRORS=$((ERRORS + 1))
fi

# Verificar permisos
for script in work2027_master_workflow.sh install_work2027_complete.sh; do
    if [ -x "$script" ]; then
        echo "✅ $script (ejecutable)"
    else
        echo "⚠️ $script (sin permisos de ejecución)"
        chmod +x "$script" 2>/dev/null && echo "   → Permisos corregidos"
    fi
done

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "🎉 INSTALACIÓN VERIFICADA CORRECTAMENTE"
    echo "Ejecuta: ./install_work2027_complete.sh para continuar"
else
    echo "❌ ENCONTRADOS $ERRORS ERRORES"
    echo "Revisa que todos los archivos estén presentes"
fi

echo ""
echo "📚 Documentación: README_WORK2027_COMPLETO.md"
echo "🚀 Instalación: ./install_work2027_complete.sh"
EOF

chmod +x "$TEMP_DIR/verify_installation.sh"

# Crear requirements.txt
echo "📦 Creando requirements.txt..."
cat > "$TEMP_DIR/requirements.txt" << EOF
# Work 2027 - Python Dependencies
# No external dependencies required - uses only standard library
#
# Optional enhancements:
# requests>=2.25.1
# gitpython>=3.1.0
#
# For development:
# pylint>=2.8.0
# black>=21.0.0
# pytest>=6.0.0
EOF

# Crear .gitignore para el paquete
echo "🚫 Creando .gitignore..."
cat > "$TEMP_DIR/.gitignore" << EOF
# Work 2027 - Generated files
resultado_*.json
github_sync_result_*.json
.work2027_last_run
.work2027_git_config.json

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
.venv/
.env
venv/
ENV/

# IDEs
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
temp/
backup/
EOF

# Hacer ejecutables todos los scripts
echo "⚙️ Configurando permisos..."
chmod +x "$TEMP_DIR"/*.sh

# Crear el ZIP
echo "🗜️ Creando archivo ZIP..."
cd /tmp
zip -r "$FINAL_ZIP" "$PACKAGE_NAME" -q

# Limpiar directorio temporal
rm -rf "$TEMP_DIR"

# Mostrar resumen
echo ""
echo "🎉 PAQUETE WORK2027_VSCOPILOT GENERADO EXITOSAMENTE"
echo "=================================================="
echo ""
echo "📁 Ubicación: $FINAL_ZIP"
echo "📊 Tamaño: $(du -h "$FINAL_ZIP" | cut -f1)"
echo "📦 Archivos incluidos: $(unzip -l "$FINAL_ZIP" | grep -c "\.py\|\.sh\|\.json\|\.md\|\.txt")"
echo ""
echo "📋 CONTENIDO DEL PAQUETE:"
echo "- 🐍 Scripts Python (5): Análisis, logs, GitHub, M365, etc."
echo "- 🔧 Scripts Shell (4): Instalación, sync, workflow, etc."
echo "- ⚙️ Configuraciones VS Code: settings.json, tasks.json"
echo "- 📚 Documentación completa: README, guías, prompts"
echo "- ✅ Verificador de instalación incluido"
echo ""
echo "🚀 INSTRUCCIONES DE USO:"
echo "1. Descomprimir: unzip $(basename "$FINAL_ZIP")"
echo "2. Verificar: ./verify_installation.sh"
echo "3. Instalar: ./install_work2027_complete.sh"
echo "4. Usar: ./work2027_master_workflow.sh"
echo ""
echo "🎯 ¡Paquete completo listo para distribución!"

# Crear checksum para verificación
echo "🔒 Generando checksum..."
CHECKSUM=$(sha256sum "$FINAL_ZIP" | cut -d' ' -f1)
echo "$CHECKSUM" > "$FINAL_ZIP.sha256"

echo ""
echo "🛡️ Checksum SHA256: $CHECKSUM"
echo "📁 Archivo checksum: $FINAL_ZIP.sha256"
echo ""
echo "✅ Paquete Work2027_VSCopilot completado exitosamente"

# Mostrar ubicación final
ls -lh "$FINAL_ZIP"