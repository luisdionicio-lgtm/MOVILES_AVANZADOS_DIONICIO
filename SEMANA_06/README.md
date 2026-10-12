# Semana 06 - ViewControllers, navegacion y modales

Esta carpeta contiene los ejemplos manuales de la guia:

- `Semana06_01_Navegacion`: navegacion tipo **Show** dentro de un `UINavigationController`.
- `Semana06_02`: presentacion modal y paso de un `ClienteModel` a una segunda pantalla.

## Segues y estructura

El ejercicio 1 conecta sus pantallas mediante un segue **Show** dentro del `UINavigationController`.
El ejercicio 2 usa el segue **Present Modally** `mostrarConfirmacion`, con presentación `pageSheet`.
El botón Continuar ejecuta `performSegue`; `prepare(for:sender:)` entrega el `ClienteModel` a la pantalla de confirmación.
Los tres outlets de esa pantalla muestran apellidos, nombres y DNI, y Cerrar descarta el modal.

Los controladores, modelos, Storyboards y recursos se mantienen en sus carpetas de proyecto correspondientes.

Cada ejemplo usa UIKit y Storyboard. Abre el archivo `.xcodeproj` correspondiente y ejecuta el esquema con el mismo nombre en un simulador de iPhone.

## Estructura necesaria de cada proyecto

- La carpeta exterior (`Semana06_01_Navegacion` o `Semana06_02`) organiza el proyecto.
- El paquete `.xcodeproj` contiene la configuracion que Xcode necesita para abrir y compilar.
- La carpeta interior con el mismo nombre contiene Swift, Storyboards y recursos de la app.

Estas carpetas no son duplicados. Las tres forman la estructura estandar de un proyecto Xcode y deben mantenerse al clonar el repositorio. Los datos locales de Xcode, como `xcuserdata` y `DerivedData`, no estan versionados.
