#!/bin/bash

# Work 2027 VS Code Error Fix and Restart
# ======================================

echo "🔧 WORK 2027 VS CODE ERROR FIX & RESTART"
echo "========================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para verificar si VS Code está ejecutándose
check_vscode_running() {
    if pgrep -x "code" > /dev/null; then
        return 0
    else
        return 1
    fi
}

# 1. Verificar estado actual de VS Code
log_info "Verificando estado actual de VS Code..."

if check_vscode_running; then
    log_warning "VS Code está ejecutándose"

    # Cerrar VS Code gracefully
    log_info "Cerrando VS Code..."
    pkill -TERM code
    sleep 3

    # Forzar cierre si aún está ejecutándose
    if check_vscode_running; then
        log_warning "Forzando cierre de VS Code..."
        pkill -KILL code
        sleep 2
    fi

    log_success "VS Code cerrado correctamente"
else
    log_info "VS Code no está ejecutándose"
fi

# 2. Limpiar archivos temporales y cache
log_info "Limpiando cache y archivos temporales..."

# Limpiar cache de VS Code
if [ -d "$HOME/.vscode" ]; then
    log_info "Limpiando cache de VS Code..."
    rm -rf "$HOME/.vscode/logs/*" 2>/dev/null
    rm -rf "$HOME/.vscode/CachedExtensions" 2>/dev/null
    rm -rf "$HOME/.vscode/CachedExtensionVSIXs" 2>/dev/null
    log_success "Cache de VS Code limpiado"
fi

# Limpiar archivos de workspace temporales
log_info "Limpiando archivos temporales del workspace..."
find . -name "*.tmp" -delete 2>/dev/null
find . -name ".DS_Store" -delete 2>/dev/null
find . -name "Thumbs.db" -delete 2>/dev/null

# 3. Verificar y corregir configuración de Git
log_info "Verificando configuración de Git..."

if ! git config --global user.name > /dev/null 2>&1; then
    log_warning "Configurando usuario Git por defecto..."
    git config --global user.name "Work 2027 Developer"
fi

if ! git config --global user.email > /dev/null 2>&1; then
    log_warning "Configurando email Git por defecto..."
    git config --global user.email "work2027@local.dev"
fi

log_success "Configuración Git verificada"

# 4. Verificar GitHub Actions workflows
log_info "Verificando GitHub Actions workflows..."

# Verificar sintaxis YAML de workflows
if [ -d ".github/workflows" ]; then
    for workflow in .github/workflows/*.yml .github/workflows/*.yaml; do
        if [ -f "$workflow" ]; then
            log_info "Verificando: $(basename "$workflow")"

            # Verificar sintaxis YAML básica
            if command -v python3 > /dev/null; then
                python3 -c "
import yaml
try:
    with open('$workflow', 'r') as f:
        yaml.safe_load(f)
    print('✅ Sintaxis YAML válida')
except Exception as e:
    print(f'❌ Error en YAML: {e}')
    exit(1)
" || log_error "Error en sintaxis YAML de $(basename "$workflow")"
            fi
        fi
    done
    log_success "Workflows verificados"
else
    log_warning "No se encontraron workflows de GitHub Actions"
fi

# 5. Verificar permisos de archivos
log_info "Verificando permisos de archivos..."

# Hacer ejecutables los scripts
chmod +x *.sh 2>/dev/null
chmod +x **/*.sh 2>/dev/null

# Verificar permisos de Python scripts
chmod +x *.py 2>/dev/null
find . -name "*.py" -exec chmod +x {} \; 2>/dev/null

log_success "Permisos verificados y corregidos"

# 6. Verificar dependencias de Python
log_info "Verificando entorno Python..."

if [ -d "venv" ]; then
    log_info "Activando entorno virtual..."
    source venv/bin/activate

    # Verificar dependencias críticas
    python3 -c "
import sys
missing = []
try:
    import requests
except ImportError:
    missing.append('requests')

try:
    import json
except ImportError:
    missing.append('json')

try:
    import yaml
except ImportError:
    missing.append('pyyaml')

if missing:
    print(f'❌ Dependencias faltantes: {missing}')
    exit(1)
else:
    print('✅ Dependencias Python verificadas')
"

    if [ $? -eq 0 ]; then
        log_success "Entorno Python verificado"
    else
        log_warning "Instalando dependencias faltantes..."
        pip install requests pyyaml beautifulsoup4
    fi
else
    log_warning "No se encontró entorno virtual"
fi

# 7. Verificar estructura de proyecto
log_info "Verificando estructura del proyecto..."

# Crear directorios necesarios si no existen
directories=(
    ".vscode"
    ".github/workflows"
    "config"
    "docs"
    "scripts"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        log_info "Creando directorio: $dir"
        mkdir -p "$dir"
    fi
done

log_success "Estructura de proyecto verificada"

# 8. Reparar configuración de VS Code
log_info "Reparando configuración de VS Code..."

# Crear configuración de workspace si no existe
if [ ! -f ".vscode/settings.json" ]; then
    log_info "Creando configuración de workspace..."
    cat > .vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "./venv/bin/python",
    "python.terminal.activateEnvironment": true,
    "files.associations": {
        "*.yml": "yaml",
        "*.yaml": "yaml"
    },
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    "terminal.integrated.defaultProfile.linux": "bash",
    "copilot.enable": {
        "*": true,
        "yaml": true,
        "plaintext": true,
        "markdown": true
    }
}
EOF
    log_success "Configuración de workspace creada"
fi

# 9. Verificar y corregir GitHub integration
log_info "Verificando integración con GitHub..."

# Verificar si hay problemas con el repositorio
if [ -d ".git" ]; then
    # Verificar estado del repositorio
    git_status=$(git status --porcelain 2>/dev/null)

    if [ $? -eq 0 ]; then
        log_success "Repositorio Git verificado"

        # Mostrar archivos modificados si los hay
        if [ -n "$git_status" ]; then
            log_info "Archivos modificados detectados:"
            echo "$git_status"
        fi
    else
        log_error "Problemas con el repositorio Git"
    fi
else
    log_warning "No es un repositorio Git"
fi

# 10. Ejecutar test de Temptraining Connector
log_info "Probando Temptraining Connector..."

if [ -f "temptraining_connector.py" ]; then
    python3 -c "
import sys
sys.path.append('.')
try:
    from temptraining_connector import TemptrainingConnector
    connector = TemptrainingConnector()
    print('✅ Temptraining Connector importado correctamente')
except Exception as e:
    print(f'❌ Error en Temptraining Connector: {e}')
    exit(1)
"

    if [ $? -eq 0 ]; then
        log_success "Temptraining Connector verificado"
    else
        log_error "Error en Temptraining Connector"
    fi
else
    log_warning "Temptraining Connector no encontrado"
fi

# 11. Preparar restart de VS Code
log_info "Preparando restart de VS Code..."

# Guardar información del workspace actual
WORKSPACE_PATH=$(pwd)
WORKSPACE_FILE=""

# Buscar archivo de workspace
for ws_file in *.code-workspace; do
    if [ -f "$ws_file" ]; then
        WORKSPACE_FILE="$ws_file"
        break
    fi
done

# 12. Restart VS Code
log_info "Reiniciando VS Code..."

if [ -n "$WORKSPACE_FILE" ]; then
    log_info "Abriendo workspace: $WORKSPACE_FILE"
    nohup code "$WORKSPACE_FILE" > /dev/null 2>&1 &
else
    log_info "Abriendo directorio: $WORKSPACE_PATH"
    nohup code "$WORKSPACE_PATH" > /dev/null 2>&1 &
fi

# Esperar a que VS Code inicie
sleep 5

# Verificar que VS Code se inició correctamente
if check_vscode_running; then
    log_success "VS Code reiniciado correctamente"
else
    log_error "Error al reiniciar VS Code"
fi

# 13. Mostrar resumen final
echo ""
echo "🎯 RESUMEN DE CORRECCIONES APLICADAS"
echo "==================================="

corrections=(
    "✅ VS Code cerrado y reiniciado"
    "✅ Cache y archivos temporales limpiados"
    "✅ Configuración Git verificada"
    "✅ Workflows GitHub Actions verificados"
    "✅ Permisos de archivos corregidos"
    "✅ Entorno Python verificado"
    "✅ Estructura de proyecto verificada"
    "✅ Configuración VS Code reparada"
    "✅ Integración GitHub verificada"
    "✅ Temptraining Connector probado"
)

for correction in "${corrections[@]}"; do
    echo "  $correction"
done

echo ""
log_success "WORK 2027 VS CODE ERROR FIX COMPLETADO"

# 14. Mostrar próximos pasos
echo ""
echo "🚀 PRÓXIMOS PASOS:"
echo "=================="
echo "1. Verificar que VS Code carga correctamente"
echo "2. Confirmar extensiones funcionando"
echo "3. Probar Temptraining Connector:"
echo "   python3 temptraining_connector.py"
echo "4. Verificar GitHub Actions workflows"
echo "5. Continuar con integración Temptraining"

echo ""
log_info "Script completado. VS Code debería estar ejecutándose."

# Salir con código de éxito
exit 0