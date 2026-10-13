# Laboratorio 07 Manejo de Tablas y Colecciones

Rama: `manual`. Proyectos: `Semana07_01_Profesores` y `Semana07_02_Personas`.

Desarrollo completo de los procedimientos guiados de GLAB-S07-JLEONS-2026-2, hasta antes de “Caso a Desarrollar”.

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
12. Incorporación de las siete fotografías proporcionadas en Assets (pasos 14 y 15).
13. Campo `foto: UIImage?` en Profesor e imágenes asignadas a cada profesor (pasos 16 y 17).
14. Imagen en la celda Subtitle y ejecución en iPhone 16 (pasos 18 y 19).

## Personalizar un TableView

El segundo proyecto corresponde a la sección de personalización de la guía, pasos 1 a 12.

- Tabla con una celda prototipo personalizada, identificador `miCell`.
- Clase `PersonasTableViewCell`, subclase de `UITableViewCell`.
- Imagen y label conectados a los outlets `PersonaImagen` y `personaNombre` de la celda.
- `dataSource`, `delegate` y outlet de la tabla conectados al `ViewController`.
- Arreglos de nombres e imágenes para los cinco docentes del ejemplo. Se reutilizan las fotos que proporcionaste, con sus nombres originales en Assets.
- Constraints de los cuatro bordes de la tabla a la Safe Area con constante 0. Los bordes de los controles de la celda también usan 0; la imagen tiene ancho 100 para reservar su columna.
- `didSelectRowAt` muestra una alerta con el docente seleccionado y botón OK.

## Abrir y continuar

Abre `Semana07_01_Profesores/Semana07_01_Profesores.xcodeproj`.
Selecciona el esquema `Semana07_01_Profesores` y el destino iPhone 16.
Usa Cmd + R para ejecutar y abre Main.storyboard para editar visualmente la tabla.

La tabla muestra siete filas con el nombre y cargo de cada profesor, según el ejemplo de la guía.
El modelo incluye la fotografía correspondiente a cada profesor.

Para probar la personalización, abre `Semana07_02_Personas/Semana07_02_Personas.xcodeproj`, selecciona su esquema e iPhone 16, y ejecuta con Cmd + R. Toca una fila para mostrar la alerta.

Cada ejemplo guiado tiene una sola pantalla, por lo que no requiere segues. La alerta usa `UIAlertController`. El caso de culturas peruanas con navegación a un detalle se realizará posteriormente en la rama `ai-assisted`.

## Evidencias en iPhone 16

![Profesores con fotografías](evidencias/01_profesores_con_fotos.png)
![Tabla con celdas personalizadas](evidencias/02_celdas_personalizadas.png)
![Alerta del docente seleccionado](evidencias/03_alerta_docente.png)

No se incluyen datos locales de Xcode, compilaciones ni copias de la guía en el repositorio.
