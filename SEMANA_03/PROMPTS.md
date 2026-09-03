# Prompts - Laboratorio 03

**Docente:** Juan Leon - Tecsup  
**Herramienta:** ChatGPT  
**Rama:** `ai-assisted`

Los siguientes prompts muestran la secuencia utilizada para construir, revisar y
probar los ejercicios 6 y 7. Cada paso conserva la estructura CTRFE solicitada.

## Ejercicio 6 - Gestión de notas

### Prompt 1 - Registro de alumnos y notas

**CONTEXTO:** Soy estudiante de iOS en la semana 3 del curso Programación en
Móviles Avanzado. Estoy trabajando con arrays, diccionarios, condicionales,
bucles y `readLine()` en un Swift Playground.

**TAREA:** Crea la primera parte de un programa que pregunte cuántos alumnos se
registrarán. Por cada alumno debe solicitar su nombre y exactamente tres notas,
y almacenarlas en un diccionario de tipo `[String: [Double]]`.

**RESTRICCIONES:** Usa solamente contenidos de las semanas 1 a 3. No uses
`struct`, `class`, funciones personalizadas, programación asíncrona ni librerías
externas. Convierte las entradas con valores predeterminados seguros. Evita el
rango `1...0` cuando la cantidad no sea positiva.

**FORMATO:** Devuelve código Swift ejecutable en Playground. Agrega el encabezado
`// Desarrollado por: LuisDB` y un comentario específico en cada línea de código.

**EJEMPLO:** Para un alumno llamado Ana y notas 18, 19 y 17, el diccionario debe
guardar `"Ana": [18.0, 19.0, 17.0]`.

### Prompt 2 - Promedio y clasificación

**CONTEXTO:** Ya tengo un diccionario `[String: [Double]]` con tres notas por
alumno en un Swift Playground de semana 3.

**TAREA:** Recorre el diccionario, calcula el promedio de cada alumno y guárdalo
en otro diccionario `[String: Double]`. Clasifica cada promedio mediante `switch`:
Excelente de 18 a 20, Bueno de 15 a menos de 18, Aprobado de 13 a menos de 15 y
Desaprobado para valores menores que 13.

**RESTRICCIONES:** Conserva el código anterior. No uses `struct`, `class` ni
funciones personalizadas. La clasificación debe realizarse obligatoriamente con
`switch` y rangos. Usa únicamente sintaxis estudiada hasta la semana 3.

**FORMATO:** Entrega el bloque Swift que se debe añadir. Comenta de manera
específica cada línea y muestra promedio con dos decimales.

**EJEMPLO:** Un promedio de `18.0` debe imprimir `Ana: promedio 18.00 - Excelente`.

### Prompt 3 - Estadísticas y ordenamiento

**CONTEXTO:** El programa ya registra alumnos, calcula promedios y asigna una
clasificación a cada uno.

**TAREA:** Agrega el promedio general, la nota más alta, la nota más baja, la
cantidad y el porcentaje de aprobados. Ordena el reporte de alumnos desde el
promedio más alto al más bajo.

**RESTRICCIONES:** No uses tipos personalizados. Evita divisiones entre cero y
accesos forzados a opcionales. Considera aprobado un promedio mayor o igual a 13.
Mantén un comentario específico en cada línea de código.

**FORMATO:** Devuelve el código integrado y ejecutable, con secciones visibles
`REPORTE DE NOTAS` y `ESTADÍSTICAS`, y números formateados con dos decimales.

**EJEMPLO:** Con promedios 18, 15 y 11, el promedio general debe ser `14.67` y el
porcentaje de aprobados debe ser `66.67%`.

### Prompt 4 - Revisión final del ejercicio 6

**CONTEXTO:** Tengo la versión completa del ejercicio 6 creada a partir de los
tres pasos anteriores.

**TAREA:** Revisa que el programa cumpla todos los requisitos: N alumnos, nombre,
tres notas, diccionario `[String: [Double]]`, promedio individual, clasificación
con `switch`, estadísticas completas y orden descendente. Corrige errores de
compilación o casos de cantidad cero.

**RESTRICCIONES:** No cambies el alcance educativo ni agregues conceptos
posteriores a la semana 3. No elimines comentarios; cada línea debe conservar un
comentario específico. No uses código de relleno.

**FORMATO:** Devuelve un único `Contents.swift` final y una lista breve de datos
de prueba con sus resultados clave esperados.

**EJEMPLO:** Prueba Ana `18,19,17`, Beto `15,14,16` y Carla `10,12,11`; deben
resultar promedios `18.00`, `15.00` y `11.00`.

## Ejercicio 7 - Inventario con menú

### Prompt 1 - Registro del inventario

**CONTEXTO:** Soy estudiante de iOS en la semana 3 y debo crear un inventario
interactivo en Swift Playground usando colecciones y `readLine()`.

**TAREA:** Pregunta cuántos productos se registrarán. Para cada uno solicita
nombre, precio y stock, y guarda la información en dos diccionarios relacionados:
`[String: Double]` para precios y `[String: Int]` para stocks.

**RESTRICCIONES:** Usa únicamente arrays o diccionarios, condicionales, bucles y
conversiones básicas de semanas 1 a 3. No uses `struct`, `class`, funciones
personalizadas ni librerías externas. Evita rangos inválidos.

**FORMATO:** Devuelve código Swift para Playground con el encabezado
`// Desarrollado por: LuisDB` y un comentario específico en cada línea.

**EJEMPLO:** `Laptop`, precio `3500` y stock `2` debe quedar relacionado mediante
la misma clave en ambos diccionarios.

### Prompt 2 - Menú repetitivo

**CONTEXTO:** Ya tengo los diccionarios de precios y stocks cargados con los datos
del usuario.

**TAREA:** Agrega un menú con `while` que se repita hasta elegir la opción 5:
1) Ver inventario, 2) Buscar producto, 3) Mostrar stock bajo, 4) Calcular valor
total y 5) Salir. Incluye un mensaje para opciones inválidas.

**RESTRICCIONES:** El ciclo debe implementarse con `while` y las opciones con
`switch`. No uses funciones personalizadas, `struct` ni `class`. Conserva el
registro previo y comenta cada línea de manera específica.

**FORMATO:** Entrega el código que continúa el programa, con un menú legible y
mensajes claros para cada selección.

**EJEMPLO:** La secuencia `1, 4, 5` debe mostrar el inventario, calcular su valor
y terminar mostrando un mensaje de salida.

### Prompt 3 - Reportes y filtros

**CONTEXTO:** El inventario ya tiene un menú `while` con cinco opciones.

**TAREA:** Completa las acciones: listar productos ordenados por nombre con precio
y stock; buscar por nombre; mostrar los productos con stock menor que 5; y sumar
`precio * stock` para calcular el valor total del inventario.

**RESTRICCIONES:** Accede a los diccionarios de forma segura con `if let`. No uses
`!`, tipos personalizados ni funciones propias. Si no hay stock bajo o el
inventario está vacío, muestra un mensaje. Comenta cada línea.

**FORMATO:** Devuelve los casos completos del `switch`, con encabezados de reporte
y precios formateados con dos decimales.

**EJEMPLO:** Laptop `3500 x 2`, Mouse `50 x 10` y Teclado `120 x 4` deben producir
un valor total de `S/. 7980.00`; Laptop y Teclado deben aparecer como stock bajo.

### Prompt 4 - Revisión final del ejercicio 7

**CONTEXTO:** Tengo el ejercicio 7 completo con registro, diccionarios y menú.

**TAREA:** Comprueba que las cinco opciones funcionen en una sola ejecución,
incluido un producto encontrado, los productos con stock bajo, el valor total,
una opción inválida y la salida normal. Corrige cualquier error encontrado.

**RESTRICCIONES:** Mantén el nivel de semana 3, el menú `while`, el `switch`, la
entrada con `readLine()` y un comentario específico en cada línea. No introduzcas
`struct`, `class`, funciones personalizadas ni dependencias externas.

**FORMATO:** Devuelve un único `Contents.swift` final y una secuencia reproducible
de entradas para verificar todas las rutas del menú.

**EJEMPLO:** Después de registrar Laptop, Mouse y Teclado, usa las opciones
`1, 2, Mouse, 3, 4, 9, 5` para recorrer todas las funciones y validar errores.
