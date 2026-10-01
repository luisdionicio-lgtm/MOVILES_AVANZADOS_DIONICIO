# Semana 06 - ViewControllers, navegacion y modales

Esta carpeta contiene los ejemplos manuales de la guia:

- `Semana06_01_Navegacion`: navegacion tipo **Show** dentro de un `UINavigationController`.
- `Semana06_02`: presentacion modal y paso de un `ClienteModel` a una segunda pantalla.

Cada ejemplo usa UIKit y Storyboard. Abre el archivo `.xcodeproj` correspondiente y ejecuta el esquema con el mismo nombre en un simulador de iPhone.

## Estructura necesaria de cada proyecto

- La carpeta exterior (`Semana06_01_Navegacion` o `Semana06_02`) organiza el proyecto.
- El paquete `.xcodeproj` contiene la configuracion que Xcode necesita para abrir y compilar.
- La carpeta interior con el mismo nombre contiene Swift, Storyboards y recursos de la app.

Estas carpetas no son duplicados. Las tres forman la estructura estandar de un proyecto Xcode y deben mantenerse al clonar el repositorio. Los datos locales de Xcode, como `xcuserdata` y `DerivedData`, no estan versionados.
