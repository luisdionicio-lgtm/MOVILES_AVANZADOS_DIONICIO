import UIKit
import CoreData

enum Role: String, CaseIterable { case vendedor = "Vendedor", supervisor = "Supervisor" }
enum VentasError: LocalizedError {
    case message(String)
    var errorDescription: String? { if case let .message(s) = self { return s }; return nil }
}

@objc(Usuario)
class Usuario: NSManagedObject {
    @NSManaged var nombre: String
    @NSManaged var usuario: String
    @NSManaged var clave: String
    @NSManaged var rol: String
    @NSManaged var ventas: Set<Venta>
}
@objc(Producto)
class Producto: NSManagedObject {
    @NSManaged var nombre: String
    @NSManaged var categoria: String
    @NSManaged var precio: Double
    @NSManaged var stock: Int64
    @NSManaged var ventas: Set<Venta>
}
@objc(Cliente)
class Cliente: NSManagedObject {
    @NSManaged var nombre: String
    @NSManaged var documento: String
    @NSManaged var ventas: Set<Venta>
    var comprado: Double { ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total } }
    var categoria: String { comprado >= 5000 ? "VIP" : comprado >= 1000 ? "Frecuente" : "Regular" }
}
@objc(Venta)
class Venta: NSManagedObject {
    @NSManaged var fecha: Date
    @NSManaged var cantidad: Int64
    @NSManaged var precioUnitario: Double
    @NSManaged var descuento: Double
    @NSManaged var igv: Double
    @NSManaged var total: Double
    @NSManaged var anulada: Bool
    @NSManaged var motivoAnulacion: String?
    @NSManaged var vendedor: Usuario?
    @NSManaged var producto: Producto?
    @NSManaged var cliente: Cliente?
}

struct Importe {
    let subtotal: Double
    let descuento: Double
    let igv: Double
    var total: Double { subtotal - descuento + igv }
    init(precio: Double, cantidad: Int, vip: Bool) {
        let base = Decimal(string: String(precio))! * Decimal(cantidad)
        let rebaja = vip ? Self.round(base * Decimal(string: "0.10")!) : 0
        subtotal = NSDecimalNumber(decimal: Self.round(base)).doubleValue
        descuento = NSDecimalNumber(decimal: rebaja).doubleValue
        igv = NSDecimalNumber(decimal: Self.round((Self.round(base) - rebaja) * Decimal(string: "0.18")!)).doubleValue
    }
    static func round(_ value: Decimal) -> Decimal {
        var source = value
        var result = Decimal()
        NSDecimalRound(&result, &source, 2, .plain)
        return result
    }
}

final class Store {
    static let shared = Store()
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    var current: Usuario?
    var supervisor: Bool { current?.rol == Role.supervisor.rawValue }

    init(memory: Bool = false) {
        container = NSPersistentContainer(name: "Ventas")
        if memory { container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") }
        container.loadPersistentStores { _, error in
            if let error { fatalError("No se pudo abrir Ventas: \(error)") }
        }
    }
    func fetch<T: NSManagedObject>(_ name: String, predicate: NSPredicate? = nil, sort: String? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: name)
        request.predicate = predicate
        if let sort { request.sortDescriptors = [NSSortDescriptor(key: sort, ascending: true)] }
        do { return try context.fetch(request) }
        catch { print("Consulta \(name): \(error)"); return [] }
    }
    func save() throws {
        do { try context.save() }
        catch { context.rollback(); throw error }
    }
    func register(nombre: String, usuario: String, clave: String, confirmacion: String, rol: Role) throws -> Usuario {
        let n = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let u = usuario.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !n.isEmpty, !u.isEmpty else { throw VentasError.message("Completa nombre y usuario.") }
        let users: [Usuario] = fetch("Usuario", predicate: NSPredicate(format: "usuario ==[c] %@", u))
        guard users.isEmpty else { throw VentasError.message("Este usuario ya existe.") }
        guard clave.count >= 6 else { throw VentasError.message("La clave debe tener al menos 6 caracteres.") }
        guard clave == confirmacion else { throw VentasError.message("Las claves deben coincidir.") }
        let user = Usuario(context: context)
        user.nombre = n; user.usuario = u; user.clave = clave; user.rol = rol.rawValue
        try save()
        current = user
        return user
    }
    func login(usuario: String, clave: String) throws {
        let users: [Usuario] = fetch("Usuario", predicate: NSPredicate(format: "usuario ==[c] %@", usuario.trimmingCharacters(in: .whitespacesAndNewlines)))
        guard let user = users.first, user.clave == clave else { throw VentasError.message("Usuario o clave incorrectos") }
        current = user
    }
    func product(_ existing: Producto?, nombre: String, categoria: String, precio: Double, stock: Int) throws {
        guard supervisor else { throw VentasError.message("Acción exclusiva del supervisor.") }
        guard !nombre.trimmingCharacters(in: .whitespaces).isEmpty, !categoria.isEmpty,
              precio.isFinite, precio > 0, stock >= 0 else { throw VentasError.message("Revisa nombre, categoría, precio y stock.") }
        let p = existing ?? Producto(context: context)
        p.nombre = nombre; p.categoria = categoria; p.precio = precio; p.stock = Int64(stock)
        try save()
    }
    func client(_ existing: Cliente?, nombre: String, documento: String) throws {
        guard current != nil else { throw VentasError.message("Inicia sesión.") }
        guard !nombre.trimmingCharacters(in: .whitespaces).isEmpty, !documento.trimmingCharacters(in: .whitespaces).isEmpty
        else { throw VentasError.message("Completa nombre y documento.") }
        let c = existing ?? Cliente(context: context)
        c.nombre = nombre; c.documento = documento
        try save()
    }
    func sell(cliente: Cliente, producto: Producto, cantidad: Int) throws -> Venta {
        guard let user = current, user.rol == Role.vendedor.rawValue else { throw VentasError.message("Solo un vendedor puede registrar ventas.") }
        guard cantidad > 0, cantidad <= producto.stock else { throw VentasError.message("Cantidad inválida o stock insuficiente.") }
        let amount = Importe(precio: producto.precio, cantidad: cantidad, vip: cliente.categoria == "VIP")
        let v = Venta(context: context)
        v.fecha = Date(); v.cantidad = Int64(cantidad); v.precioUnitario = producto.precio
        v.descuento = amount.descuento; v.igv = amount.igv; v.total = amount.total; v.anulada = false
        v.vendedor = user; v.cliente = cliente; v.producto = producto
        producto.stock -= Int64(cantidad)
        try save()
        return v
    }
    func cancel(_ venta: Venta, motivo: String) throws {
        guard supervisor else { throw VentasError.message("Acción exclusiva del supervisor.") }
        guard !venta.anulada else { throw VentasError.message("Esta venta ya está anulada.") }
        let reason = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !reason.isEmpty else { throw VentasError.message("Escribe el motivo de anulación.") }
        guard let product = venta.producto else { throw VentasError.message("Producto no disponible.") }
        venta.anulada = true; venta.motivoAnulacion = reason
        product.stock += venta.cantidad
        try save()
    }
    func delete(_ object: NSManagedObject) throws {
        guard supervisor else { throw VentasError.message("Acción exclusiva del supervisor.") }
        if let sales = object.value(forKey: "ventas") as? Set<Venta>, !sales.isEmpty {
            throw VentasError.message("No se puede borrar porque tiene ventas registradas.")
        }
        context.delete(object)
        try save()
    }
    func sales(text: String = "", period: Int = 0, seller: Usuario? = nil) -> [Venta] {
        guard let user = current else { return [] }
        var predicates = [NSPredicate]()
        if !supervisor { predicates.append(NSPredicate(format: "vendedor == %@", user)) }
        else if let seller { predicates.append(NSPredicate(format: "vendedor == %@", seller)) }
        if !text.isEmpty { predicates.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", text)) }
        let calendar = Calendar.current
        if period > 0 {
            let component: Calendar.Component = period == 1 ? .day : .month
            if let interval = calendar.dateInterval(of: component, for: Date()) {
                predicates.append(NSPredicate(format: "fecha >= %@ AND fecha < %@", interval.start as NSDate, interval.end as NSDate))
            }
        }
        let rows: [Venta] = fetch("Venta", predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicates))
        return rows.sorted { $0.fecha > $1.fecha }
    }
}
