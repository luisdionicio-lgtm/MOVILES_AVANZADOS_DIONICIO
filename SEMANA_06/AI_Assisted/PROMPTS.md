# PROMPTS - Semana 06

## Contexto

Estoy desarrollando una app iOS con UIKit y Storyboard para practicar navegacion entre `UIViewController`. La app calcula una venta a plazos de un electrodomestico y debe pasar los resultados a una segunda pantalla.

## Tarea

1. Define `class VentaModel: NSObject` con seis propiedades `Double`: subtotal, IGV, monto base, intereses totales, total y cuota mensual.
2. En `NuevaVentaViewController`, lee electrodomestico, precio, cantidad, meses y tasa mensual; calcula los seis resultados.
3. Pasa el modelo por el segue `showResultado` usando `prepare(for:sender:)`.
4. En `ResultadoViewController`, muestra los seis resultados con `String(format: "S/. %.2f", valor)`.

Formulas utilizadas:

- `subtotal = precio * cantidad`
- `igv = subtotal * 0.18`
- `base = subtotal + igv`
- `intereses = base * (tasa / 100) * meses`
- `total = base + intereses`
- `cuota = total / meses`

## Restricciones

- Usa solamente conceptos vistos hasta la semana 6: clases, `UINavigationController`, `IBOutlet`, `IBAction`, segue Show y `prepare(for:sender:)`.
- No uses SwiftUI, Combine, Codable, persistencia ni librerias externas.
- La interfaz debe estar creada en `Main.storyboard`.
- Explica por que `VentaModel` es `class` y no `struct`.

## Formato

Entrega el contenido de cada archivo Swift por separado y enumera las conexiones necesarias en Interface Builder. Incluye una validacion sencilla para campos vacios, numeros invalidos y meses iguales a cero.

## Ejemplo

Entrada: precio `1000`, cantidad `1`, meses `10`, tasa `2`.

Salida esperada: subtotal `S/. 1000.00`, IGV `S/. 180.00`, base `S/. 1180.00`, intereses `S/. 236.00`, total `S/. 1416.00` y cuota `S/. 141.60`.

## Reflexion sobre la asistencia de IA

La IA propuso `guard let` para validar de una vez las conversiones y evitar dividir entre cero. Esto no cambia el patron solicitado: el calculo sigue en la primera pantalla, el modelo se entrega en `prepare(for:sender:)` y la segunda pantalla solo presenta resultados. Tambien separo el formato en una funcion `soles(_:)` para no repetir seis veces la misma expresion.

Se usa una `class` porque la guia trabaja con modelos de referencia derivados de `NSObject`: ambas pantallas pueden referirse a la misma instancia. Con un `struct` el paso hacia adelante no se rompería, pero se enviaria una copia por valor; los cambios posteriores en una pantalla no aparecerian automaticamente en la otra.

