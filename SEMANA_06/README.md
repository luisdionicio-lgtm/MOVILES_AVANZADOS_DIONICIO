# Semana 06 - Ejercicio asistido por IA

`Semana06_04_VentaPlazos` implementa la calculadora solicitada en la guia con UIKit y Storyboard.

1. Abre `Semana06_04_VentaPlazos.xcodeproj`.
2. Selecciona el esquema `Semana06_04_VentaPlazos` y un simulador de iPhone.
3. Ejecuta con `Cmd + R`, completa los cinco campos y pulsa **Calcular**.

La navegacion usa un segue **Show** con identifier `showResultado`. Los datos calculados viajan en una instancia de `VentaModel` mediante `prepare(for:sender:)`.

## Estructura necesaria del proyecto

- `Semana06_04_VentaPlazos.xcodeproj` contiene la configuracion para abrir y compilar la app.
- La carpeta interior `Semana06_04_VentaPlazos` contiene Swift, Storyboards y recursos.

Ambos elementos son obligatorios y no son duplicados. Los datos locales de Xcode, como `xcuserdata` y `DerivedData`, no estan versionados.
