# Documentación de asistencia de IA

La guía del integrador indica “sin IA”. El estudiante solicitó expresamente desarrollar este caso con el asistente. Por transparencia, esta entrega documenta la asistencia y no declara haber sido elaborada sin IA.

## Solicitud recibida

Continuar en Semana 6 según la guía, crear la rama integrador, implementar el caso, guardar seis commits progresivos, subir al repositorio y abrir en Xcode con capturas y README.

## Prompt de trabajo reconstruido

El siguiente texto es un prompt simulado para fines de documentación, no una transcripción literal:

“Actúa como asistente de programación UIKit. Implementa el caso Tienda de Electrodomésticos de Laboratorio 06 dentro de SEMANA_06, rama integrador. Usa cinco pantallas en Storyboard: Catálogo, Detalle, Carrito, Datos del cliente y Boleta. Conecta los segues verDetalle, verCarrito, irDatosCliente y verBoleta. Los botones comparten verDetalle usando sender y tags. Crea un solo CarritoModel en Catálogo y pasa esa referencia mediante prepare. Completa los modelos con clases, descuento por tramos, IGV sobre monto descontado y categoría con switch. Reutiliza ClienteModel. Valida stock acumulado, campos obligatorios y DNI de ocho dígitos. Al confirmar, baja stock y vacía el carrito, conservando los textos de la boleta. Agrega Microondas y comenta cuántos archivos debieron cambiar. Verifica los cinco escenarios, toma evidencias en iPhone 16 y conserva seis commits progresivos. No presentes el trabajo como realizado sin IA.”

## Revisión realizada

Se revisaron los cálculos y los cinco escenarios mediante pruebas ejecutables, las conexiones del Storyboard mediante compilación y el recorrido visual de catálogo, detalle, carrito, datos y boleta. También se revisaron los mensajes de validación, la agrupación de líneas y la actualización de stock después de comprar.

La interfaz se definió en XML de Storyboard con asistencia; no se generó una jerarquía de vistas mediante Swift. El estudiante puede editarla visualmente en Xcode. Esto no equivale a afirmar que fue dibujada a mano sin IA.
