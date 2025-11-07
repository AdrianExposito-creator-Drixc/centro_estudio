#!/bin/bash

echo "🐍 Configurando entorno virtual de Python..."

# Crear entorno virtual
python3 -m venv venv

# Activar entorno virtual
source venv/bin/activate

# Actualizar pip
pip install --upgrade pip

# Instalar dependencias
pip install -r python/config/requirements.txt

echo "✅ Entorno configurado!"
echo "🔄 Para activar: source venv/bin/activate"
