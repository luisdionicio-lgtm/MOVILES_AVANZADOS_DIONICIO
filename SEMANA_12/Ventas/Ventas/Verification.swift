import Foundation
import CoreData

#if DEBUG
enum Verification {
    static func run() {
        let s = Store(memory: true)
        var passed = [String]()
        func check(_ condition: Bool, _ name: String) {
            precondition(condition, "FALLO · "+name)
            passed.append(name)
            print("PASS · "+name)
        }
        func fails(_ action: () throws -> Void) -> Bool {
            do { try action(); return false } catch { return true }
        }
        do {
            let supervisor = try s.register(nombre: "Luis Dionicio Bartolo", usuario: "lparedes", clave: "Prueba123", confirmacion: "Prueba123", rol: .supervisor)
            check(s.current == supervisor && fails { _ = try s.register(nombre: "Duplicado", usuario: "LPAREDES", clave: "Prueba123", confirmacion: "Prueba123", rol: .supervisor) }, "1 usuario único e inicio directo")
            check(fails { _ = try s.register(nombre: "Andy", usuario: "andy", clave: "1234", confirmacion: "1234", rol: .vendedor) } &&
                  fails { _ = try s.register(nombre: "Andy", usuario: "andy", clave: "123456", confirmacion: "654321", rol: .vendedor) }, "2 claves inválidas")
            s.current = nil
            check(fails { try s.login(usuario: "lparedes", clave: "incorrecta") } && s.current == nil, "3 login inválido")
            s.current = supervisor
            try s.product(nil, nombre: "Laptop", categoria: "Tecnología", precio: 200, stock: 40)
            try s.product(nil, nombre: "Mouse", categoria: "Accesorios", precio: 35, stock: 40)
            try s.client(nil, nombre: "Cliente VIP Demo", documento: "DEMO-VIP")
            try s.client(nil, nombre: "Andy Campos Escandon", documento: "DEMO-ANDY")
            let products: [Producto] = s.fetch("Producto", sort: "nombre")
            let laptop = products.first { $0.nombre == "Laptop" }!
            let mouse = products.first { $0.nombre == "Mouse" }!
            let clients: [Cliente] = s.fetch("Cliente")
            let vip = clients.first { $0.documento == "DEMO-VIP" }!
            let regular = clients.first { $0.documento == "DEMO-ANDY" }!
            let seller = try s.register(nombre: "Andy Campos Escandon", usuario: "andy", clave: "Prueba123", confirmacion: "Prueba123", rol: .vendedor)
            let prior = Venta(context: s.context)
            prior.fecha = Date(); prior.cantidad = 1; prior.precioUnitario = 5000
            prior.descuento = 0; prior.igv = 900; prior.total = 5900; prior.anulada = false
            prior.cliente = vip; prior.producto = mouse; prior.vendedor = seller
            try s.save()
            let v = try s.sell(cliente: vip, producto: laptop, cantidad: 2)
            check(v.descuento == 40 && v.igv == 64.8 && abs(v.total - 424.8) < 0.001 && laptop.stock == 38, "4 venta VIP")
            let m = try s.sell(cliente: regular, producto: mouse, cantidad: 3)
            check(m.igv == 18.9 && abs(m.total - 123.9) < 0.001, "5 venta regular")
            check(fails { _ = try s.sell(cliente: regular, producto: laptop, cantidad: 50) } && laptop.stock == 38, "6 stock insuficiente")
            _ = try s.register(nombre: "Luis Dionicio Bartolo", usuario: "luis", clave: "Prueba123", confirmacion: "Prueba123", rol: .vendedor)
            check(s.sales().isEmpty && fails { try s.cancel(v, motivo: "Prueba") }, "7 visibilidad y permisos")
            s.current = supervisor
            check(fails { try s.cancel(v, motivo: "   ") } && !v.anulada, "8a motivo obligatorio")
            let before = s.sales().filter { !$0.anulada }.reduce(0) { $0+$1.total }
            try s.cancel(v, motivo: "Devolución de prueba")
            let after = s.sales().filter { !$0.anulada }.reduce(0) { $0+$1.total }
            check(v.anulada && laptop.stock == 40 && abs(before-after-424.8) < 0.001, "8b anulación y reporte")
            check(fails { try s.delete(vip) } && !vip.isDeleted, "9 borrado protegido")
            s.context.delete(vip)
            check(fails { try s.context.save() }, "9b regla Deny del modelo")
            s.context.rollback()
            check(fails { try s.cancel(v, motivo: "Otra vez") } && laptop.stock == 40, "10 anulación única")
            let a = Importe(precio: 200, cantidad: 2, vip: true)
            check(abs(a.total-424.8) < 0.001, "11 cálculo reproducible")
            let data = try JSONSerialization.data(withJSONObject: ["resultado":"PASS","pruebas":passed], options: .prettyPrinted)
            let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("pruebas-grupo-a.json")
            try data.write(to: url)
            print("VERIFICACION COMPLETA · \(passed.count) comprobaciones · \(url.path)")
        } catch { fatalError("Pruebas: \(error)") }
    }
}
#endif
