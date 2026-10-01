# Investigación - Laboratorio 06

## Cambio al incorporar un Navigation Controller

La primera pantalla queda dentro de un `UINavigationController`. Xcode agrega una barra de navegación y el controlador administra una pila de pantallas. Al ejecutar un segue Show, la segunda pantalla entra a la pila y iOS muestra automáticamente el botón para regresar.

## Función de UINavigationController

`UINavigationController` implementa navegación jerárquica. Mantiene un arreglo de controladores, muestra el controlador que está en la parte superior de la pila y permite avanzar con push o regresar con pop.

## Tipos de presentación

- **Show:** agrega la pantalla a la pila cuando existe un Navigation Controller. Se usa para avanzar de una vista general a un detalle.
- **Show Detail:** muestra o reemplaza el controlador de detalle de un `UISplitViewController`. Resulta especialmente útil en iPad.
- **Present Modally:** presenta una tarea temporal sobre la pantalla actual. El usuario debe cerrarla para regresar al flujo anterior.
- **Present As Popover:** presenta contenido contextual anclado a un control. Tiene mayor sentido en iPad; en iPhone el sistema puede adaptarlo a otro estilo.

## Show frente a Present Modally

Show conviene para un flujo continuo, por ejemplo abrir el detalle de un producto desde un catálogo. Present Modally conviene para una tarea independiente, por ejemplo confirmar los datos de un cliente antes de continuar.

