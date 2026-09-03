# Laboratorio 03 - Ejercicios con IA

**Curso:** Programación en Móviles Avanzado  
**Semana:** 3  
**Rama:** `ai-assisted`  
**Herramienta de IA:** ChatGPT  
**Desarrollado por:** LuisDB

Esta rama contiene los ejercicios 6 y 7 solicitados para el trabajo asistido por
IA. Ambos programas utilizan únicamente contenidos estudiados hasta la semana 3
y tienen un comentario específico en cada línea de código.

## Contenido

| Ejercicio | Playground | Código fuente |
| --- | --- | --- |
| 6 - Gestión de notas | [Abrir Playground](./Ejercicio_6_Gestion_Notas_IA.playground) | [Contents.swift](./Ejercicio_6_Gestion_Notas_IA.playground/Contents.swift) |
| 7 - Inventario con menú | [Abrir Playground](./Ejercicio_7_Inventario_Menu_IA.playground) | [Contents.swift](./Ejercicio_7_Inventario_Menu_IA.playground/Contents.swift) |

La secuencia de consultas a la IA está documentada con estructura CTRFE en
[PROMPTS.md](./PROMPTS.md).

## Requisitos cumplidos

### Ejercicio 6 - Gestión de notas

- Solicita N alumnos mediante `readLine()`.
- Registra nombre y tres notas en un diccionario `[String: [Double]]`.
- Calcula el promedio por alumno.
- Clasifica con `switch`: Excelente, Bueno, Aprobado o Desaprobado.
- Calcula promedio general, nota más alta, nota más baja y porcentaje de aprobados.
- Ordena a los alumnos desde el promedio más alto al más bajo.
- Evita división entre cero cuando no se registran alumnos.
- Mantiene un comentario específico en cada línea de código.

### Ejercicio 7 - Inventario con menú

- Solicita N productos con nombre, precio y stock.
- Guarda precios y stocks en diccionarios relacionados.
- Mantiene activo un menú con `while` hasta elegir salir.
- Permite ver el inventario y buscar un producto.
- Muestra los productos con stock menor que cinco.
- Calcula el valor total mediante `precio * stock`.
- Informa cuando una opción no es válida.
- Presenta reportes ordenados y valores monetarios con dos decimales.
- Mantiene un comentario específico en cada línea de código.

## Cómo ejecutar

Abrir Terminal y entrar en la carpeta de Semana 3:

```bash
cd /Users/luisdb/Documents/MOVILES_AVANZADOS_DIONICIO/SEMANA_03
```

Ejecutar el ejercicio 6:

```bash
swift Ejercicio_6_Gestion_Notas_IA.playground/Contents.swift
```

Ejecutar el ejercicio 7:

```bash
swift Ejercicio_7_Inventario_Menu_IA.playground/Contents.swift
```

También se puede abrir cada `.playground` en Xcode. La consola de Xcode se muestra
u oculta con `Shift + Command + Y`. Para usar `readLine()`, se recomienda Terminal.

## Prueba del ejercicio 6

Ingresar los datos en este orden, presionando Enter después de cada uno:

```text
3
Ana
18
19
17
Beto
15
14
16
Carla
10
12
11
```

Resultados principales esperados:

```text
Ana: promedio 18.00 - Excelente
Beto: promedio 15.00 - Bueno
Carla: promedio 11.00 - Desaprobado
Promedio general: 14.67
Nota más alta: 19.00
Nota más baja: 10.00
Aprobados: 2 de 3
Porcentaje de aprobados: 66.67%
```

## Prueba del ejercicio 7

Registrar tres productos:

```text
3
Laptop
3500
2
Mouse
50
10
Teclado
120
4
```

Después ingresar esta secuencia de opciones del menú:

```text
1
2
Mouse
3
4
9
5
```

Resultados principales esperados:

```text
Producto encontrado: Mouse
Laptop: 2 unidades
Teclado: 4 unidades
Valor total del inventario: S/. 7980.00
Opción inválida. Intente nuevamente.
Saliendo del sistema de inventario...
```

## Evidencias de ejecución

Las capturas deben mostrar el comando, los datos ingresados, los resultados y el
retorno al prompt de Terminal sin errores. Guardarlas en `SEMANA_03/evidencias/`:

- `ejercicio-6-gestion-notas-terminal.png`
- `ejercicio-7-inventario-menu-terminal-1.png`
- `ejercicio-7-inventario-menu-terminal-2.png` si la salida requiere dos capturas.

Estado:

- [ ] Ejercicio 6 - evidencia pendiente
- [ ] Ejercicio 7 - evidencia pendiente

### Evidencia 6 - Gestión de notas

Pendiente de la captura enviada por el estudiante.

### Evidencia 7 - Inventario con menú

Pendiente de la captura o capturas enviadas por el estudiante.
