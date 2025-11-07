#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
📊 Monitor de Progreso - Centro de Estudio
Analiza el progreso en ejercicios y proyectos
"""

import os
import glob
from datetime import datetime, timedelta
from collections import defaultdict

def analizar_progreso():
    """Analiza el progreso del estudio."""
    print("📊 REPORTE DE PROGRESO")
    print("=" * 50)

    # Contar archivos Python por categoría
    categorias = {
        "Fundamentos": "python/fundamentos/**/*.py",
        "Ejercicios": "python/ejercicios/**/*.py",
        "Proyectos": "python/proyectos/**/*.py",
        "Notebooks": "python/notebooks/**/*.ipynb",
        "Práctica Diaria": "practica/daily_coding/**/*.py"
    }

    total_archivos = 0

    for categoria, patron in categorias.items():
        archivos = glob.glob(patron, recursive=True)
        count = len(archivos)
        total_archivos += count

        print(f"📂 {categoria}: {count} archivo(s)")

        if archivos:
            # Mostrar archivos más recientes
            archivos_recientes = sorted(archivos,
                                      key=lambda x: os.path.getmtime(x),
                                      reverse=True)[:3]
            for archivo in archivos_recientes:
                nombre = os.path.basename(archivo)
                fecha = datetime.fromtimestamp(os.path.getmtime(archivo))
                print(f"   └── {nombre} ({fecha.strftime('%Y-%m-%d')})")

    print(f"\n📈 TOTAL: {total_archivos} archivos")

    # Analizar actividad reciente (últimos 7 días)
    print("\n📅 ACTIVIDAD RECIENTE (7 días)")
    print("-" * 30)

    una_semana_atras = datetime.now() - timedelta(days=7)
    archivos_recientes = []

    for categoria, patron in categorias.items():
        archivos = glob.glob(patron, recursive=True)
        for archivo in archivos:
            fecha_mod = datetime.fromtimestamp(os.path.getmtime(archivo))
            if fecha_mod > una_semana_atras:
                archivos_recientes.append((archivo, fecha_mod, categoria))

    if archivos_recientes:
        archivos_recientes.sort(key=lambda x: x[1], reverse=True)
        for archivo, fecha, categoria in archivos_recientes[:10]:
            nombre = os.path.basename(archivo)
            print(f"✅ {nombre} - {categoria} ({fecha.strftime('%Y-%m-%d %H:%M')})")
    else:
        print("📭 No hay actividad reciente. ¡Es hora de programar!")

    # Sugerencias
    print("\n💡 SUGERENCIAS")
    print("-" * 20)

    if total_archivos < 5:
        print("🚀 ¡Estás empezando! Intenta hacer un ejercicio diario.")
    elif total_archivos < 20:
        print("📈 Buen progreso. Considera trabajar en un proyecto más grande.")
    else:
        print("🎯 ¡Excelente trabajo! Mantén la constancia.")

    # Recordatorios
    if not archivos_recientes:
        print("⏰ Recuerda: La práctica diaria es clave para el aprendizaje.")

    print(f"\n📊 Reporte generado: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

if __name__ == "__main__":
    analizar_progreso()
