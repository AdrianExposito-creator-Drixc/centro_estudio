# 🧩 SESIÓN 02 – VARIABLES (MoureDev Pro + WORK 2027)
# Autor: Adrián Expósito Carrasquilla
# Fecha: 06/11/2025
# Objetivo: dominar la manipulación de variables, tipos de datos y conversiones básicas en Python.

print("=" * 60)
print("🐍 SESIÓN 02 - VARIABLES Y FUNCIONES")
print("=" * 60)

# 1️⃣ Declarar y asignar valores
print("\n1️⃣ Declaración y asignación de variables:")
name = "Adrián Expósito"
age = 43
height = 1.78

print(f"Nombre: {name}")
print(f"Edad: {age}")
print(f"Altura: {height}m")

# 2️⃣ Convertir entero a cadena y concatenar
print("\n2️⃣ Conversión de tipos y concatenación:")
age_str = str(age)
print("Concatenación tradicional: " + "Tengo " + age_str + " años")
print(f"F-string moderno: Tengo {age} años")

# 3️⃣ Variable booleana
print("\n3️⃣ Variables booleanas:")
is_student = True
print(f"¿Soy estudiante?: {is_student}")
print(f"Tipo de dato: {type(is_student)}")

# 4️⃣ Calcular cuántos caracteres tiene el nombre
print("\n4️⃣ Función len() - longitud de cadenas:")
name_length = len(name)
print(f"Mi nombre completo '{name}' tiene {name_length} caracteres")

# 5️⃣ Múltiples asignaciones en una sola línea
print("\n5️⃣ Asignación múltiple:")
first_name, last_name, city = "Adrián", "Expósito", "Henniez"
print(f"Nombre: {first_name}")
print(f"Apellido: {last_name}")
print(f"Ciudad: {city}")
print(f"Presentación completa: Me llamo {first_name} {last_name} y vivo en {city}")

# 6️⃣ Simulación de input (para ejecución automática)
print("\n6️⃣ Simulación de input (modo automático):")
# En lugar de: color = input("¿Cuál es tu color favorito? ")
color = "Azul"  # Simulamos que el usuario eligió "Azul"
print(f"Input simulado: {color}")
print(f"Tu color favorito es: {color}")
print(f"Tipo de dato devuelto por input(): {type(color)}")

# 7️⃣ Cambiar valor de una variable
print("\n7️⃣ Reasignación de variables:")
fruit = "Platano"
print(f"Fruta inicial: {fruit}")
fruit = "Fresa"
print(f"Fruta actualizada: {fruit}")
print("💡 Python permite cambiar el tipo de dato de una variable dinámicamente")

# 8️⃣ Convertir decimal a entero
print("\n8️⃣ Conversión de float a int:")
price = 9.99
price_int = int(price)
print(f"Precio original (float): {price}")
print(f"Precio convertido (int): {price_int}")
print(f"⚠️ Nota: int() trunca, no redondea. 9.99 -> {price_int}")

# 9️⃣ Longitud de una dirección
print("\n9️⃣ Longitud de cadenas complejas:")
address = "Impasse du chanot 8, 1525 Henniez, Vaud, Suiza"
address_len = len(address)
print(f"Dirección: {address}")
print(f"Número de caracteres: {address_len}")
print(f"Incluye espacios y caracteres especiales")

# 🔟 Tipo de dato forzado (type hinting)
print("\n🔟 Type hints y verificación de tipos:")
phone: int = +41779147973
print(f"Teléfono con type hint: {phone}")
print(f"Tipo de dato: {type(phone)}")
phone = 779147973  # Cambiar formato
print(f"Teléfono sin prefijo: {phone}")
print(f"Tipo actual: {type(phone)}")
print("💡 Type hints son sugerencias, Python no las obliga")

# 🎯 Resumen final
print("\n" + "=" * 60)
print("🎯 RESUMEN DE CONCEPTOS APRENDIDOS")
print("=" * 60)
print("✅ Declaración y asignación de variables")
print("✅ Tipos de datos básicos: str, int, float, bool")
print("✅ Conversiones de tipo: str(), int(), float()")
print("✅ Función len() para obtener longitud")
print("✅ Asignación múltiple en una línea")
print("✅ Función type() para verificar tipos")
print("✅ Type hints como documentación")
print("✅ F-strings para formateo moderno")
print("=" * 60)
