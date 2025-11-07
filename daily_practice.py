#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
🎯 Práctica Diaria de Python
Generador automático de ejercicios basado en nivel
"""

import random
from datetime import datetime
import os

class PracticeGenerator:
    def __init__(self):
        self.ejercicios_basicos = [
            "Crear una función que calcule el factorial de un número",
            "Escribir un programa que determine si un número es primo",
            "Crear una calculadora básica con las 4 operaciones",
            "Programa que invierta una cadena de texto",
            "Función que encuentre el número mayor en una lista",
            "Crear un conversor de temperaturas (C°, F°, K)",
            "Programa que cuente las vocales en una frase",
            "Función que genere la secuencia de Fibonacci",
            "Crear un juego de adivinanza de números",
            "Programa que ordene una lista sin usar sort()"
        ]

        self.ejercicios_intermedios = [
            "Crear una clase para manejar una cuenta bancaria",
            "Implementar un sistema de gestión de estudiantes",
            "Programa que lea y procese un archivo CSV",
            "Crear un web scraper básico con requests",
            "Implementar una pila (stack) y cola (queue)",
            "Programa que conecte a una API REST",
            "Crear un generador de contraseñas seguras",
            "Implementar un algoritmo de búsqueda binaria",
            "Programa que analice logs de servidor",
            "Crear un bot básico de Telegram"
        ]

        self.ejercicios_avanzados = [
            "Implementar un algoritmo de ordenamiento",
            "Crear una API REST con FastAPI",
            "Programa de análisis de datos con pandas",
            "Implementar un patrón de diseño (Factory, Observer)",
            "Crear un sistema de cache con decoradores",
            "Programa que use threading/multiprocessing",
            "Implementar un algoritmo de machine learning básico",
            "Crear un sistema de logging avanzado",
            "Programa que use bases de datos SQLite",
            "Implementar tests unitarios completos"
        ]

    def generar_ejercicio_diario(self, nivel="basico"):
        """Genera un ejercicio aleatorio según el nivel."""
        ejercicios = {
            "basico": self.ejercicios_basicos,
            "intermedio": self.ejercicios_intermedios,
            "avanzado": self.ejercicios_avanzados
        }

        ejercicio = random.choice(ejercicios[nivel])
        fecha = datetime.now().strftime("%Y-%m-%d")

        template = f"""#!/usr/bin/env python3
# -*- coding: utf-8 -*-
\"\"\"
🎯 Ejercicio Diario: {fecha}
Nivel: {nivel.capitalize()}

PROBLEMA:
{ejercicio}

INSTRUCCIONES:
1. Lee el problema cuidadosamente
2. Planifica tu solución
3. Implementa paso a paso
4. Prueba con diferentes casos
5. Refactoriza si es necesario

CRITERIOS DE ÉXITO:
- [ ] Código funcional
- [ ] Manejo de errores
- [ ] Código limpio y comentado
- [ ] Tests básicos
\"\"\"

def main():
    \"\"\"Función principal del ejercicio.\"\"\"
    print("🚀 Ejercicio del día: {fecha}")
    print("📝 {ejercicio}")
    print()

    # Tu código aquí
    pass

    print("\\n✅ Ejercicio completado!")

def test_solucion():
    \"\"\"Tests para verificar la solución.\"\"\"
    # Agrega tus tests aquí
    print("🧪 Ejecutando tests...")
    # assert condicion, "Mensaje de error"
    print("✅ Tests completados!")

if __name__ == "__main__":
    main()
    test_solucion()
"""

        # Crear archivo del ejercicio
        filename = f"practica/daily_coding/ejercicio_{fecha}_{nivel}.py"
        os.makedirs(os.path.dirname(filename), exist_ok=True)

        with open(filename, 'w', encoding='utf-8') as f:
            f.write(template)

        print(f"✅ Ejercicio generado: {filename}")
        print(f"🎯 Problema: {ejercicio}")
        return filename

def main():
    """Menú principal."""
    print("🎯 Generador de Práctica Diaria")
    print("=" * 40)
    print("1. Ejercicio Básico")
    print("2. Ejercicio Intermedio")
    print("3. Ejercicio Avanzado")
    print("4. Ejercicio Aleatorio")
    print("0. Salir")

    generator = PracticeGenerator()

    while True:
        try:
            opcion = input("\n🔢 Selecciona una opción (0-4): ").strip()

            if opcion == "0":
                print("👋 ¡Hasta luego! Sigue practicando.")
                break
            elif opcion == "1":
                generator.generar_ejercicio_diario("basico")
            elif opcion == "2":
                generator.generar_ejercicio_diario("intermedio")
            elif opcion == "3":
                generator.generar_ejercicio_diario("avanzado")
            elif opcion == "4":
                nivel = random.choice(["basico", "intermedio", "avanzado"])
                generator.generar_ejercicio_diario(nivel)
            else:
                print("❌ Opción no válida. Intenta de nuevo.")

        except KeyboardInterrupt:
            print("\n👋 ¡Hasta luego!")
            break
        except Exception as e:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
