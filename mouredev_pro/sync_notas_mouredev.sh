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
