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
