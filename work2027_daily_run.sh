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
