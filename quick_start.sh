#!/bin/bash

# 🚀 Inicio rápido del centro de estudio

echo "🎓 CENTRO DE ESTUDIO - INICIO RÁPIDO"
echo "=================================="

# Activar entorno virtual
if [ -d "venv" ]; then
    source venv/bin/activate
    echo "✅ Entorno virtual activado"
else
    echo "⚠️  Entorno virtual no encontrado. Ejecuta: ./setup_environment.sh"
fi

# Mostrar menú
echo ""
echo "📚 Opciones disponibles:"
echo "1. 🎯 Ejercicio diario: python daily_practice.py"
echo "2. 📊 Ver progreso: python check_progress.py"
echo "3. 🛠️  Utilidades: python utils.py"
echo "4. 💻 Abrir VS Code: code ."
echo ""

read -p "🔢 Selecciona una opción (1-4) o Enter para solo activar entorno: " opcion

case $opcion in
    1)
        python daily_practice.py
        ;;
    2)
        python check_progress.py
        ;;
    3)
        python utils.py
        ;;
    4)
        code .
        ;;
    *)
        echo "📝 Entorno listo. ¡Feliz programación!"
        ;;
esac
