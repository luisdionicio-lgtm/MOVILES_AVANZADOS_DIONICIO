import Foundation
import CoreData

enum Demo {
    static func load() throws {
        let s = Store.shared
        let accounts: [Usuario] = s.fetch("Usuario")
        guard accounts.isEmpty else { throw VentasError.message("La demostración se carga solo en una base sin usuarios.") }
        let supervisor = try s.register(nombre: "Luis Dionicio Bartolo", usuario: "luis", clave: "Ventas123", confirmacion: "Ventas123", rol: .supervisor)
        for item in [("Laptop","Tecnología",200.0,40),("Mouse","Accesorios",35.0,40),("Monitor","Tecnología",600.0,8),("Teclado","Accesorios",85.0,4)] {
            try s.product(nil, nombre: item.0, categoria: item.1, precio: item.2, stock: item.3)
        }
        try s.client(nil, nombre: "Jaime Gomez", documento: "DEMO-JAIME")
        try s.client(nil, nombre: "Juan Leon", documento: "DEMO-JUAN")
        let seller = try s.register(nombre: "Andy Campos Escandon", usuario: "andy", clave: "Ventas123", confirmacion: "Ventas123", rol: .vendedor)
        let other = try s.register(nombre: "Luis Dionicio Bartolo", usuario: "luis.ventas", clave: "Ventas123", confirmacion: "Ventas123", rol: .vendedor)
        let clients: [Cliente] = s.fetch("Cliente", sort: "nombre")
        let products: [Producto] = s.fetch("Producto")
        let laptop = products.first { $0.nombre == "Laptop" }!
        let mouse = products.first { $0.nombre == "Mouse" }!
        for index in 1...7 {
            let v = Venta(context: s.context)
            let price = 700.0
            let amount = Importe(precio: price, cantidad: 1, vip: false)
            v.fecha = Calendar.current.date(byAdding: .day, value: -index, to: Date())!
            v.cantidad = 1; v.precioUnitario = price; v.descuento = amount.descuento
            v.igv = amount.igv; v.total = amount.total; v.anulada = false
            v.cliente = clients[0]; v.producto = laptop; v.vendedor = index % 2 == 0 ? seller : other
        }
        try s.save()
        s.current = seller
        _ = try s.sell(cliente: clients[0], producto: laptop, cantidad: 2)
        _ = try s.sell(cliente: clients[1], producto: mouse, cantidad: 3)
        s.current = supervisor
        s.current = supervisor
    }
}
