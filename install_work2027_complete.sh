#!/bin/bash

# =============================================================================
# WORK 2027 - INSTALADOR COMPLETO
# =============================================================================
# Script maestro para configuración completa del ecosystem Work 2027
# Integra: VS Code + GitHub Copilot + Microsoft 365 + OneDrive
#
# Autor: Adrián Drix
# Fecha: Noviembre 2024
# Versión: 1.0

echo "🚀 WORK 2027 - INSTALADOR COMPLETO"
echo "=================================="
echo "Configurando ecosystem completo de automatización personal..."
echo ""

# Variables de configuración
WORKSPACE_PATH="/home/drixc/centro_estudio"
ONEDRIVE_PATH="$HOME/OneDrive/Work2027"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# Función para mostrar progreso
show_progress() {
    echo "⏳ $1..."
    sleep 1
}

# Función para confirmar éxito
show_success() {
    echo "✅ $1"
}

# Función para mostrar error
show_error() {
    echo "❌ $1"
    exit 1
}

echo "📋 COMPONENTES A INSTALAR:"
echo "- GitHub Copilot configuración avanzada"
echo "- Generador de logs diarios automático"
echo "- Integración Microsoft 365 Copilot"
echo "- Sistema de sincronización OneDrive"
echo "- Comandos personalizados VS Code"
echo "- Templates y prompts optimizados"
echo ""

read -p "¿Continuar con la instalación? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Instalación cancelada."
    exit 0
fi

echo ""
echo "🔧 INICIANDO INSTALACIÓN..."
echo ""

# 1. Verificar requisitos
show_progress "Verificando requisitos del sistema"

if ! command -v python3 &> /dev/null; then
    show_error "Python 3 no está instalado"
fi

if ! command -v rsync &> /dev/null; then
    show_error "rsync no está instalado"
fi

show_success "Requisitos verificados"

# 2. Crear estructura de directorios
show_progress "Creando estructura de directorios Work 2027"

mkdir -p "$ONEDRIVE_PATH"/{01_Python,02_IA_Copilot,03_Datos_y_Analytics,04_Web_y_Apps,05_Finanzas_y_Documentos,06_Backup_y_Sincronizacion}
mkdir -p "$ONEDRIVE_PATH/02_IA_Copilot"/{Prompts_M365,Templates}
mkdir -p "$ONEDRIVE_PATH/05_Finanzas_y_Documentos"/{Logs_Diarios,Informes_Ejecutivos,Reportes_Codigo}
mkdir -p "$WORKSPACE_PATH/.vscode"

show_success "Estructura de directorios creada"

# 3. Configurar VS Code y GitHub Copilot
show_progress "Configurando VS Code y GitHub Copilot"

# Ya se ejecutó anteriormente, verificar si existe
if [ -f "$WORKSPACE_PATH/.vscode/settings.json" ]; then
    show_success "Configuración VS Code encontrada"
else
    show_error "Configuración VS Code no encontrada. Ejecuta setup_copilot_work2027.sh primero"
fi

# 4. Configurar generador de logs automático
show_progress "Configurando generador de logs diarios"

if [ -f "$WORKSPACE_PATH/work2027_log_generator.py" ]; then
    chmod +x "$WORKSPACE_PATH/work2027_log_generator.py"
    show_success "Generador de logs configurado"
else
    show_error "Script de logs no encontrado"
fi

# 5. Configurar integración Microsoft 365
show_progress "Configurando integración Microsoft 365"

if [ -f "$WORKSPACE_PATH/work2027_m365_integration.py" ]; then
    chmod +x "$WORKSPACE_PATH/work2027_m365_integration.py"
    python3 "$WORKSPACE_PATH/work2027_m365_integration.py"
    show_success "Integración Microsoft 365 configurada"
else
    show_error "Script de integración M365 no encontrado"
fi

# 6. Crear script de ejecución diaria
show_progress "Creando script de ejecución diaria"

cat > "$WORKSPACE_PATH/work2027_daily_run.sh" << 'EOF'
#!/bin/bash

# Script de ejecución diaria Work 2027
echo "🌅 Ejecutando workflow diario Work 2027..."

cd "/home/drixc/centro_estudio"

# 1. Generar log diario
echo "📊 Generando log diario..."
python3 work2027_log_generator.py

# 2. Verificar sincronización
echo "🔄 Verificando sincronización..."
./sync_work2027_onedrive.sh

echo "✅ Workflow diario completado!"
echo "🤖 Recuerda ejecutar los comandos en Microsoft 365 Copilot"
EOF

chmod +x "$WORKSPACE_PATH/work2027_daily_run.sh"
show_success "Script diario creado"

# 7. Crear tarea automatizada en VS Code
show_progress "Configurando tareas automatizadas VS Code"

# Actualizar tasks.json
cat > "$WORKSPACE_PATH/.vscode/tasks.json" << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Work 2027: Workflow Diario Completo",
            "type": "shell",
            "command": "./work2027_daily_run.sh",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": true,
                "panel": "shared"
            },
            "problemMatcher": []
        },
        {
            "label": "Work 2027: Solo Generar Log",
            "type": "shell",
            "command": "python3",
            "args": ["work2027_log_generator.py"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "Work 2027: Solo Sincronizar OneDrive",
            "type": "shell",
            "command": "./sync_work2027_onedrive.sh",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "Work 2027: Configurar M365",
            "type": "shell",
            "command": "python3",
            "args": ["work2027_m365_integration.py"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        }
    ]
}
EOF

show_success "Tareas VS Code configuradas"

# 8. Crear documentación de uso
show_progress "Generando documentación"

cat > "$WORKSPACE_PATH/WORK2027_GUIA_COMPLETA.md" << 'EOF'
# 📚 GUÍA COMPLETA WORK 2027

## 🚀 Sistema de Automatización Personal y Profesional

### 📋 Componentes Instalados

#### 1. 💻 GitHub Copilot (VS Code)
- **Extensiones**: GitHub Copilot + GitHub Copilot Chat
- **Comandos personalizados**:
  - `/work2027-summary` - Resume progreso diario
  - `/work2027-code-review` - Revisa código
  - `/work2027-optimize` - Optimiza para automatización
  - `/work2027-document` - Genera documentación

#### 2. 📊 Generador de Logs Automático
- **Script**: `work2027_log_generator.py`
- **Función**: Escanea cambios diarios y genera reportes
- **Salida**: Logs en OneDrive/Work2027/05_Finanzas_y_Documentos/Logs_Diarios/

#### 3. 🤖 Integración Microsoft 365
- **Script**: `work2027_m365_integration.py`
- **Prompts**: Configurados en OneDrive/Work2027/02_IA_Copilot/
- **Templates**: Documentos automáticos

#### 4. 🔄 Sincronización OneDrive
- **Script**: `sync_work2027_onedrive.sh`
- **Función**: Mantiene VS Code y OneDrive sincronizados

### 🎯 Uso Diario

#### Opción 1: Automático Completo
```bash
# Ejecutar workflow completo
./work2027_daily_run.sh
```

#### Opción 2: Desde VS Code
1. Abrir Command Palette (`Ctrl+Shift+P`)
2. Buscar "Tasks: Run Task"
3. Seleccionar "Work 2027: Workflow Diario Completo"

#### Opción 3: Componentes Individuales
```bash
# Solo generar log
python3 work2027_log_generator.py

# Solo sincronizar
./sync_work2027_onedrive.sh

# Solo configurar M365
python3 work2027_m365_integration.py
```

### 🔗 Flujo de Trabajo Integrado

1. **VS Code + GitHub Copilot** → Desarrollas código
2. **Script automático** → Escanea cambios y genera logs
3. **OneDrive** → Sincroniza archivos
4. **Microsoft 365 Copilot** → Lee logs y genera informes Word

### 📁 Estructura OneDrive Work 2027

```
OneDrive/Work2027/
├── 01_Python/                    # Código sincronizado desde VS Code
├── 02_IA_Copilot/               # Prompts y configuraciones
│   ├── Prompts_M365/            # Prompts para Microsoft 365
│   └── Templates/               # Plantillas documentos
├── 03_Datos_y_Analytics/        # Análisis de datos
├── 04_Web_y_Apps/              # Desarrollo web
├── 05_Finanzas_y_Documentos/   # Gestión documental
│   ├── Logs_Diarios/           # Logs automáticos diarios
│   ├── Informes_Ejecutivos/    # Informes Word generados
│   └── Reportes_Codigo/        # Reportes de código
└── 06_Backup_y_Sincronizacion/ # Respaldos
```

### 🤖 Comandos Microsoft 365 Copilot

Después de ejecutar el workflow diario, usa estos comandos en M365:

```
@Work2027 informe diario
@Work2027 análisis semanal
@Work2027 backup reportes
@Work2027 sync status
@Work2027 optimize workflow
```

### ⚙️ Configuración Personalizada

#### GitHub Copilot (VS Code)
- Settings en `.vscode/settings.json`
- Comandos personalizados configurados
- Locale: español

#### Microsoft 365 Copilot
- Prompt maestro en `02_IA_Copilot/Prompts_M365/prompt_maestro_m365.md`
- Templates en `02_IA_Copilot/Templates/`
- Comandos rápidos en `02_IA_Copilot/Prompts_M365/comandos_rapidos.json`

### 🔧 Troubleshooting

#### Problema: No se genera el log
```bash
# Verificar permisos
chmod +x work2027_log_generator.py
python3 work2027_log_generator.py
```

#### Problema: No sincroniza OneDrive
```bash
# Verificar rsync
which rsync
./sync_work2027_onedrive.sh
```

#### Problema: Microsoft 365 no responde
1. Verificar que el prompt maestro esté copiado
2. Usar `@Work2027` antes de cada comando
3. Revisar archivos en OneDrive/Work2027/02_IA_Copilot/

### 📞 Soporte

Para dudas o problemas:
1. Revisar logs en `05_Finanzas_y_Documentos/Logs_Diarios/`
2. Ejecutar scripts individuales para debug
3. Verificar permisos de archivos

---
**Versión**: 1.0 | **Fecha**: Noviembre 2024 | **Autor**: Adrián Drix
EOF

show_success "Documentación creada"

# 9. Ejecutar primera prueba
show_progress "Ejecutando primera prueba del sistema"

echo "🧪 Prueba 1: Generador de logs..."
if python3 "$WORKSPACE_PATH/work2027_log_generator.py"; then
    show_success "Generador de logs funcionando"
else
    show_error "Error en generador de logs"
fi

echo "🧪 Prueba 2: Sincronización..."
if "$WORKSPACE_PATH/sync_work2027_onedrive.sh"; then
    show_success "Sincronización funcionando"
else
    show_error "Error en sincronización"
fi

# 10. Resumen final
echo ""
echo "🎉 ¡INSTALACIÓN WORK 2027 COMPLETADA!"
echo "===================================="
echo ""
echo "📁 ARCHIVOS CREADOS:"
echo "- work2027_log_generator.py (Generador logs)"
echo "- work2027_m365_integration.py (Integración M365)"
echo "- work2027_daily_run.sh (Workflow diario)"
echo "- WORK2027_GUIA_COMPLETA.md (Documentación)"
echo "- .vscode/settings.json (Configuración VS Code)"
echo "- .vscode/tasks.json (Tareas automatizadas)"
echo ""
echo "🎯 PRÓXIMOS PASOS:"
echo ""
echo "1. 💻 GITHUB COPILOT (VS CODE):"
echo "   - Abre VS Code Copilot Chat (Ctrl+Shift+I)"
echo "   - Copia prompt desde .vscode/prompt_conexion_work2027.py"
echo "   - Pega y confirma configuración"
echo ""
echo "2. 🤖 MICROSOFT 365 COPILOT:"
echo "   - Abre Word/Excel/PowerPoint"
echo "   - Copia prompt desde OneDrive/Work2027/02_IA_Copilot/Prompts_M365/prompt_maestro_m365.md"
echo "   - Pega en Microsoft 365 Copilot"
echo "   - Confirma con '@Work2027 configuración lista'"
echo ""
echo "3. ⚡ EJECUCIÓN DIARIA:"
echo "   - Comando: ./work2027_daily_run.sh"
echo "   - O desde VS Code: Ctrl+Shift+P → 'Work 2027: Workflow Diario Completo'"
echo ""
echo "4. 📚 DOCUMENTACIÓN COMPLETA:"
echo "   - Lee WORK2027_GUIA_COMPLETA.md para detalles"
echo ""
echo "🚀 ¡Tu ecosystem Work 2027 está 100% operativo!"
echo ""

# Crear archivo de estado de instalación
cat > "$WORKSPACE_PATH/work2027_install_status.json" << EOF
{
    "instalacion_completada": true,
    "fecha_instalacion": "$TIMESTAMP",
    "version": "1.0",
    "componentes": {
        "github_copilot": true,
        "log_generator": true,
        "m365_integration": true,
        "onedrive_sync": true,
        "vs_code_tasks": true,
        "documentacion": true
    },
    "proximos_pasos": [
        "Configurar GitHub Copilot Chat",
        "Configurar Microsoft 365 Copilot",
        "Ejecutar primer workflow diario"
    ]
}
EOF

show_success "Estado de instalación guardado en work2027_install_status.json"

echo ""
echo "🎯 INSTALACIÓN COMPLETADA EXITOSAMENTE"
echo "Timestamp: $TIMESTAMP"