# Laboratorio 07 Manejo de Tablas y Colecciones

Rama: `manual`. Proyecto: `Semana07_01_Profesores`.

Desarrollo de la sección A de la guía GLAB-S07-JLEONS-2026-2 hasta el paso 13 inclusive.

## Procedimientos realizados

1. Proyecto UIKit con Storyboard en una subcarpeta de SEMANA_07.
2. UITableView en la vista principal.
3. Constraints superior, inferior, izquierdo y derecho a la Safe Area, todos con constante 0.
4. Una celda prototipo con identificador `celda` y estilo `Subtitle`.
5. `dataSource` y `delegate` enlazados al `ViewController` desde el Storyboard.
6. Outlet `tableView` enlazado al controlador.
7. Protocolos `UITableViewDelegate` y `UITableViewDataSource`, con los dos métodos requeridos.
8. Clase `Profesor: NSObject`, con nombre, cargo e inicializador, según el paso 10.
9. Lista de los siete profesores del ejemplo de la guía (paso 11).
10. Número de filas calculado mediante `listaProfesores.count` (paso 12).
11. Reutilización de `celda`, con nombre en `textLabel` y cargo en `detailTextLabel` (paso 13).

## Abrir y continuar

Abre `Semana07_01_Profesores/Semana07_01_Profesores.xcodeproj`.
Selecciona el esquema `Semana07_01_Profesores` y el destino iPhone 16.
Usa Cmd + R para ejecutar y abre Main.storyboard para editar visualmente la tabla.

La tabla muestra siete filas con el nombre y cargo de cada profesor, según el ejemplo de la guía.
El modelo todavía no incluye foto, porque ese campo se añade en el paso 16.

Este avance tiene una sola pantalla, por lo que no requiere segues. El caso de culturas peruanas con navegación a un detalle se realizará posteriormente en la rama `ai-assisted`.

No se incluyen datos locales de Xcode, compilaciones ni copias de la guía en el repositorio.
