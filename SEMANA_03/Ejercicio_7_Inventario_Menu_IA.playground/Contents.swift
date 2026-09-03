// Desarrollado por: LuisDB
// Ejercicio 7: Inventario con menú - con IA

import Foundation // Importa readLine y las funciones de formato numérico.

var precios: [String: Double] = [:] // Relaciona el nombre de cada producto con su precio.
var stocks: [String: Int] = [:] // Relaciona el nombre de cada producto con su stock.

print("¿Cuántos productos desea registrar?") // Solicita la cantidad inicial de productos.
let cantidadProductos = Int(readLine() ?? "") ?? 0 // Convierte la entrada a Int y usa cero si falla.

if cantidadProductos > 0 { // Evita crear un rango inválido cuando no existen productos.
    for numeroProducto in 1...cantidadProductos { // Repite el registro para cada producto solicitado.
        print("\nProducto \(numeroProducto) - Nombre:") // Solicita el nombre del producto actual.
        let nombre = readLine() ?? "" // Lee el nombre y usa texto vacío si no hay entrada.

        print("Precio:") // Solicita el precio unitario del producto.
        let precio = Double(readLine() ?? "") ?? 0 // Convierte el precio a Double y usa cero si falla.

        print("Stock:") // Solicita la cantidad disponible del producto.
        let stock = Int(readLine() ?? "") ?? 0 // Convierte el stock a Int y usa cero si falla.

        precios[nombre] = precio // Guarda el precio usando el nombre como clave.
        stocks[nombre] = stock // Guarda el stock usando la misma clave de producto.
    } // Finaliza el registro de productos.
} // Finaliza la validación de la cantidad inicial.

var opcion = 0 // Conserva la opción elegida y permite iniciar el menú.

while opcion != 5 { // Mantiene activo el menú hasta que el usuario elija salir.
    print("\n===== MENÚ DE INVENTARIO =====") // Muestra el título del menú principal.
    print("1. Ver inventario") // Presenta la opción para listar todos los productos.
    print("2. Buscar producto") // Presenta la opción para consultar un producto por nombre.
    print("3. Mostrar stock bajo") // Presenta la opción para filtrar stocks menores que cinco.
    print("4. Calcular valor total") // Presenta la opción para valorizar todo el inventario.
    print("5. Salir") // Presenta la opción que termina el programa.
    print("Seleccione una opción:") // Solicita al usuario una opción del menú.
    opcion = Int(readLine() ?? "") ?? 0 // Convierte la opción a Int y usa cero si no es válida.

    switch opcion { // Ejecuta una acción diferente según la opción elegida.
    case 1: // Atiende la solicitud de mostrar el inventario completo.
        print("\n===== INVENTARIO =====") // Imprime el encabezado del reporte general.

        if precios.isEmpty { // Comprueba si todavía no existen productos registrados.
            print("El inventario está vacío") // Informa que no hay productos para mostrar.
        } else { // Continúa cuando el inventario contiene productos.
            for nombre in precios.keys.sorted() { // Recorre los nombres en orden alfabético.
                if let precio = precios[nombre], let stock = stocks[nombre] { // Obtiene precio y stock de forma segura.
                    print("\(nombre) | Precio: S/. \(String(format: "%.2f", precio)) | Stock: \(stock)") // Muestra una fila formateada.
                } // Finaliza la lectura segura de los datos del producto.
            } // Finaliza el recorrido del inventario.
        } // Finaliza la validación de inventario vacío.

    case 2: // Atiende la solicitud de buscar un producto.
        print("\nNombre del producto que desea buscar:") // Solicita la clave exacta del producto.
        let productoBuscado = readLine() ?? "" // Lee el nombre que se buscará en los diccionarios.

        if let precio = precios[productoBuscado], let stock = stocks[productoBuscado] { // Comprueba si existe el producto.
            print("Producto encontrado: \(productoBuscado)") // Confirma que la búsqueda tuvo éxito.
            print("Precio: S/. \(String(format: "%.2f", precio))") // Muestra el precio del producto encontrado.
            print("Stock: \(stock) unidades") // Muestra el stock del producto encontrado.
        } else { // Atiende una búsqueda sin coincidencias.
            print("Producto no encontrado") // Informa que la clave no existe en el inventario.
        } // Finaliza la búsqueda del producto.

    case 3: // Atiende la solicitud de mostrar productos con pocas unidades.
        print("\n===== STOCK BAJO =====") // Imprime el encabezado del reporte de stock bajo.
        var hayStockBajo = false // Registra si se encontró al menos un producto con stock bajo.

        for nombre in stocks.keys.sorted() { // Recorre alfabéticamente todas las claves de stock.
            if let stock = stocks[nombre], stock < 5 { // Filtra productos con menos de cinco unidades.
                print("\(nombre): \(stock) unidades") // Muestra el producto que necesita reposición.
                hayStockBajo = true // Confirma que el reporte contiene al menos un resultado.
            } // Finaliza la evaluación del stock actual.
        } // Finaliza el recorrido de stocks.

        if !hayStockBajo { // Comprueba si ningún producto cumplió el filtro.
            print("No hay productos con stock bajo") // Informa que todos tienen cinco unidades o más.
        } // Finaliza la validación de resultados del filtro.

    case 4: // Atiende la solicitud de valorizar el inventario.
        var valorTotal = 0.0 // Prepara el acumulador del valor de todos los productos.

        for (nombre, precio) in precios { // Recorre cada nombre junto con su precio unitario.
            if let stock = stocks[nombre] { // Obtiene el stock relacionado de forma segura.
                valorTotal += precio * Double(stock) // Suma precio por cantidad al valor total.
            } // Finaliza la lectura segura del stock.
        } // Finaliza el recorrido para calcular el total.

        print("\nValor total del inventario: S/. \(String(format: "%.2f", valorTotal))") // Muestra el total monetario.

    case 5: // Atiende la opción de terminar el programa.
        print("\nSaliendo del sistema de inventario...") // Confirma al usuario que el menú finalizará.

    default: // Atiende números distintos de las cinco opciones disponibles.
        print("\nOpción inválida. Intente nuevamente.") // Solicita elegir una opción válida.
    } // Finaliza la selección de acciones del menú.
} // Finaliza el ciclo del menú cuando la opción es cinco.
