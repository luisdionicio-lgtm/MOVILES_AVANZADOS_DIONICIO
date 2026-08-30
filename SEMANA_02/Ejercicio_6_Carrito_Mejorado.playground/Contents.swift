import Foundation // Importa Foundation para poder mostrar importes con dos decimales.

// ===== EJERCICIO 6: CARRITO MEJORADO - ASISTIDO POR IA =====

let prod1 = "Laptop" // Guarda el nombre del primer producto.
let precio1 = 3500.0 // Guarda el precio unitario de la laptop.
let cant1 = 1 // Guarda la cantidad comprada de laptops.
let prod2 = "Mouse" // Guarda el nombre del segundo producto.
let precio2 = 45.50 // Guarda el precio unitario del mouse.
let cant2 = 2 // Guarda la cantidad comprada de mouses.
let prod3 = "Teclado" // Guarda el nombre del tercer producto.
let precio3 = 120.00 // Guarda el precio unitario del teclado.
let cant3 = 1 // Guarda la cantidad comprada de teclados.
let prod4 = "Monitor" // Guarda el nombre del cuarto producto.
let precio4 = 890.00 // Guarda el precio unitario del monitor.
let cant4 = 1 // Guarda la cantidad comprada de monitores.
let prod5 = "USB Cable" // Guarda el nombre del quinto producto.
let precio5 = 15.00 // Guarda el precio unitario del cable USB.
let cant5 = 3 // Guarda tres cables USB para probar el descuento por cantidad.
let codigoCupon = "DESCUENTO20" // Guarda el cupón que se validará antes de aplicarlo.

let datosValidos = precio1 >= 0 && cant1 > 0 && precio2 >= 0 && cant2 > 0 && precio3 >= 0 && cant3 > 0 && precio4 >= 0 && cant4 > 0 && precio5 >= 0 && cant5 > 0 // Comprueba que todos los precios y cantidades sean válidos.

if datosValidos { // Ejecuta los cálculos solamente cuando todos los datos son válidos.
    let sub1 = precio1 * Double(cant1) // Calcula el subtotal inicial de las laptops.
    let sub2 = precio2 * Double(cant2) // Calcula el subtotal inicial de los mouses.
    let sub3 = precio3 * Double(cant3) // Calcula el subtotal inicial de los teclados.
    let sub4 = precio4 * Double(cant4) // Calcula el subtotal inicial de los monitores.
    let sub5 = precio5 * Double(cant5) // Calcula el subtotal inicial de los cables USB.

    var descuentoCantidad1 = 0.0 // Inicializa el descuento por cantidad de la laptop.
    var descuentoCantidad2 = 0.0 // Inicializa el descuento por cantidad del mouse.
    var descuentoCantidad3 = 0.0 // Inicializa el descuento por cantidad del teclado.
    var descuentoCantidad4 = 0.0 // Inicializa el descuento por cantidad del monitor.
    var descuentoCantidad5 = 0.0 // Inicializa el descuento por cantidad del cable USB.

    if cant1 >= 3 { // Verifica si se compraron tres o más laptops.
        descuentoCantidad1 = sub1 * 0.05 // Aplica 5% de descuento al subtotal de las laptops.
    } // Cierra la validación de cantidad de laptops.
    if cant2 >= 3 { // Verifica si se compraron tres o más mouses.
        descuentoCantidad2 = sub2 * 0.05 // Aplica 5% de descuento al subtotal de los mouses.
    } // Cierra la validación de cantidad de mouses.
    if cant3 >= 3 { // Verifica si se compraron tres o más teclados.
        descuentoCantidad3 = sub3 * 0.05 // Aplica 5% de descuento al subtotal de los teclados.
    } // Cierra la validación de cantidad de teclados.
    if cant4 >= 3 { // Verifica si se compraron tres o más monitores.
        descuentoCantidad4 = sub4 * 0.05 // Aplica 5% de descuento al subtotal de los monitores.
    } // Cierra la validación de cantidad de monitores.
    if cant5 >= 3 { // Verifica si se compraron tres o más cables USB.
        descuentoCantidad5 = sub5 * 0.05 // Aplica 5% de descuento al subtotal de los cables USB.
    } // Cierra la validación de cantidad de cables USB.

    let totalProducto1 = sub1 - descuentoCantidad1 // Resta a la laptop su descuento por cantidad.
    let totalProducto2 = sub2 - descuentoCantidad2 // Resta al mouse su descuento por cantidad.
    let totalProducto3 = sub3 - descuentoCantidad3 // Resta al teclado su descuento por cantidad.
    let totalProducto4 = sub4 - descuentoCantidad4 // Resta al monitor su descuento por cantidad.
    let totalProducto5 = sub5 - descuentoCantidad5 // Resta al cable USB su descuento por cantidad.
    let subtotal = totalProducto1 + totalProducto2 + totalProducto3 + totalProducto4 + totalProducto5 // Suma los productos después del descuento por cantidad.

    var porcentajeDescuento = 0.0 // Inicializa el porcentaje de descuento general de la compra.
    if subtotal >= 5000 { // Comprueba si la compra alcanza el nivel de 15%.
        porcentajeDescuento = 0.15 // Asigna 15% de descuento general.
    } else if subtotal >= 2000 { // Comprueba si la compra alcanza el nivel de 10%.
        porcentajeDescuento = 0.10 // Asigna 10% de descuento general.
    } else if subtotal >= 500 { // Comprueba si la compra alcanza el nivel de 5%.
        porcentajeDescuento = 0.05 // Asigna 5% de descuento general.
    } // Cierra la selección del descuento general.

    let descuentoGeneral = subtotal * porcentajeDescuento // Calcula el dinero descontado por el monto de compra.
    let subtotalConDescuento = subtotal - descuentoGeneral // Resta el descuento general al subtotal.
    let igv = subtotalConDescuento * 0.18 // Calcula el IGV del 18% después de los descuentos.
    let totalConIGV = subtotalConDescuento + igv // Suma el IGV al subtotal con descuento.

    var descuentoCupon = 0.0 // Inicializa en cero el descuento adicional del cupón.
    if codigoCupon == "DESCUENTO20" { // Comprueba que el texto del cupón sea exactamente el solicitado.
        descuentoCupon = totalConIGV * 0.20 // Calcula 20% adicional sobre el total con IGV.
    } // Cierra la validación del cupón.
    let totalConCupon = totalConIGV - descuentoCupon // Resta del total el descuento adicional del cupón.

    var costoEnvio = 25.0 // Establece S/. 25 como costo de envío inicial.
    if totalConCupon > 3000 { // Comprueba si el total supera S/. 3000.
        costoEnvio = 0.0 // Convierte el envío en gratuito cuando se supera el monto requerido.
    } // Cierra la validación del envío gratis.

    let totalFinal = totalConCupon + costoEnvio // Agrega el costo de envío al total después del cupón.
    let puntosFidelidad = Int(totalConCupon / 100) // Entrega un punto completo por cada S/. 100 de compra.

    var separador = "" // Crea una cadena vacía para formar la línea del ticket.
    for _ in 1...48 { // Repite 48 veces la construcción de la línea separadora.
        separador += "=" // Agrega un signo igual en cada repetición.
    } // Cierra el bucle que construye el separador.

    print(separador) // Imprime la primera línea del ticket.
    print("       CARRITO MEJORADO") // Imprime el título del ticket.
    print(separador) // Separa el título del detalle de productos.
    print("\(prod1) x\(cant1): S/. \(String(format: "%.2f", totalProducto1))") // Imprime el total de laptops después del descuento por cantidad.
    print("\(prod2) x\(cant2): S/. \(String(format: "%.2f", totalProducto2))") // Imprime el total de mouses después del descuento por cantidad.
    print("\(prod3) x\(cant3): S/. \(String(format: "%.2f", totalProducto3))") // Imprime el total de teclados después del descuento por cantidad.
    print("\(prod4) x\(cant4): S/. \(String(format: "%.2f", totalProducto4))") // Imprime el total de monitores después del descuento por cantidad.
    print("\(prod5) x\(cant5): S/. \(String(format: "%.2f", totalProducto5))") // Imprime el total de cables USB después del descuento por cantidad.
    print("Descuento por 3+ USB: -S/. \(String(format: "%.2f", descuentoCantidad5))") // Muestra el 5% aplicado a los tres cables USB.
    print(separador) // Separa los productos del resumen de la compra.
    print("Subtotal: S/. \(String(format: "%.2f", subtotal))") // Imprime el subtotal después del descuento por cantidad.
    print("Descuento general (\(Int(porcentajeDescuento * 100))%): -S/. \(String(format: "%.2f", descuentoGeneral))") // Imprime el descuento general según el monto.
    print("IGV (18%): S/. \(String(format: "%.2f", igv))") // Imprime el IGV calculado.
    print("Cupón \(codigoCupon): -S/. \(String(format: "%.2f", descuentoCupon))") // Imprime el descuento adicional del cupón.
    print("Envío: \(costoEnvio == 0 ? "GRATIS" : "S/. \(String(format: "%.2f", costoEnvio))")") // Indica si el envío es gratis o muestra su costo.
    print(separador) // Separa el resumen del total final.
    print("TOTAL: S/. \(String(format: "%.2f", totalFinal))") // Imprime el total final que pagará el cliente.
    print("Puntos ganados: \(puntosFidelidad)") // Imprime los puntos completos obtenidos por la compra.
    print(separador) // Imprime la última línea del ticket.
} else { // Ejecuta esta alternativa cuando existe un precio o una cantidad inválida.
    print("Error: los precios no pueden ser negativos y las cantidades deben ser mayores que 0.") // Informa claramente por qué no se procesó la compra.
} // Cierra la validación general de los datos del carrito.
