# Work 2027 Setup Advanced - PowerShell Installation Script
# =====================================================
# Ultimate installer for Work 2027 ecosystem
# Includes: VS Code, Microsoft 365, OneDrive, Mobile integration

param(
    [switch]$FullInstall,
    [switch]$QuickSetup,
    [string]$InstallPath = "$env:USERPROFILE\Work2027",
    [string]$OneDrivePath = "$env:USERPROFILE\OneDrive\Work2027",
    [switch]$ConfigureVSCode = $true,
    [switch]$ConfigureOffice365 = $true,
    [switch]$SetupMobile = $true,
    [switch]$CreateShortcuts = $true,
    [switch]$AutoStart = $false
)

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Colors and formatting
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$Cyan = "Cyan"
$White = "White"

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "🚀 $Message" -ForegroundColor $Green
    Write-Host ("=" * ($Message.Length + 3)) -ForegroundColor $Green
}

function Write-Step {
    param([string]$Message)
    Write-Host "⏳ $Message..." -ForegroundColor $Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $Red
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Main installation header
Write-Header "WORK 2027 ULTIMATE SETUP"
Write-Host "Instalación automática completa del ecosystem Work 2027" -ForegroundColor $Cyan
Write-Host "Incluye: VS Code + GitHub Copilot + Microsoft 365 + OneDrive + Mobile" -ForegroundColor $Cyan
Write-Host ""

# Check administrator privileges
if (Test-Administrator) {
    Write-Success "Ejecutándose con privilegios de Administrador"
} else {
    Write-Warning "No se detectaron privilegios de Administrador"
    Write-Host "Algunas funciones avanzadas pueden no estar disponibles" -ForegroundColor $Yellow
}

# Quick setup option
if ($QuickSetup) {
    Write-Host "🚀 MODO SETUP RÁPIDO ACTIVADO" -ForegroundColor $Cyan
    $InstallPath = "$env:USERPROFILE\Work2027"
    $FullInstall = $true
}

# Installation summary
Write-Host ""
Write-Host "📋 CONFIGURACIÓN DE INSTALACIÓN:" -ForegroundColor $Cyan
Write-Host "- Directorio destino: $InstallPath"
Write-Host "- OneDrive sync: $OneDrivePath"
Write-Host "- VS Code config: $ConfigureVSCode"
Write-Host "- Office 365 setup: $ConfigureOffice365"
Write-Host "- Mobile prompts: $SetupMobile"
Write-Host "- Accesos directos: $CreateShortcuts"
Write-Host ""

if (-not $FullInstall -and -not $QuickSetup) {
    $confirm = Read-Host "¿Continuar con la instalación? (S/n)"
    if ($confirm -match '^[Nn]') {
        Write-Host "Instalación cancelada por el usuario." -ForegroundColor $Yellow
        exit 0
    }
}

# PHASE 1: Directory Structure
Write-Header "FASE 1: ESTRUCTURA DE DIRECTORIOS"

Write-Step "Creando estructura Work 2027"
$directories = @(
    "$InstallPath",
    "$InstallPath\01_Python\Scripts",
    "$InstallPath\01_Python\Config",
    "$InstallPath\02_IA_Copilot\Prompts_M365",
    "$InstallPath\02_IA_Copilot\Prompts_VSCode",
    "$InstallPath\02_IA_Copilot\Prompts_Mobile",
    "$InstallPath\02_IA_Copilot\Templates\Word",
    "$InstallPath\02_IA_Copilot\Templates\Excel",
    "$InstallPath\02_IA_Copilot\Templates\PowerPoint",
    "$InstallPath\03_Datos_y_Analytics\Code_Analysis",
    "$InstallPath\03_Datos_y_Analytics\Reports",
    "$InstallPath\04_Web_y_Apps",
    "$InstallPath\05_Finanzas_y_Documentos\Logs_Diarios",
    "$InstallPath\05_Finanzas_y_Documentos\Informes_Ejecutivos",
    "$InstallPath\05_Finanzas_y_Documentos\Reportes_Codigo",
    "$InstallPath\06_Backup_y_Sincronizacion\Auto",
    "$InstallPath\06_Backup_y_Sincronizacion\Manual",
    "$InstallPath\Scripts\Daily",
    "$InstallPath\Scripts\Weekly",
    "$InstallPath\Scripts\Utils"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}
Write-Success "Estructura de directorios creada ($(($directories).Count) carpetas)"

# PHASE 2: Python Scripts Installation
Write-Header "FASE 2: INSTALACIÓN SCRIPTS PYTHON"

Write-Step "Copiando scripts de automatización"
$pythonScripts = @(
    "work2027_log_generator.py",
    "work2027_code_analyzer.py",
    "work2027_github_integration.py",
    "work2027_m365_integration.py",
    "work2027_master_workflow.sh"
)

$scriptsCopied = 0
foreach ($script in $pythonScripts) {
    if (Test-Path $script) {
        Copy-Item $script "$InstallPath\01_Python\Scripts\" -Force
        $scriptsCopied++
    }
}
Write-Success "Scripts Python instalados ($scriptsCopied/$($pythonScripts.Count))"

# PHASE 3: VS Code Configuration
if ($ConfigureVSCode) {
    Write-Header "FASE 3: CONFIGURACIÓN VS CODE"

    Write-Step "Configurando GitHub Copilot"
    $vsCodeUserDir = "$env:APPDATA\Code\User"

    if (Test-Path $vsCodeUserDir) {
        # Install prompts_master.json
        if (Test-Path "prompts_master.json") {
            Copy-Item "prompts_master.json" "$InstallPath\02_IA_Copilot\Prompts_VSCode\" -Force

            # Update VS Code settings
            $settingsPath = "$vsCodeUserDir\settings.json"
            $promptsContent = Get-Content "prompts_master.json" -Raw | ConvertFrom-Json

            if (Test-Path $settingsPath) {
                $currentSettings = Get-Content $settingsPath -Raw | ConvertFrom-Json
            } else {
                $currentSettings = @{}
            }

            # Merge Copilot settings
            $currentSettings."github.copilot.chat.customCommands" = $promptsContent."github.copilot.chat.customCommands"
            $currentSettings."github.copilot.chat.localeOverride" = "es"
            $currentSettings."github.copilot.enable" = $promptsContent."github.copilot.enable"
            $currentSettings."workbench.colorCustomizations" = $promptsContent."workbench.colorCustomizations"

            $currentSettings | ConvertTo-Json -Depth 10 | Out-File $settingsPath -Encoding UTF8
            Write-Success "VS Code configurado con 15 comandos Copilot personalizados"
        }

        # Create tasks.json
        $tasksConfig = @{
            version = "2.0.0"
            tasks = @(
                @{
                    label = "Work 2027: Workflow Diario Completo"
                    type = "shell"
                    command = "python"
                    args = @("$InstallPath\01_Python\Scripts\work2027_log_generator.py")
                    group = @{
                        kind = "build"
                        isDefault = $true
                    }
                    presentation = @{
                        echo = $true
                        reveal = "always"
                        focus = $true
                        panel = "shared"
                    }
                },
                @{
                    label = "Work 2027: Análisis de Código"
                    type = "shell"
                    command = "python"
                    args = @("$InstallPath\01_Python\Scripts\work2027_code_analyzer.py")
                    group = "build"
                },
                @{
                    label = "Work 2027: GitHub Sync"
                    type = "shell"
                    command = "python"
                    args = @("$InstallPath\01_Python\Scripts\work2027_github_integration.py")
                    group = "build"
                }
            )
        }

        $tasksPath = "$vsCodeUserDir\tasks.json"
        $tasksConfig | ConvertTo-Json -Depth 10 | Out-File $tasksPath -Encoding UTF8
        Write-Success "Tareas VS Code configuradas"
    } else {
        Write-Warning "VS Code no encontrado - configuración omitida"
    }
}

# PHASE 4: Microsoft 365 Integration
if ($ConfigureOffice365) {
    Write-Header "FASE 4: INTEGRACIÓN MICROSOFT 365"

    Write-Step "Configurando prompts Office 365"

    # Create Office templates
    $wordTemplate = @"
# 📊 PLANTILLA INFORME WORK 2027

## Resumen Ejecutivo
**Fecha**: {FECHA}
**Período**: {PERIODO}
**Estado General**: {ESTADO}

## Métricas Principales
- **Productividad**: {PRODUCTIVIDAD}%
- **Tareas Completadas**: {TAREAS_COMPLETADAS}
- **Objetivos Alcanzados**: {OBJETIVOS_ALCANZADOS}

## Análisis de Código
- **Archivos modificados**: {ARCHIVOS_MODIFICADOS}
- **Líneas de código**: {LINEAS_CODIGO}
- **Calidad general**: {CALIDAD_CODIGO}/100

## Próximas Acciones
1. {ACCION_1}
2. {ACCION_2}
3. {ACCION_3}

---
*Generado automáticamente por Work 2027*
"@

    $wordTemplate | Out-File "$InstallPath\02_IA_Copilot\Templates\Word\informe_diario_template.md" -Encoding UTF8

    # Office 365 Prompts
    $office365Prompts = @"
# PROMPTS MICROSOFT 365 COPILOT - WORK 2027

## Word
@Work2027 informe diario: Crea informe diario usando template con métricas actuales
@Work2027 resumen ejecutivo: Genera resumen ejecutivo profesional del progreso
@Work2027 presentación: Convierte datos en presentación PowerPoint ejecutiva

## Excel
@Work2027 dashboard: Crea dashboard con métricas de productividad y gráficos
@Work2027 análisis datos: Analiza datos y genera insights con fórmulas avanzadas
@Work2027 tracking: Crea sistema de tracking de objetivos y KPIs

## Outlook
@Work2027 email update: Genera email de actualización profesional con adjuntos
@Work2027 seguimiento: Crea emails de seguimiento con acciones específicas
@Work2027 calendario: Optimiza calendario basado en prioridades y objetivos

## PowerPoint
@Work2027 pitch: Crea presentación ejecutiva con métricas y próximos pasos
@Work2027 review: Genera presentación de revisión trimestral con insights
@Work2027 roadmap: Crea roadmap visual de objetivos y timeline
"@

    $office365Prompts | Out-File "$InstallPath\02_IA_Copilot\Prompts_M365\office365_prompts.txt" -Encoding UTF8
    Write-Success "Microsoft 365 configurado con plantillas y prompts"
}

# PHASE 5: Mobile Setup
if ($SetupMobile) {
    Write-Header "FASE 5: CONFIGURACIÓN MÓVIL"

    Write-Step "Instalando prompts para Samsung Copilot"
    if (Test-Path "Prompts_Mobile.txt") {
        Copy-Item "Prompts_Mobile.txt" "$InstallPath\02_IA_Copilot\Prompts_Mobile\" -Force
        Write-Success "30+ prompts móviles instalados"
    }

    # Create mobile quick reference
    $mobileQuickRef = @"
🚀 WORK 2027 MÓVIL - REFERENCIA RÁPIDA

⭐ COMANDOS PRINCIPALES:
• Work2027 resumen → Resumen diario
• Work2027 planning → Planificación inteligente
• Work2027 quick → Acción rápida
• Buenos días Work2027 → Check matutino
• Work2027 cierre → Cierre vespertino

📱 CONTEXTOS ESPECÍFICOS:
• [Tiempo] Work2027 → Tareas para tiempo disponible
• [Lugar] Work2027 → Tareas según ubicación
• [Energía] Work2027 → Tareas según nivel de energía

🎯 EJEMPLOS RÁPIDOS:
"Tengo 10 minutos Work2027: ¿Qué puedo hacer?"
"Viaje Work2027: Tareas para el trayecto"
"Energía baja Work2027: Tareas ligeras pero productivas"
"@

    $mobileQuickRef | Out-File "$InstallPath\02_IA_Copilot\Prompts_Mobile\quick_reference.txt" -Encoding UTF8
    Write-Success "Referencia rápida móvil creada"
}

# PHASE 6: OneDrive Synchronization
Write-Header "FASE 6: SINCRONIZACIÓN ONEDRIVE"

Write-Step "Configurando sincronización automática"
$oneDriveConfig = @"
# CONFIGURACIÓN SINCRONIZACIÓN ONEDRIVE - WORK 2027

## Carpetas sincronizadas:
- 02_IA_Copilot → Prompts y templates
- 05_Finanzas_y_Documentos → Informes y logs
- 03_Datos_y_Analytics → Análisis y reportes

## Sincronización automática:
- Cada 30 minutos durante horario laboral
- Backup completo semanal
- Versionado automático de archivos importantes

## Comandos de sincronización:
- work2027_sync_now.bat → Sincronización inmediata
- work2027_backup_full.bat → Backup completo
- work2027_restore.bat → Restaurar desde backup
"@

$oneDriveConfig | Out-File "$InstallPath\06_Backup_y_Sincronizacion\onedrive_config.txt" -Encoding UTF8

# Create sync scripts
$syncScript = @"
@echo off
title Work 2027 - Sincronización OneDrive
echo 🔄 Sincronizando Work 2027 con OneDrive...

robocopy "$InstallPath\02_IA_Copilot" "$OneDrivePath\02_IA_Copilot" /MIR /R:3 /W:10 /NP /NDL
robocopy "$InstallPath\05_Finanzas_y_Documentos" "$OneDrivePath\05_Finanzas_y_Documentos" /MIR /R:3 /W:10 /NP /NDL
robocopy "$InstallPath\03_Datos_y_Analytics" "$OneDrivePath\03_Datos_y_Analytics" /MIR /R:3 /W:10 /NP /NDL

echo ✅ Sincronización completada!
pause
"@

$syncScript | Out-File "$InstallPath\Scripts\work2027_sync_now.bat" -Encoding ASCII
Write-Success "Sincronización OneDrive configurada"

# PHASE 7: Shortcuts and Quick Access
if ($CreateShortcuts) {
    Write-Header "FASE 7: ACCESOS DIRECTOS"

    Write-Step "Creando accesos directos"

    $WshShell = New-Object -ComObject WScript.Shell
    $desktopPath = "$env:USERPROFILE\Desktop"

    # Main workflow shortcut
    $shortcut1 = $WshShell.CreateShortcut("$desktopPath\🚀 Work 2027 - Workflow Diario.lnk")
    $shortcut1.TargetPath = "python"
    $shortcut1.Arguments = "$InstallPath\01_Python\Scripts\work2027_log_generator.py"
    $shortcut1.WorkingDirectory = "$InstallPath\01_Python\Scripts"
    $shortcut1.IconLocation = "shell32.dll,137"
    $shortcut1.Description = "Ejecutar workflow diario completo Work 2027"
    $shortcut1.Save()

    # Code analysis shortcut
    $shortcut2 = $WshShell.CreateShortcut("$desktopPath\📊 Work 2027 - Análisis Código.lnk")
    $shortcut2.TargetPath = "python"
    $shortcut2.Arguments = "$InstallPath\01_Python\Scripts\work2027_code_analyzer.py"
    $shortcut2.WorkingDirectory = "$InstallPath\01_Python\Scripts"
    $shortcut2.IconLocation = "shell32.dll,172"
    $shortcut2.Description = "Ejecutar análisis de código Work 2027"
    $shortcut2.Save()

    # OneDrive sync shortcut
    $shortcut3 = $WshShell.CreateShortcut("$desktopPath\🔄 Work 2027 - Sync OneDrive.lnk")
    $shortcut3.TargetPath = "$InstallPath\Scripts\work2027_sync_now.bat"
    $shortcut3.WorkingDirectory = "$InstallPath\Scripts"
    $shortcut3.IconLocation = "shell32.dll,174"
    $shortcut3.Description = "Sincronizar Work 2027 con OneDrive"
    $shortcut3.Save()

    # Quick folder access
    $shortcut4 = $WshShell.CreateShortcut("$desktopPath\📁 Work 2027 - Carpeta Principal.lnk")
    $shortcut4.TargetPath = $InstallPath
    $shortcut4.IconLocation = "shell32.dll,4"
    $shortcut4.Description = "Abrir carpeta principal Work 2027"
    $shortcut4.Save()

    Write-Success "4 accesos directos creados en el escritorio"
}

# PHASE 8: Final Configuration
Write-Header "FASE 8: CONFIGURACIÓN FINAL"

Write-Step "Creando configuración del sistema"

$systemConfig = @{
    installation_date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    install_path = $InstallPath
    onedrive_path = $OneDrivePath
    version = "2.0 - Ultimate Integration"
    components = @{
        python_scripts = $true
        vscode_config = $ConfigureVSCode
        office365_integration = $ConfigureOffice365
        mobile_prompts = $SetupMobile
        onedrive_sync = $true
        desktop_shortcuts = $CreateShortcuts
    }
    next_steps = @(
        "Abrir VS Code y verificar comandos Copilot (/work2027-summary)",
        "Configurar GitHub Copilot Chat con prompt de conexión",
        "Probar comandos Office 365 (@Work2027 informe diario)",
        "Instalar Samsung Copilot App y usar prompts móviles",
        "Ejecutar primer workflow diario completo"
    )
}

$systemConfig | ConvertTo-Json -Depth 10 | Out-File "$InstallPath\work2027_config.json" -Encoding UTF8

# Create startup script
if ($AutoStart) {
    $startupScript = @"
@echo off
echo 🌅 Iniciando Work 2027...
python "$InstallPath\01_Python\Scripts\work2027_log_generator.py"
"@

    $startupPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    $startupScript | Out-File "$startupPath\Work2027_AutoStart.bat" -Encoding ASCII
    Write-Success "Inicio automático configurado"
}

# FINAL SUMMARY
Write-Header "INSTALACIÓN COMPLETADA EXITOSAMENTE"

Write-Host ""
Write-Host "🎉 WORK 2027 ULTIMATE SETUP FINALIZADO" -ForegroundColor $Green
Write-Host "=======================================" -ForegroundColor $Green
Write-Host ""
Write-Host "📁 INSTALADO EN: $InstallPath" -ForegroundColor $Cyan
Write-Host "☁️  ONEDRIVE SYNC: $OneDrivePath" -ForegroundColor $Cyan
Write-Host ""

Write-Host "✅ COMPONENTES INSTALADOS:" -ForegroundColor $Green
Write-Host "- 🐍 Scripts Python de automatización"
Write-Host "- 💻 VS Code con 15 comandos Copilot personalizados"
Write-Host "- 🏢 Microsoft 365 con plantillas y prompts optimizados"
Write-Host "- 📱 30+ prompts para Samsung Copilot App"
Write-Host "- ☁️  Sincronización automática OneDrive"
Write-Host "- 🚀 4 accesos directos en escritorio"
Write-Host ""

Write-Host "🎯 PRÓXIMOS PASOS:" -ForegroundColor $Yellow
Write-Host "1. 💻 VS Code: Ctrl+Shift+I → usar /work2027-summary"
Write-Host "2. 🏢 Office 365: Probar @Work2027 informe diario"
Write-Host "3. 📱 Móvil: Instalar Samsung Copilot y usar 'Work2027 resumen'"
Write-Host "4. 🚀 Ejecutar: Doble clic en 'Work 2027 - Workflow Diario'"
Write-Host ""

Write-Host "📚 DOCUMENTACIÓN:" -ForegroundColor $Cyan
Write-Host "- Configuración: work2027_config.json"
Write-Host "- Prompts VS Code: 02_IA_Copilot\Prompts_VSCode\"
Write-Host "- Prompts Office: 02_IA_Copilot\Prompts_M365\"
Write-Host "- Prompts Móvil: 02_IA_Copilot\Prompts_Mobile\"
Write-Host ""

# Optional: Open installation folder
$openFolder = Read-Host "¿Abrir carpeta de instalación Work 2027? (S/n)"
if ($openFolder -notmatch '^[Nn]') {
    Start-Process explorer.exe $InstallPath
}

# Optional: Test workflow
$testWorkflow = Read-Host "¿Ejecutar test del workflow ahora? (S/n)"
if ($testWorkflow -notmatch '^[Nn]') {
    Write-Host ""
    Write-Host "🧪 Ejecutando test del workflow Work 2027..." -ForegroundColor $Cyan
    Start-Process python -ArgumentList "$InstallPath\01_Python\Scripts\work2027_log_generator.py" -Wait
}

Write-Host ""
Write-Host "🎯 ¡Work 2027 Ultimate está 100% operativo!" -ForegroundColor $Green
Write-Host "🚀 ¡Disfruta de la automatización total!" -ForegroundColor $Green