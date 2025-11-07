# ==========================================
# SESIÓN 01 - MoureDev Pro
# Ejercicios 1 al 10: Fundamentos de Python
# Autor: Adrián Expósito Carrasquilla
# ==========================================

# 1️⃣ Imprime "¡Hola Mundo!" por consola.
print("¡Hola Mundo!")

# 2️⃣ Escribe un comentario de una sola línea explicando qué hace el código anterior.
# Este código imprime el mensaje "¡Hola Mundo!" en la salida estándar (la consola).

# 3️⃣ Imprime tu nombre y edad en la misma línea utilizando la función print().
print("Adrián Expósito Carrasquilla - 43 años")

# 4️⃣ Usa la función type() para imprimir el tipo de dato de una cadena, un entero y un decimal.
print(type("cadena de texto"))   # <class 'str'>
print(type(43))                  # <class 'int'>
print(type(3.14))                # <class 'float'>

# 5️⃣ Comentario multilínea: explica qué son los tipos de datos en Python.
"""
Los tipos de datos en Python determinan el tipo de valor que una variable puede contener.
Por ejemplo: texto (str), números enteros (int), decimales (float), booleanos (bool), etc.
Python es de tipado dinámico, lo que significa que no necesitas declarar el tipo de dato explícitamente.
"""

# 6️⃣ Concatena dos cadenas de texto.
print("Hola " + "Mundo")

# 7️⃣ Variables: guarda tu nombre y edad, e imprímelos en una sola línea.
nombre = "Adrián"
edad = 43
print(nombre, edad)

# 8️⃣ Solicita el nombre al usuario y muestra un saludo.
# (Desactivado para ejecución automática del entorno)
# nombre_usuario = input("Introduce tu nombre: ")
# print("Hola, " + nombre_usuario + "!")

# 9️⃣ Muestra el resultado de una suma y el tipo de dato resultante.
suma = 10 + 5
print("Resultado:", suma, "Tipo:", type(suma))

# 🔟 Comenta cada línea del ejercicio anterior explicando su propósito.
# Se crea una variable llamada 'suma' que almacena la suma de 10 + 5.
# Luego se imprime el resultado y el tipo de dato (<class 'int'>).
