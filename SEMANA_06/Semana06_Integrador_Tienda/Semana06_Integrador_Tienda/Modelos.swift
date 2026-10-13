// Desarrollado por: Luis Dionicio. Implementación asistida por IA.
import Foundation

class Producto {
    let nombre: String
    let precio: Double
    var stock: Int

    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
    }
}

class ItemCarrito {
    let producto: Producto
    var cantidad: Int

    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }

    func subtotal() -> Double {
        producto.precio * Double(cantidad)
    }
}

class CarritoModel {
    private(set) var items: [ItemCarrito] = []

    // A1: valida el stock acumulado y combina cantidades del mismo objeto.
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        guard cantidad > 0 else { return false }
        let existente = items.first { $0.producto === producto }
        let acumulada = existente?.cantidad ?? 0
        guard acumulada <= producto.stock,
              cantidad <= producto.stock - acumulada else { return false }
        if let existente = existente {
            existente.cantidad += cantidad
        } else {
            items.append(ItemCarrito(producto: producto, cantidad: cantidad))
        }
        return true
    }

    // A2
    func subtotal() -> Double {
        items.reduce(0) { $0 + $1.subtotal() }
    }

    // A3
    func porcentajeDescuento() -> Double {
        let importe = subtotal()
        if importe >= 5000 { return 0.15 }
        if importe >= 2000 { return 0.10 }
        if importe >= 500 { return 0.05 }
        return 0
    }

    // A4
    func cantidadTotal() -> Int {
        items.reduce(0) { $0 + $1.cantidad }
    }

    // A5
    func vaciar() {
        items.removeAll()
    }

    func descuento() -> Double { subtotal() * porcentajeDescuento() }
    func montoDescontado() -> Double { subtotal() - descuento() }
    func igv() -> Double { montoDescontado() * 0.18 }
    func total() -> Double { montoDescontado() + igv() }

    func categoria() -> String {
        switch Int(subtotal()) {
        case ..<500: return "Regular"
        case 500..<2000: return "Frecuente"
        case 2000..<5000: return "VIP"
        default: return "Premium"
        }
    }

    func lineasTexto() -> String {
        items.map { "\($0.producto.nombre) x\($0.cantidad)    \(soles($0.subtotal()))" }.joined(separator: "\n")
    }

    func resumenTexto() -> String {
        """
        Subtotal: \(soles(subtotal()))
        Descuento (\(Int(porcentajeDescuento() * 100))%): -\(soles(descuento()))
        IGV (18%): \(soles(igv()))

        TOTAL: \(soles(total()))
        Categoría: \(categoria())
        """
    }

    // Confirma una sola vez: descuenta stock y deja vacío el carrito compartido.
    func confirmarCompra() -> Bool {
        guard !items.isEmpty,
              items.allSatisfy({ $0.cantidad > 0 && $0.cantidad <= $0.producto.stock }) else { return false }
        for item in items {
            item.producto.stock -= item.cantidad
        }
        vaciar()
        return true
    }
}

func soles(_ valor: Double) -> String {
    String(format: "S/ %.2f", locale: Locale(identifier: "en_US_POSIX"), valor)
}

enum ValidacionCliente {
    static func mensaje(apellido: String, nombre: String, dni: String) -> String? {
        if apellido.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            dni.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Completa apellidos, nombres y DNI."
        }
        if dni.count != 8 || !dni.allSatisfy({ $0 >= "0" && $0 <= "9" }) {
            return "El DNI debe tener exactamente 8 dígitos."
        }
        return nil
    }
}
