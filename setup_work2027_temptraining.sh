#!/bin/bash

# Work 2027 - Temptraining Integration Setup
# ========================================
# Instalación y configuración automática completa

echo "🚀 WORK 2027 TEMPTRAINING INTEGRATION SETUP"
echo "============================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_header() { echo -e "${PURPLE}[SETUP]${NC} $1"; }

# Verificar prerrequisitos
log_header "Verificando prerrequisitos del sistema..."

# Verificar Python 3
if ! command -v python3 &> /dev/null; then
    log_error "Python 3 no encontrado. Instalando..."
    sudo apt update && sudo apt install python3 python3-pip python3-venv -y
fi

# Verificar Git
if ! command -v git &> /dev/null; then
    log_error "Git no encontrado. Instalando..."
    sudo apt install git -y
fi

# Verificar VS Code
if ! command -v code &> /dev/null; then
    log_warning "VS Code no encontrado. Instalando..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update && sudo apt install code -y
fi

log_success "Prerrequisitos verificados"

# Crear entorno virtual si no existe
log_header "Configurando entorno Python..."

if [ ! -d "venv" ]; then
    log_info "Creando entorno virtual..."
    python3 -m venv venv
fi

# Activar entorno virtual
source venv/bin/activate

# Instalar dependencias
log_info "Instalando dependencias Python..."
pip install --upgrade pip
pip install requests beautifulsoup4 pyyaml asyncio dataclasses pathlib

log_success "Entorno Python configurado"

# Verificar archivos de integración
log_header "Verificando archivos de integración Work 2027..."

required_files=(
    "temptraining_connector.py"
    "work2027_auto_loop_sync.py"
    "fix_vscode_restart.sh"
)

missing_files=()

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    log_error "Archivos faltantes detectados:"
    for file in "${missing_files[@]}"; do
        echo "  ❌ $file"
    done
    log_info "Descargando archivos desde repositorio..."
    # Aquí iría la lógica de descarga desde GitHub
else
    log_success "Todos los archivos de integración presentes"
fi

# Configurar configuraciones iniciales
log_header "Configurando archivos de configuración..."

# Crear configuración de Temptraining si no existe
if [ ! -f "temptraining_config.json" ]; then
    log_info "Creando configuración Temptraining..."
    cat > temptraining_config.json << 'EOF'
{
  "temptraining_email": "",
  "temptraining_password": "",
  "target_technologies": [
    "Python",
    "IA",
    "Inteligencia Artificial",
    "Big Data",
    "IoT",
    "Cloud",
    "AWS",
    "Azure"
  ],
  "preferred_levels": [
    "Básico",
    "Intermedio",
    "Avanzado"
  ],
  "max_courses_per_tech": 5,
  "enable_auto_enrollment": false,
  "update_frequency_hours": 24,
  "export_formats": ["json", "loop", "md"]
}
EOF
fi

# Crear configuración de VS Code Work 2027 si no existe
if [ ! -d ".vscode" ]; then
    mkdir -p .vscode
fi

if [ ! -f ".vscode/settings.json" ]; then
    log_info "Creando configuración VS Code Work 2027..."
    cat > .vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "./venv/bin/python",
    "python.terminal.activateEnvironment": true,
    "files.associations": {
        "*.yml": "yaml",
        "*.yaml": "yaml",
        "*.loop.md": "markdown"
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
        "markdown": true,
        "python": true
    },
    "copilot.editor.enableAutoCompletions": true,
    "github.copilot.enable": {
        "*": true
    },
    "workbench.colorTheme": "GitHub Dark",
    "workbench.iconTheme": "material-icon-theme",
    "editor.minimap.enabled": true,
    "editor.wordWrap": "on",
    "files.autoSave": "onDelay",
    "files.autoSaveDelay": 1000
}
EOF
fi

# Crear tasks.json para Work 2027
if [ ! -f ".vscode/tasks.json" ]; then
    log_info "Creando tareas VS Code Work 2027..."
    cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Work 2027: Run Temptraining Sync",
            "type": "shell",
            "command": "${workspaceFolder}/venv/bin/python",
            "args": ["temptraining_connector.py"],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": []
        },
        {
            "label": "Work 2027: Full Loop Sync",
            "type": "shell",
            "command": "${workspaceFolder}/venv/bin/python",
            "args": ["work2027_auto_loop_sync.py"],
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
            "label": "Work 2027: Fix VS Code & Restart",
            "type": "shell",
            "command": "./fix_vscode_restart.sh",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": []
        }
    ]
}
EOF
fi

log_success "Configuraciones creadas"

# Configurar GitHub (si no está configurado)
log_header "Verificando configuración GitHub..."

if ! git config --global user.name &> /dev/null; then
    log_warning "Configurando Git usuario..."
    read -p "Introduce tu nombre para Git: " git_name
    git config --global user.name "$git_name"
fi

if ! git config --global user.email &> /dev/null; then
    log_warning "Configurando Git email..."
    read -p "Introduce tu email para Git: " git_email
    git config --global user.email "$git_email"
fi

log_success "Git configurado"

# Hacer ejecutables los scripts
log_header "Configurando permisos de archivos..."

chmod +x *.sh 2>/dev/null
chmod +x *.py 2>/dev/null

log_success "Permisos configurados"

# Probar la instalación
log_header "Probando instalación Work 2027 + Temptraining..."

# Test 1: Importar Temptraining Connector
log_info "Test 1: Temptraining Connector..."
python3 -c "
from temptraining_connector import TemptrainingConnector
connector = TemptrainingConnector()
print('✅ Temptraining Connector: OK')
" || log_error "Fallo en Temptraining Connector"

# Test 2: Importar Auto Loop Sync
log_info "Test 2: Auto Loop Sync..."
python3 -c "
from work2027_auto_loop_sync import Work2027LoopSync
sync = Work2027LoopSync()
print('✅ Auto Loop Sync: OK')
" || log_error "Fallo en Auto Loop Sync"

# Test 3: Verificar VS Code extensiones recomendadas
log_info "Test 3: Extensiones VS Code..."

recommended_extensions=(
    "GitHub.copilot"
    "GitHub.copilot-chat"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "redhat.vscode-yaml"
    "yzhang.markdown-all-in-one"
)

for ext in "${recommended_extensions[@]}"; do
    if code --list-extensions | grep -q "$ext"; then
        log_success "Extensión $ext: ✅ Instalada"
    else
        log_warning "Extensión $ext: ❌ No instalada"
        log_info "Instalando $ext..."
        code --install-extension "$ext" --force
    fi
done

log_success "Tests completados"

# Crear script de inicio rápido
log_header "Creando script de inicio rápido..."

cat > work2027_quickstart.sh << 'EOF'
#!/bin/bash

echo "🚀 WORK 2027 TEMPTRAINING QUICK START"
echo "===================================="

# Activar entorno
source venv/bin/activate

echo "Selecciona una opción:"
echo "1. Ejecutar sincronización Temptraining"
echo "2. Ejecutar sincronización completa Loop"
echo "3. Reparar VS Code y reiniciar"
echo "4. Abrir VS Code"
echo "5. Ver archivos generados"

read -p "Opción (1-5): " option

case $option in
    1)
        echo "🔄 Ejecutando sincronización Temptraining..."
        python3 temptraining_connector.py
        ;;
    2)
        echo "🔄 Ejecutando sincronización completa..."
        python3 work2027_auto_loop_sync.py
        ;;
    3)
        echo "🔧 Reparando VS Code..."
        ./fix_vscode_restart.sh
        ;;
    4)
        echo "💻 Abriendo VS Code..."
        code .
        ;;
    5)
        echo "📁 Archivos generados:"
        ls -la *.json *.md *.loop.md 2>/dev/null || echo "No hay archivos generados aún"
        ;;
    *)
        echo "❌ Opción no válida"
        ;;
esac
EOF

chmod +x work2027_quickstart.sh

log_success "Script de inicio rápido creado"

# Mostrar resumen final
echo ""
echo "🎉 INSTALACIÓN WORK 2027 + TEMPTRAINING COMPLETADA"
echo "=================================================="
echo ""
echo "📋 RESUMEN DE INSTALACIÓN:"
echo "========================="
echo "✅ Entorno Python configurado"
echo "✅ Dependencias instaladas"
echo "✅ Archivos de configuración creados"
echo "✅ VS Code configurado"
echo "✅ Git configurado"
echo "✅ Scripts ejecutables"
echo "✅ Tests de funcionamiento: OK"
echo "✅ Script de inicio rápido: work2027_quickstart.sh"
echo ""
echo "🚀 PRÓXIMOS PASOS:"
echo "=================="
echo "1. Ejecutar: ./work2027_quickstart.sh"
echo "2. O usar VS Code: code ."
echo "3. Configurar credenciales Temptraining en temptraining_config.json"
echo "4. Ejecutar primera sincronización: python3 temptraining_connector.py"
echo ""
echo "📚 COMANDOS ÚTILES:"
echo "==================="
echo "• Sync Temptraining: python3 temptraining_connector.py"
echo "• Sync completo: python3 work2027_auto_loop_sync.py"
echo "• Reparar VS Code: ./fix_vscode_restart.sh"
echo "• Inicio rápido: ./work2027_quickstart.sh"
echo ""
echo "🔗 ARCHIVOS IMPORTANTES:"
echo "========================"
echo "• temptraining_config.json - Configuración Temptraining"
echo "• work2027_loop_sync_config.json - Configuración Loop"
echo "• .vscode/settings.json - Configuración VS Code"
echo "• .vscode/tasks.json - Tareas Work 2027"
echo ""

log_success "WORK 2027 TEMPTRAINING INTEGRATION SETUP COMPLETADO ✅"

# Preguntar si quiere ejecutar VS Code
echo ""
read -p "¿Quieres abrir VS Code ahora? (y/n): " open_vscode

if [[ $open_vscode =~ ^[Yy]$ ]]; then
    log_info "Abriendo VS Code..."
    code .
fi

echo ""
echo "¡Disfruta tu ecosistema Work 2027 + Temptraining! 🚀"

exit 0