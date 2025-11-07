#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
🛠️ Utilidades para el Centro de Estudio
Funciones helper y herramientas útiles
"""

import os
import shutil
from datetime import datetime

def crear_ejercicio(nombre, nivel="basico", descripcion=""):
    """Crea un nuevo ejercicio con template."""
    if not nombre:
        nombre = input("📝 Nombre del ejercicio: ").strip()

    if not descripcion:
        descripcion = input("📖 Descripción (opcional): ").strip()

    # Sanitizar nombre
    nombre_archivo = nombre.lower().replace(" ", "_").replace("-", "_")
    fecha = datetime.now().strftime("%Y%m%d")

    # Determinar directorio
    directorio = f"python/ejercicios/{nivel}s"
    os.makedirs(directorio, exist_ok=True)

    archivo = f"{directorio}/{fecha}_{nombre_archivo}.py"

    template = f'''#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
🎯 Ejercicio: {nombre}
Nivel: {nivel.capitalize()}
Fecha: {datetime.now().strftime("%Y-%m-%d")}

Descripción:
{descripcion if descripcion else "Descripción del ejercicio"}
"""

def main():
    """Función principal del ejercicio."""
    print("🚀 {nombre}")

    # Tu código aquí
    pass

    print("✅ Completado!")

def test_{nombre_archivo}():
    """Tests para el ejercicio."""
    # Casos de prueba
    print("🧪 Ejecutando tests...")
    # assert condicion, "Mensaje"
    print("✅ Tests OK!")

if __name__ == "__main__":
    main()
    test_{nombre_archivo}()
'''

    with open(archivo, 'w', encoding='utf-8') as f:
        f.write(template)

    print(f"✅ Ejercicio creado: {archivo}")
    return archivo

def limpiar_cache():
    """Limpia archivos cache de Python."""
    print("🧹 Limpiando cache...")

    # Buscar y eliminar __pycache__
    for root, dirs, files in os.walk("."):
        if "__pycache__" in dirs:
            cache_dir = os.path.join(root, "__pycache__")
            shutil.rmtree(cache_dir)
            print(f"🗑️  Eliminado: {cache_dir}")

    # Eliminar archivos .pyc
    for root, dirs, files in os.walk("."):
        for file in files:
            if file.endswith(".pyc"):
                pyc_file = os.path.join(root, file)
                os.remove(pyc_file)
                print(f"🗑️  Eliminado: {pyc_file}")

    print("✅ Cache limpiado!")

def crear_proyecto(nombre):
    """Crea estructura para un nuevo proyecto."""
    if not nombre:
        nombre = input("📝 Nombre del proyecto: ").strip()

    nombre_dir = nombre.lower().replace(" ", "_")
    proyecto_dir = f"python/proyectos/{nombre_dir}"

    # Crear estructura
    dirs = [
        "",
        "src",
        "tests",
        "docs",
        "data"
    ]

    for dir_name in dirs:
        dir_path = os.path.join(proyecto_dir, dir_name)
        os.makedirs(dir_path, exist_ok=True)

    # Crear archivos base
    archivos = {
        "README.md": f"# {nombre}\\n\\nDescripción del proyecto.",
        "requirements.txt": "# Dependencias del proyecto\\n",
        "src/__init__.py": "",
        "src/main.py": f'#!/usr/bin/env python3\\n"""\\n{nombre} - Archivo principal\\n"""\\n\\ndef main():\\n    print("🚀 {nombre}")\\n\\nif __name__ == "__main__":\\n    main()\\n',
        "tests/__init__.py": "",
        "tests/test_main.py": f'"""\\nTests para {nombre}\\n"""\\nimport unittest\\n\\nclass Test{nombre.replace(" ", "")}(unittest.TestCase):\\n    def test_ejemplo(self):\\n        self.assertTrue(True)\\n\\nif __name__ == "__main__":\\n    unittest.main()\\n'
    }

    for archivo, contenido in archivos.items():
        ruta_archivo = os.path.join(proyecto_dir, archivo)
        with open(ruta_archivo, 'w', encoding='utf-8') as f:
            f.write(contenido)

    print(f"✅ Proyecto creado: {proyecto_dir}")
    return proyecto_dir

def menu_utilidades():
    """Menú principal de utilidades."""
    print("🛠️  UTILIDADES DEL CENTRO DE ESTUDIO")
    print("=" * 40)
    print("1. Crear nuevo ejercicio")
    print("2. Crear nuevo proyecto")
    print("3. Limpiar cache Python")
    print("4. Ver progreso")
    print("0. Salir")

    while True:
        try:
            opcion = input("\\n🔢 Opción: ").strip()

            if opcion == "0":
                break
            elif opcion == "1":
                crear_ejercicio("")
            elif opcion == "2":
                crear_proyecto("")
            elif opcion == "3":
                limpiar_cache()
            elif opcion == "4":
                os.system("python check_progress.py")
            else:
                print("❌ Opción no válida")

        except KeyboardInterrupt:
            print("\\n👋 ¡Hasta luego!")
            break

if __name__ == "__main__":
    menu_utilidades()
