# 🔄 WORK 2027 DOCUMENT CONVERTER
# ===================================
# Script automatizado para convertir Markdown a Word/PowerPoint profesional

## 📄 CONVERSIÓN AUTOMÁTICA A WORD

### 🛠️ PowerShell Script para Word (.docx)

```powershell
# Convert_Work2027_to_Word.ps1
param(
    [string]$InputFile = "Work2027_Executive_Word_Template.md",
    [string]$OutputFile = "Work2027_ExecutiveReport.docx",
    [switch]$Professional,
    [switch]$OpenAfterConvert
)

Write-Host "📄 WORK 2027 DOCUMENT CONVERTER" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

# Function to convert Markdown to Word using Pandoc
function Convert-MarkdownToWord {
    param(
        [string]$InputPath,
        [string]$OutputPath,
        [bool]$ProfessionalFormat = $true
    )

    Write-Host "🔄 Convirtiendo Markdown a Word..." -ForegroundColor Yellow

    # Check if Pandoc is installed
    if (!(Get-Command "pandoc" -ErrorAction SilentlyContinue)) {
        Write-Warning "⚠️ Pandoc no encontrado. Instalando..."

        # Install Pandoc via Chocolatey or direct download
        if (Get-Command "choco" -ErrorAction SilentlyContinue) {
            choco install pandoc -y
        } else {
            Write-Host "📥 Descarga Pandoc desde: https://pandoc.org/installing.html" -ForegroundColor Cyan
            return $false
        }
    }

    # Professional formatting options
    if ($ProfessionalFormat) {
        $pandocArgs = @(
            $InputPath,
            "-o", $OutputPath,
            "--from=markdown+smart",
            "--to=docx",
            "--toc",
            "--toc-depth=3",
            "--highlight-style=tango",
            "--reference-doc=work2027_template.docx"
        )
    } else {
        $pandocArgs = @(
            $InputPath,
            "-o", $OutputPath,
            "--from=markdown",
            "--to=docx"
        )
    }

    try {
        & pandoc @pandocArgs
        Write-Host "✅ Conversión completada: $OutputPath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "❌ Error en conversión: $($_.Exception.Message)"
        return $false
    }
}

# Function to create Word template with Work 2027 styling
function New-Work2027WordTemplate {
    Write-Host "🎨 Creando template Word Work 2027..." -ForegroundColor Yellow

    try {
        # Create Word application
        $Word = New-Object -ComObject Word.Application
        $Word.Visible = $false
        $Doc = $Word.Documents.Add()

        # Set up Work 2027 styling
        $Doc.Range().Font.Name = "Segoe UI"
        $Doc.Range().Font.Size = 11

        # Create custom styles
        $Styles = $Doc.Styles

        # Heading 1 Style (Work 2027 Green)
        $Heading1 = $Styles.Item("Heading 1")
        $Heading1.Font.Name = "Segoe UI"
        $Heading1.Font.Size = 18
        $Heading1.Font.Bold = $true
        $Heading1.Font.Color = 2968103  # #2D5A27 in decimal

        # Heading 2 Style (VS Code Blue)
        $Heading2 = $Styles.Item("Heading 2")
        $Heading2.Font.Name = "Segoe UI"
        $Heading2.Font.Size = 14
        $Heading2.Font.Bold = $true
        $Heading2.Font.Color = 14120960  # #0078D4 in decimal

        # Save template
        $TemplatePath = ".\work2027_template.docx"
        $Doc.SaveAs2($TemplatePath)
        $Doc.Close()
        $Word.Quit()

        Write-Host "✅ Template creado: $TemplatePath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "❌ Error creando template: $($_.Exception.Message)"
        return $false
    }
}

# Function to enhance Word document with Work 2027 formatting
function Add-Work2027Formatting {
    param([string]$DocPath)

    Write-Host "🎨 Aplicando formato Work 2027..." -ForegroundColor Yellow

    try {
        $Word = New-Object -ComObject Word.Application
        $Word.Visible = $false
        $Doc = $Word.Documents.Open($DocPath)

        # Add cover page
        $CoverPage = $Doc.Range(0, 0)
        $CoverPage.InsertBreak(7)  # Page break
        $CoverPage.InsertParagraphBefore()

        # Cover page content
        $CoverPage.Text = @"
WORK 2027 PRODUCTIVITY ECOSYSTEM
Executive Implementation Report

Status: Fully Operational
Score: 92/100
ROI: +1,330%

Date: $(Get-Date -Format "MMMM dd, yyyy")
Version: 2.0
"@

        $CoverPage.Font.Name = "Segoe UI"
        $CoverPage.Font.Size = 24
        $CoverPage.Font.Bold = $true
        $CoverPage.ParagraphFormat.Alignment = 1  # Center alignment

        # Add table of contents
        $TOC = $Doc.Range()
        $TOC.Collapse(0)  # Collapse to start
        $Doc.TablesOfContents.Add($TOC)

        # Add header/footer
        $Header = $Doc.Sections.Item(1).Headers.Item(1)
        $Header.Range.Text = "Work 2027 Executive Report - Confidential"
        $Header.Range.Font.Size = 10

        $Footer = $Doc.Sections.Item(1).Footers.Item(1)
        $Footer.Range.Text = "© 2025 Work 2027 Productivity Solutions"
        $Footer.Range.Font.Size = 10
        $Footer.Range.ParagraphFormat.Alignment = 1  # Center

        # Save enhanced document
        $Doc.Save()
        $Doc.Close()
        $Word.Quit()

        Write-Host "✅ Formato aplicado correctamente" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "❌ Error aplicando formato: $($_.Exception.Message)"
        return $false
    }
}

# Main conversion process
function Start-Work2027Conversion {
    Write-Host "🚀 Iniciando conversión Work 2027..." -ForegroundColor Green

    # Check input file exists
    if (!(Test-Path $InputFile)) {
        Write-Error "❌ Archivo no encontrado: $InputFile"
        return
    }

    # Create Word template if needed
    if ($Professional -and !(Test-Path "work2027_template.docx")) {
        New-Work2027WordTemplate
    }

    # Convert Markdown to Word
    $conversionSuccess = Convert-MarkdownToWord -InputPath $InputFile -OutputPath $OutputFile -ProfessionalFormat:$Professional

    if ($conversionSuccess -and $Professional) {
        # Apply additional formatting
        Add-Work2027Formatting -DocPath $OutputFile
    }

    # Open document if requested
    if ($OpenAfterConvert -and (Test-Path $OutputFile)) {
        Write-Host "📂 Abriendo documento..." -ForegroundColor Cyan
        Start-Process $OutputFile
    }

    # Summary
    Write-Host ""
    Write-Host "📊 CONVERSIÓN COMPLETADA" -ForegroundColor Green
    Write-Host "=========================" -ForegroundColor Green
    Write-Host "Input:  $InputFile" -ForegroundColor White
    Write-Host "Output: $OutputFile" -ForegroundColor White
    Write-Host "Size:   $((Get-Item $OutputFile).Length / 1KB) KB" -ForegroundColor White
    Write-Host ""
    Write-Host "🎯 ¡Documento Word Work 2027 listo!" -ForegroundColor Green
}

# Execute conversion
Start-Work2027Conversion
```

---

## 🎨 CONVERSIÓN A POWERPOINT

### 📊 PowerShell Script para PowerPoint (.pptx)

```powershell
# Convert_Work2027_to_PowerPoint.ps1
param(
    [string]$InputFile = "Work2027_PowerPoint_Template.md",
    [string]$OutputFile = "Work2027_ExecutivePresentation.pptx",
    [string]$TemplateStyle = "Executive"
)

function New-Work2027Presentation {
    param(
        [string]$SourceFile,
        [string]$OutputFile,
        [string]$Style
    )

    Write-Host "🎯 Creando presentación Work 2027..." -ForegroundColor Yellow

    try {
        # Create PowerPoint application
        $PowerPoint = New-Object -ComObject PowerPoint.Application
        $PowerPoint.Visible = $true
        $Presentation = $PowerPoint.Presentations.Add()

        # Set Work 2027 theme colors
        $ThemeColors = $Presentation.SlideMaster.Theme.ThemeColorScheme
        # Work 2027 Green: #2D5A27
        $ThemeColors.Colors(1).RGB = 2968103
        # VS Code Blue: #0078D4
        $ThemeColors.Colors(2).RGB = 14120960
        # M365 Orange: #FF6B35
        $ThemeColors.Colors(3).RGB = 3509503

        # Read markdown content and create slides
        $MarkdownContent = Get-Content $SourceFile -Raw
        $Slides = $MarkdownContent -split "### 📑 \*\*SLIDE \d+:"

        foreach ($SlideContent in $Slides) {
            if ($SlideContent.Trim()) {
                $Slide = $Presentation.Slides.Add($Presentation.Slides.Count + 1, 12)  # ppLayoutBlank

                # Extract title and content
                $Lines = $SlideContent -split "`n"
                $Title = ($Lines | Where-Object { $_ -match "```" } | Select-Object -First 1) -replace "```", ""

                if ($Title) {
                    # Add title
                    $TitleShape = $Slide.Shapes.AddTextbox(1, 50, 50, 600, 100)
                    $TitleShape.TextFrame.TextRange.Text = $Title
                    $TitleShape.TextFrame.TextRange.Font.Name = "Segoe UI"
                    $TitleShape.TextFrame.TextRange.Font.Size = 32
                    $TitleShape.TextFrame.TextRange.Font.Bold = $true
                    $TitleShape.TextFrame.TextRange.Font.Color.RGB = 2968103  # Work 2027 Green
                }

                # Add content
                $ContentText = ($Lines | Where-Object { $_ -notmatch "```" -and $_.Trim() }) -join "`n"
                $ContentShape = $Slide.Shapes.AddTextbox(1, 50, 150, 600, 400)
                $ContentShape.TextFrame.TextRange.Text = $ContentText
                $ContentShape.TextFrame.TextRange.Font.Name = "Segoe UI"
                $ContentShape.TextFrame.TextRange.Font.Size = 16
            }
        }

        # Save presentation
        $Presentation.SaveAs($OutputFile)
        Write-Host "✅ Presentación creada: $OutputFile" -ForegroundColor Green

        return $true
    }
    catch {
        Write-Error "❌ Error creando presentación: $($_.Exception.Message)"
        return $false
    }
    finally {
        if ($PowerPoint) {
            $PowerPoint.Quit()
        }
    }
}

# Execute PowerPoint creation
New-Work2027Presentation -SourceFile $InputFile -OutputFile $OutputFile -Style $TemplateStyle
```

---

## 📊 CONVERSIÓN AUTOMÁTICA CON M365 COPILOT

### 🤖 Script con @Work2027 Integration

```powershell
# M365_Work2027_Converter.ps1
function Invoke-M365Work2027Conversion {
    param(
        [string]$DocumentType = "ExecutiveReport",
        [string]$InputMarkdown,
        [string]$OutputFormat = "docx"
    )

    Write-Host "🤖 Conversión automática con M365 Copilot..." -ForegroundColor Green

    # Prepare M365 Copilot prompt
    $CopilotPrompt = @"
@Work2027 convertir markdown a documento ejecutivo profesional

Contenido source:
$InputMarkdown

Formato requerido:
- Portada profesional con branding Work 2027
- Índice automático con navegación
- Tablas formateadas con estilo corporativo
- Gráficos y visualizaciones optimizadas
- Colores Work 2027: #2D5A27 (verde), #0078D4 (azul), #FF6B35 (naranja)
- Footer con copyright y confidencialidad
- Headers con título del documento

Estilo: Corporativo, ejecutivo, con impacto visual
Longitud: Documento completo manteniendo toda la información
"@

    # Instructions for manual M365 Copilot usage
    Write-Host ""
    Write-Host "🎯 INSTRUCCIONES PARA M365 COPILOT:" -ForegroundColor Yellow
    Write-Host "====================================" -ForegroundColor Yellow
    Write-Host "1. Abrir Microsoft Word" -ForegroundColor White
    Write-Host "2. Activar Copilot (ícono Copilot en ribbon)" -ForegroundColor White
    Write-Host "3. Copiar y pegar el siguiente prompt:" -ForegroundColor White
    Write-Host ""
    Write-Host $CopilotPrompt -ForegroundColor Cyan
    Write-Host ""
    Write-Host "4. Esperar generación automática del documento" -ForegroundColor White
    Write-Host "5. Revisar y ajustar formato si necesario" -ForegroundColor White
    Write-Host "6. Guardar como: Work2027_ExecutiveReport.docx" -ForegroundColor White

    # Copy prompt to clipboard
    $CopilotPrompt | Set-Clipboard
    Write-Host ""
    Write-Host "📋 Prompt copiado al clipboard - Listo para pegar en M365!" -ForegroundColor Green
}

# Execute M365 conversion helper
Invoke-M365Work2027Conversion -InputMarkdown (Get-Content "Work2027_Executive_Word_Template.md" -Raw)
```

---

## 🎨 VISUALIZACIÓN Y GRÁFICOS

### 📊 Script para Gráficos Excel

```powershell
# Work2027_Excel_Charts.ps1
function New-Work2027ExcelDashboard {
    Write-Host "📊 Creando dashboard Excel Work 2027..." -ForegroundColor Yellow

    try {
        $Excel = New-Object -ComObject Excel.Application
        $Excel.Visible = $true
        $Workbook = $Excel.Workbooks.Add()
        $Worksheet = $Workbook.Worksheets.Item(1)
        $Worksheet.Name = "Work 2027 Dashboard"

        # ROI Data
        $Worksheet.Cells.Item(1, 1) = "Metric"
        $Worksheet.Cells.Item(1, 2) = "Before Work 2027"
        $Worksheet.Cells.Item(1, 3) = "After Work 2027"
        $Worksheet.Cells.Item(1, 4) = "Improvement %"

        $Worksheet.Cells.Item(2, 1) = "Development Productivity"
        $Worksheet.Cells.Item(2, 2) = 100
        $Worksheet.Cells.Item(2, 3) = 400
        $Worksheet.Cells.Item(2, 4) = 300

        $Worksheet.Cells.Item(3, 1) = "Documentation Efficiency"
        $Worksheet.Cells.Item(3, 2) = 100
        $Worksheet.Cells.Item(3, 3) = 300
        $Worksheet.Cells.Item(3, 4) = 200

        $Worksheet.Cells.Item(4, 1) = "Mobile Continuity"
        $Worksheet.Cells.Item(4, 2) = 100
        $Worksheet.Cells.Item(4, 3) = 250
        $Worksheet.Cells.Item(4, 4) = 150

        # Create chart
        $ChartRange = $Worksheet.Range("A1:D4")
        $Chart = $Worksheet.ChartObjects().Add(50, 100, 400, 250)
        $Chart.Chart.SetSourceData($ChartRange)
        $Chart.Chart.ChartType = 51  # xlColumnClustered
        $Chart.Chart.ChartTitle.Text = "Work 2027 Productivity Improvements"

        # Apply Work 2027 colors
        $Chart.Chart.SeriesCollection(1).Interior.Color = 2968103  # Work 2027 Green
        $Chart.Chart.SeriesCollection(2).Interior.Color = 14120960  # VS Code Blue
        $Chart.Chart.SeriesCollection(3).Interior.Color = 3509503   # M365 Orange

        # Save workbook
        $Workbook.SaveAs("Work2027_Metrics_Dashboard.xlsx")
        Write-Host "✅ Dashboard Excel creado exitosamente" -ForegroundColor Green

    }
    catch {
        Write-Error "❌ Error creando dashboard: $($_.Exception.Message)"
    }
}

# Execute Excel dashboard creation
New-Work2027ExcelDashboard
```

---

## 🔄 BATCH CONVERSION SCRIPT

### 🚀 Script Master para Conversión Completa

```powershell
# Work2027_Complete_Converter.ps1
param(
    [switch]$All,
    [switch]$WordOnly,
    [switch]$PowerPointOnly,
    [switch]$ExcelOnly
)

Write-Host "🚀 WORK 2027 COMPLETE DOCUMENT CONVERTER" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

$ConversionResults = @()

function ConvertAll-Work2027Documents {
    Write-Host "📄 Iniciando conversión completa..." -ForegroundColor Yellow

    # Word Document
    if ($All -or $WordOnly) {
        Write-Host "`n1️⃣ Convirtiendo a Word..." -ForegroundColor Cyan
        try {
            .\Convert_Work2027_to_Word.ps1 -Professional -OpenAfterConvert:$false
            $ConversionResults += "✅ Word: Work2027_ExecutiveReport.docx"
        }
        catch {
            $ConversionResults += "❌ Word: Error en conversión"
        }
    }

    # PowerPoint Presentation
    if ($All -or $PowerPointOnly) {
        Write-Host "`n2️⃣ Convirtiendo a PowerPoint..." -ForegroundColor Cyan
        try {
            .\Convert_Work2027_to_PowerPoint.ps1
            $ConversionResults += "✅ PowerPoint: Work2027_ExecutivePresentation.pptx"
        }
        catch {
            $ConversionResults += "❌ PowerPoint: Error en conversión"
        }
    }

    # Excel Dashboard
    if ($All -or $ExcelOnly) {
        Write-Host "`n3️⃣ Creando dashboard Excel..." -ForegroundColor Cyan
        try {
            .\Work2027_Excel_Charts.ps1
            $ConversionResults += "✅ Excel: Work2027_Metrics_Dashboard.xlsx"
        }
        catch {
            $ConversionResults += "❌ Excel: Error en creación"
        }
    }

    # Move files to OneDrive structure
    Write-Host "`n4️⃣ Organizando en OneDrive..." -ForegroundColor Cyan
    $OneDrivePath = "$env:OneDrive\Work2027\Executive_Reports"

    if (!(Test-Path $OneDrivePath)) {
        New-Item -Path $OneDrivePath -ItemType Directory -Force
    }

    $FilesToMove = @(
        "Work2027_ExecutiveReport.docx",
        "Work2027_ExecutivePresentation.pptx",
        "Work2027_Metrics_Dashboard.xlsx"
    )

    foreach ($file in $FilesToMove) {
        if (Test-Path $file) {
            Move-Item $file $OneDrivePath -Force
            Write-Host "📁 Movido: $file → OneDrive" -ForegroundColor Green
        }
    }
}

# Results summary
function Show-ConversionSummary {
    Write-Host "`n📊 RESUMEN DE CONVERSIÓN" -ForegroundColor Green
    Write-Host "=========================" -ForegroundColor Green

    foreach ($result in $ConversionResults) {
        Write-Host $result
    }

    $SuccessCount = ($ConversionResults | Where-Object { $_ -like "✅*" }).Count
    $TotalCount = $ConversionResults.Count

    Write-Host "`n🎯 Éxito: $SuccessCount/$TotalCount conversiones" -ForegroundColor $(if ($SuccessCount -eq $TotalCount) { "Green" } else { "Yellow" })
    Write-Host "📁 Ubicación: $env:OneDrive\Work2027\Executive_Reports\" -ForegroundColor Cyan
    Write-Host "`n🚀 ¡Documentos Work 2027 listos para uso ejecutivo!" -ForegroundColor Green
}

# Execute based on parameters
if ($All) {
    ConvertAll-Work2027Documents
} elseif ($WordOnly) {
    .\Convert_Work2027_to_Word.ps1 -Professional
} elseif ($PowerPointOnly) {
    .\Convert_Work2027_to_PowerPoint.ps1
} elseif ($ExcelOnly) {
    .\Work2027_Excel_Charts.ps1
} else {
    Write-Host "Uso: .\Work2027_Complete_Converter.ps1 [-All|-WordOnly|-PowerPointOnly|-ExcelOnly]" -ForegroundColor Yellow
    Write-Host "Ejemplo: .\Work2027_Complete_Converter.ps1 -All" -ForegroundColor Cyan
}

Show-ConversionSummary
```

---

## 📱 QUICK CONVERSION COMMANDS

### ⚡ Comandos Rápidos

```bash
# Para ejecutar conversión completa:
.\Work2027_Complete_Converter.ps1 -All

# Solo Word profesional:
.\Work2027_Complete_Converter.ps1 -WordOnly

# Solo PowerPoint ejecutivo:
.\Work2027_Complete_Converter.ps1 -PowerPointOnly

# Solo dashboard Excel:
.\Work2027_Complete_Converter.ps1 -ExcelOnly

# Con Pandoc (alternativo):
pandoc Work2027_Executive_Word_Template.md -o Work2027_Report.docx --toc --reference-doc=template.docx

# M365 Copilot (manual):
# Copiar prompt del script M365_Work2027_Converter.ps1 y usar en Word/PowerPoint
```

---

**🔄 Sistema de Conversión Work 2027 Completado**
**📄 Word + 🎯 PowerPoint + 📊 Excel + 🤖 M365 Copilot**
**⚡ Conversión automática | 🎨 Formato profesional | 📁 OneDrive organizado**

---

*Document Converter generado por Work 2027 Automation System*
*Versión: 2.0 - Complete Document Generation Suite*
*Compatible con: M365 Copilot + Pandoc + PowerShell Automation*