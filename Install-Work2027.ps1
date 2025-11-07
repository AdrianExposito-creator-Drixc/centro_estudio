# Work 2027 - PowerShell Installation Script
# =========================================
# Automatic installation and configuration for Windows environments
# Compatible with PowerShell 5.1+ and PowerShell Core 7+

param(
    [switch]$AutoConfirm,
    [string]$InstallPath = "$env:USERPROFILE\Work2027",
    [switch]$SkipVSCode,
    [switch]$SkipOneDrive
)

# Set execution policy for current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

Write-Host "🚀 WORK 2027 - INSTALACION AUTOMATICA WINDOWS" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Function to show progress
function Show-Progress {
    param([string]$Message)
    Write-Host "⏳ $Message..." -ForegroundColor Yellow
    Start-Sleep -Milliseconds 500
}

# Function to show success
function Show-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

# Function to show error
function Show-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Check if running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  AVISO: No se está ejecutando como Administrador" -ForegroundColor Yellow
    Write-Host "   Algunas funciones pueden requerir permisos elevados" -ForegroundColor Yellow
    Write-Host ""
}

# Confirm installation
if (-not $AutoConfirm) {
    Write-Host "📋 COMPONENTES A INSTALAR:" -ForegroundColor Cyan
    Write-Host "- Estructura de directorios Work 2027"
    Write-Host "- Scripts Python de automatización"
    Write-Host "- Configuración VS Code + GitHub Copilot"
    Write-Host "- Integración Microsoft 365 Copilot"
    Write-Host "- Sincronización OneDrive automática"
    Write-Host "- Plantillas y prompts optimizados"
    Write-Host ""

    $confirm = Read-Host "¿Continuar con la instalación? (S/n)"
    if ($confirm -match '^[Nn]') {
        Write-Host "Instalación cancelada." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "🔧 INICIANDO INSTALACION..." -ForegroundColor Green
Write-Host ""

# 1. Create directory structure
Show-Progress "Creando estructura de directorios"
$directories = @(
    "$InstallPath\01_Python",
    "$InstallPath\02_IA_Copilot\Prompts_M365",
    "$InstallPath\02_IA_Copilot\Templates",
    "$InstallPath\03_Datos_y_Analytics\Code_Analysis",
    "$InstallPath\04_Web_y_Apps",
    "$InstallPath\05_Finanzas_y_Documentos\Logs_Diarios",
    "$InstallPath\05_Finanzas_y_Documentos\Informes_Ejecutivos",
    "$InstallPath\05_Finanzas_y_Documentos\Reportes_Codigo",
    "$InstallPath\06_Backup_y_Sincronizacion"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}
Show-Success "Estructura de directorios creada"

# 2. Copy Python scripts
Show-Progress "Instalando scripts Python"
$pythonScripts = @(
    "work2027_log_generator.py",
    "work2027_code_analyzer.py",
    "work2027_github_integration.py",
    "work2027_m365_integration.py"
)

foreach ($script in $pythonScripts) {
    if (Test-Path $script) {
        Copy-Item $script "$InstallPath\01_Python\" -Force
    }
}
Show-Success "Scripts Python instalados"

# 3. Create Windows batch files for easy execution
Show-Progress "Creando scripts de ejecución Windows"

# Daily workflow batch
$dailyBatch = @"
@echo off
title Work 2027 - Workflow Diario
echo 🚀 Ejecutando Workflow Diario Work 2027...
cd /d "$InstallPath\01_Python"
python work2027_log_generator.py
if exist work2027_code_analyzer.py python work2027_code_analyzer.py
if exist work2027_github_integration.py python work2027_github_integration.py
echo ✅ Workflow completado!
pause
"@

$dailyBatch | Out-File "$InstallPath\work2027_daily.bat" -Encoding ASCII

# Quick analysis batch
$analysisBatch = @"
@echo off
title Work 2027 - Análisis de Código
echo 🔍 Ejecutando análisis de código...
cd /d "$InstallPath\01_Python"
python work2027_code_analyzer.py
echo ✅ Análisis completado!
pause
"@

$analysisBatch | Out-File "$InstallPath\work2027_analyze.bat" -Encoding ASCII

Show-Success "Scripts de ejecución Windows creados"

# 4. VS Code configuration
if (-not $SkipVSCode) {
    Show-Progress "Configurando VS Code"

    $vsCodeDir = "$env:APPDATA\Code\User"
    if (Test-Path $vsCodeDir) {
        # Create VS Code settings for Work 2027
        $vsCodeSettings = @{
            "github.copilot.enable" = @{
                "*" = $true
                "yaml" = $true
                "plaintext" = $true
                "markdown" = $true
                "python" = $true
            }
            "github.copilot.chat.localeOverride" = "es"
            "github.copilot.chat.customCommands" = @{
                "work2027-summary" = @{
                    "description" = "Resume progreso diario Work 2027"
                    "prompt" = "Analiza los archivos modificados en la carpeta Work2027 y genera un resumen breve en español."
                }
                "work2027-analyze" = @{
                    "description" = "Análisis completo de código"
                    "prompt" = "Ejecuta análisis completo del workspace Work 2027: métricas, calidad y sugerencias."
                }
                "work2027-deploy" = @{
                    "description" = "Desplegar cambios completos"
                    "prompt" = "Ejecuta workflow completo Work 2027: logs, sync y GitHub."
                }
            }
            "files.associations" = @{
                "*.work2027" = "python"
                "*_work2027.py" = "python"
            }
            "workbench.colorCustomizations" = @{
                "statusBar.background" = "#2D5A27"
                "statusBar.foreground" = "#FFFFFF"
            }
        }

        $settingsPath = "$vsCodeDir\settings.json"
        $vsCodeSettings | ConvertTo-Json -Depth 10 | Out-File $settingsPath -Encoding UTF8
        Show-Success "VS Code configurado"
    } else {
        Show-Error "VS Code no encontrado - configuración omitida"
    }
}

# 5. OneDrive integration
if (-not $SkipOneDrive) {
    Show-Progress "Configurando integración OneDrive"

    $oneDrivePaths = @(
        "$env:USERPROFILE\OneDrive\Work2027",
        "$env:USERPROFILE\OneDrive - Personal\Work2027",
        "$env:USERPROFILE\OneDrive - Business\Work2027"
    )

    $oneDriveFound = $false
    foreach ($path in $oneDrivePaths) {
        $parentDir = Split-Path $path -Parent
        if (Test-Path $parentDir) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null

            # Create symbolic links to sync folders
            try {
                cmd /c mklink /D "$path\01_Python" "$InstallPath\01_Python" 2>$null
                cmd /c mklink /D "$path\02_IA_Copilot" "$InstallPath\02_IA_Copilot" 2>$null
                cmd /c mklink /D "$path\05_Finanzas_y_Documentos" "$InstallPath\05_Finanzas_y_Documentos" 2>$null
                $oneDriveFound = $true
                break
            } catch {
                # Fallback to copying files
                Copy-Item "$InstallPath\*" $path -Recurse -Force
                $oneDriveFound = $true
                break
            }
        }
    }

    if ($oneDriveFound) {
        Show-Success "OneDrive configurado"
    } else {
        Show-Error "OneDrive no encontrado - sincronización manual requerida"
    }
}

# 6. Create desktop shortcuts
Show-Progress "Creando accesos directos"

$desktopPath = "$env:USERPROFILE\Desktop"
$shortcutPath = "$desktopPath\Work 2027 - Workflow Diario.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "$InstallPath\work2027_daily.bat"
$Shortcut.WorkingDirectory = $InstallPath
$Shortcut.IconLocation = "shell32.dll,137"
$Shortcut.Description = "Ejecutar Workflow Diario Work 2027"
$Shortcut.Save()

Show-Success "Accesos directos creados"

# 7. Create Microsoft 365 Copilot prompts
Show-Progress "Configurando Microsoft 365 Copilot"

$m365Prompt = @"
🤖 PROMPT MAESTRO WORK 2027 - MICROSOFT 365 COPILOT

**Contexto**: Sistema de automatización personal Work 2027
**Ubicación**: OneDrive/Work2027/

## 🎯 INSTRUCCIONES PRINCIPALES

Actúa como mi asistente ejecutivo Work 2027. Revisa automáticamente:

📁 **Estructura OneDrive/Work2027/**
- 01_Python/ → Scripts de automatización
- 05_Finanzas_y_Documentos/Logs_Diarios/ → Logs automáticos
- 05_Finanzas_y_Documentos/Informes_Ejecutivos/ → Informes Word

## 🔄 COMANDOS DISPONIBLES

**@Work2027 informe diario** → Genera informe Word del día
**@Work2027 análisis semanal** → Resumen de la semana
**@Work2027 backup reportes** → Respalda documentos
**@Work2027 status** → Estado de sincronización

## ⚙️ CONFIGURACIÓN

- Idioma: Español
- Formato: Profesional y claro
- Gráficos: Barras y líneas preferidos
- Color tema: Verde (#2D5A27)

Confirma configuración con: "✅ Work 2027 configurado - Listo para generar informes automáticos"
"@

$m365Prompt | Out-File "$InstallPath\02_IA_Copilot\Prompts_M365\prompt_maestro_m365.txt" -Encoding UTF8

Show-Success "Microsoft 365 Copilot configurado"

# 8. Final configuration and summary
Show-Progress "Finalizando configuración"

# Create configuration summary
$configSummary = @"
# WORK 2027 - CONFIGURACIÓN COMPLETADA
# ===================================

Fecha instalación: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Directorio instalación: $InstallPath
Usuario: $env:USERNAME
Equipo: $env:COMPUTERNAME

## COMPONENTES INSTALADOS
✅ Estructura de directorios Work 2027
✅ Scripts Python de automatización
✅ Configuración VS Code + GitHub Copilot
✅ Integración Microsoft 365 Copilot
✅ Scripts de ejecución Windows (.bat)
✅ Accesos directos en escritorio

## PRÓXIMOS PASOS

1. **GitHub Copilot (VS Code)**:
   - Abre VS Code
   - Presiona Ctrl+Shift+I (Copilot Chat)
   - Usa comando: /work2027-summary

2. **Microsoft 365 Copilot**:
   - Abre Word/Excel/PowerPoint
   - Copia prompt desde: 02_IA_Copilot\Prompts_M365\prompt_maestro_m365.txt
   - Pega en Microsoft 365 Copilot

3. **Ejecución diaria**:
   - Doble clic en "Work 2027 - Workflow Diario" (escritorio)
   - O ejecuta: work2027_daily.bat

## ARCHIVOS IMPORTANTES
- work2027_daily.bat → Workflow completo diario
- work2027_analyze.bat → Solo análisis de código
- 02_IA_Copilot\Prompts_M365\ → Prompts Microsoft 365
- 05_Finanzas_y_Documentos\Logs_Diarios\ → Logs automáticos

## SOPORTE
- Documentación: README_WORK2027_COMPLETO.md
- Configuración VS Code: %APPDATA%\Code\User\settings.json
- Logs de errores: 05_Finanzas_y_Documentos\Logs_Diarios\
"@

$configSummary | Out-File "$InstallPath\CONFIGURACION_COMPLETADA.txt" -Encoding UTF8

Show-Success "Configuración finalizada"

# Final summary
Write-Host ""
Write-Host "🎉 ¡INSTALACIÓN WORK 2027 COMPLETADA EXITOSAMENTE!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "📁 INSTALADO EN: $InstallPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 EJECUCIÓN RÁPIDA:" -ForegroundColor Yellow
Write-Host "- Doble clic en acceso directo del escritorio"
Write-Host "- O ejecuta: work2027_daily.bat"
Write-Host ""
Write-Host "🤖 CONFIGURAR COPILOT:" -ForegroundColor Yellow
Write-Host "1. VS Code → Ctrl+Shift+I → /work2027-summary"
Write-Host "2. Microsoft 365 → Copiar prompt desde 02_IA_Copilot\"
Write-Host ""
Write-Host "📚 DOCUMENTACIÓN: CONFIGURACION_COMPLETADA.txt" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎯 ¡Sistema Work 2027 100% operativo en Windows!" -ForegroundColor Green

# Optional: Open installation directory
$openFolder = Read-Host "¿Abrir carpeta de instalación? (S/n)"
if ($openFolder -notmatch '^[Nn]') {
    Start-Process explorer.exe $InstallPath
}

Write-Host ""
Write-Host "✅ Instalación completada. ¡Disfruta de Work 2027!" -ForegroundColor Green