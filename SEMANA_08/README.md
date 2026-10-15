# Semana 08 — Culturas mejoradas

Versión de la mejora de Culturas, guardada en la rama `manual` por solicitud del estudiante. No reemplaza el laboratorio de semana 7 ni afirma resolver una guía nueva de semana 8.

## Ejecutar

Abre `Semana08_01_CulturasMejoradas/Semana08_01_CulturasMejoradas.xcodeproj`, selecciona el esquema Semana08_01_CulturasMejoradas y el simulador iPhone 16, y pulsa Run. No requiere dependencias ni internet. El simulador se selecciona localmente en cada Mac.

## Funcionamiento

La lista principal conserva Inca, Nazca, Chavín y Paracas. Al entrar aparece un menú de tres títulos con imagen; al tocar cualquiera, se abre su región, imagen y descripción breve.

| Pantalla principal | Opciones |
| --- | --- |
| Inca | Inca, Wari, Tiwanaku |
| Nazca | Nazca, Chincha, Lima |
| Chavín | Chavín, Cupisnique, Moche |
| Paracas | Paracas, Chimú, Chancay |

La agrupación es una sugerencia de lectura, no una división histórica de cada cultura. Tiwanaku comprende el ámbito andino; su centro fotografiado está en Bolivia.

## Storyboard y datos

- Relación rootViewController: Navigation Controller → lista.
- Show `mostrarDetalleCultura`: celda → menú.
- Show `verCulturaRelacionada`: menú → lectura, disparado por la acción del botón.
- `prepare(for:sender:)` pasa el modelo Cultura completo.
- La tabla tiene constraints a 0 respecto de la Safe Area. Scroll View y Stack View permiten recorrer el contenido; margen de 20 en las pantallas internas.
- Imágenes en Assets, textos en Cultura.swift.

Los constraints y segues están definidos en Main.storyboard y son editables en Interface Builder. La implementación tuvo asistencia y edición del XML; estar en manual no significa que se construyó sin IA.

## Correcciones incluidas

Se eliminó la celda anidada duplicada (dos flechas), se ajustó el layout y la prioridad de la imagen al ocultarse, y se protegió la acción de navegación de la pantalla de lectura. Se mantuvieron los cambios visuales del estudiante.

## Verificación y evidencias

Compilación para iPhone 16 y prueba de selección y regreso. El mismo flujo de las 12 lecturas fue probado durante la mejora en semana 7.

- [Lista principal](evidencias/01_lista_iphone16.png).
- [Tres títulos con imágenes](evidencias/02_menu_nazca_iphone16.png).
- [Descripción seleccionada](evidencias/03_lectura_chincha_iphone16.png).

Las fotografías y sus licencias se documentan en [FUENTES.md](FUENTES.md).

## Dos commits de esta entrega

1. Proyecto mejorado, datos, imágenes, conexiones y correcciones.
2. Documentación, fuentes y capturas de la ejecución de semana 8.
