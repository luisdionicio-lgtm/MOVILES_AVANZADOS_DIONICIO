// Desarrollado por: LuisDB
// Ejercicio 4: Combinación de Colecciones

import Foundation

// ===== TODO 10: Inventario de productos =====
var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("¿Cuántos productos?")
let cantidadProductos = Int(readLine() ?? "") ?? 0

if cantidadProductos > 0 {
    for i in 1...cantidadProductos {
        print("\nProducto \(i) - Nombre:")
        let nombre = readLine() ?? ""

        print("Precio:")
        let precio = Double(readLine() ?? "") ?? 0

        print("Stock:")
        let stock = Int(readLine() ?? "") ?? 0

        precios[nombre] = precio
        stocks[nombre] = stock
    }
}

// Calcular el valor total del inventario (precio x stock).
var valorTotalInventario = 0.0

for (nombre, precio) in precios {
    if let stock = stocks[nombre] {
        valorTotalInventario += precio * Double(stock)
    }
}

print("\n===== INVENTARIO =====")
for nombre in precios.keys.sorted() {
    if let precio = precios[nombre], let stock = stocks[nombre] {
        let valorProducto = precio * Double(stock)
        print("\(nombre): S/. \(precio) x \(stock) = S/. \(valorProducto)")
    }
}

print("Valor total del inventario: S/. \(valorTotalInventario)")

// Mostrar los productos cuyo stock es menor que 5.
print("\n===== STOCK BAJO =====")
var hayStockBajo = false

for nombre in stocks.keys.sorted() {
    if let stock = stocks[nombre], stock < 5 {
        print("\(nombre): \(stock) unidades")
        hayStockBajo = true
    }
}

if !hayStockBajo {
    print("No hay productos con stock bajo")
}
