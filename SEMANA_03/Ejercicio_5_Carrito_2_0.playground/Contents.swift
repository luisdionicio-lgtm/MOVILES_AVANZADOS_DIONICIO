// Desarrollado por: LuisDB
// Ejercicio 5: Carrito de Compras 2.0

import Foundation

// ===== CARRITO DE COMPRAS 2.0 =====
var nombres: [String] = []
var precios: [Double] = []
var cantidades: [Int] = []

// ===== TODO 11: Pedir productos =====
print("¿Cuántos productos va a comprar?")
let totalProductos = Int(readLine() ?? "") ?? 0

if totalProductos > 0 {
    for i in 1...totalProductos {
        print("\nProducto \(i) - Nombre:")
        nombres.append(readLine() ?? "")

        print("Precio unitario:")
        precios.append(Double(readLine() ?? "") ?? 0)

        print("Cantidad:")
        cantidades.append(Int(readLine() ?? "") ?? 0)
    }
}

// ===== TODO 12: Calcular subtotales =====
var subtotales: [Double] = []

for i in 0..<nombres.count {
    let subtotal = precios[i] * Double(cantidades[i])
    subtotales.append(subtotal)
}

// ===== TODO 13: Total del carrito =====
var totalCarrito = 0.0

for subtotal in subtotales {
    totalCarrito += subtotal
}

// ===== TODO 14: Nombre del cliente =====
print("\nNombre del cliente:")
let cliente = readLine() ?? ""

// ===== TODO 15: Descuento =====
var porcentajeDescuento = 0.0

if totalCarrito >= 5000 {
    porcentajeDescuento = 0.15
} else if totalCarrito >= 2000 {
    porcentajeDescuento = 0.10
} else if totalCarrito >= 500 {
    porcentajeDescuento = 0.05
}

let descuento = totalCarrito * porcentajeDescuento
let totalConDescuento = totalCarrito - descuento

// ===== TODO 16: IGV y total =====
let igv = totalConDescuento * 0.18
let totalFinal = totalConDescuento + igv

// ===== TODO 17: Categoría =====
var categoria = ""

switch Int(totalCarrito) {
case 0..<500:
    categoria = "Regular"
case 500..<2000:
    categoria = "Frecuente"
case 2000..<5000:
    categoria = "VIP"
default:
    categoria = "Premium"
}

// ===== TODO 18: Ticket =====
let separador = String(repeating: "=", count: 45)

print("\n\(separador)")
print("TICKET DE COMPRA 2.0")
print("Cliente: \(cliente) (\(categoria))")
print(separador)

for i in 0..<nombres.count {
    print("\(nombres[i]) x\(cantidades[i]) S/. \(String(format: "%.2f", subtotales[i]))")
}

print(separador)
print("Subtotal: S/. \(String(format: "%.2f", totalCarrito))")

if porcentajeDescuento > 0 {
    print("Descuento (\(String(format: "%.1f", porcentajeDescuento * 100))%): -S/. \(String(format: "%.2f", descuento))")
}

print("IGV (18%): S/. \(String(format: "%.2f", igv))")
print(separador)
print("TOTAL: S/. \(String(format: "%.2f", totalFinal))")
print(separador)
print("¡Gracias por su compra, \(cliente)!")
