#!/bin/bash
# ==========================================
# 📚 CONTENEDOR DE ESTUDIO — MOUREDEV PRO
# Creado por Adrián Expósito Carrasquilla (WORK 2027)
# ==========================================

BASE_DIR=~/centro_estudio/mouredev_pro
mkdir -p $BASE_DIR
cd $BASE_DIR

# === 1️⃣ ESTRUCTURA DE CARPETAS POR MÓDULO ===
for modulo in "01_hola_mundo" "02_variables" "03_operadores" "04_condicionales" "05_bucles"
do
    mkdir -p $BASE_DIR/$modulo
    touch $BASE_DIR/$modulo/ejercicios_sesion_${modulo}.py
    touch $BASE_DIR/$modulo/notas_${modulo}.md
    touch $BASE_DIR/$modulo/dudas_y_refuerzo.md
done

# === 2️⃣ README PRINCIPAL ===
cat > $BASE_DIR/README_mouredev.md << 'EOF'
# 🧠 Curso MoureDev Pro — Python desde cero

Repositorio local de aprendizaje estructurado para Adrián Expósito Carrasquilla (WORK 2027).
Cada módulo incluye código ejecutable, notas teóricas, y registro de dudas personales.

## 📂 Estructura
- 01_hola_mundo/
- 02_variables/
- 03_operadores/
- 04_condicionales/
- 05_bucles/

## 🔁 Sincronización con Notion
Las notas se pueden exportar en Markdown (.md) y subir a Notion mediante `sync_notas_mouredev.sh`.

> ⚙️ Objetivo: tener todos los ejercicios accesibles desde VS Code + Notion + móvil.
EOF

# === 3️⃣ SCRIPT DE SINCRONIZACIÓN CON NOTION (placeholder) ===
cat > $BASE_DIR/sync_notas_mouredev.sh << 'EOF'
#!/bin/bash
# Sincroniza las notas del curso MoureDev Pro con Notion (exportación en Markdown)
# Paso 1: ubicar todos los archivos .md modificados
# Paso 2: copiarlos a una carpeta sincronizada (ej. OneDrive o Notion App)
# Paso 3: opcional — subir a GitHub personal o repo privado

NOTES_DIR=~/centro_estudio/mouredev_pro
DEST_DIR=~/Documentos/NotionSync/MoureDevPro

mkdir -p $DEST_DIR
find $NOTES_DIR -name "*.md" -exec cp {} $DEST_DIR \;

echo "✅ Notas exportadas a $DEST_DIR"
EOF

chmod +x $BASE_DIR/sync_notas_mouredev.sh

echo "🎯 Contenedor MoureDev Pro creado correctamente en: $BASE_DIR"
