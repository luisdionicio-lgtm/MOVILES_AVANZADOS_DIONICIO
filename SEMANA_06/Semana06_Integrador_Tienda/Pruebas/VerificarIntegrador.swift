import Foundation

@main
struct VerificarIntegrador {
    static func igual(_ actual: Double, _ esperado: Double) {
        precondition(abs(actual - esperado) < 0.000001, "Importe incorrecto: \(actual), esperado \(esperado)")
    }

    static func main() {
        // Escenario 1
        let refrigeradora = Producto(nombre: "Refrigeradora", precio: 2000, stock: 5)
        let licuadora = Producto(nombre: "Licuadora", precio: 250, stock: 10)
        let carrito = CarritoModel()
        precondition(carrito.agregar(producto: refrigeradora, cantidad: 1))
        precondition(carrito.agregar(producto: licuadora, cantidad: 2))
        igual(carrito.subtotal(), 2500)
        igual(carrito.descuento(), 250)
        igual(carrito.igv(), 405)
        igual(carrito.total(), 2655)
        precondition(carrito.categoria() == "VIP")
        print("PASS escenario 1: 2500 / 250 / 405 / 2655 / VIP")

        // Escenario 2
        let segundo = CarritoModel()
        let laptop = Producto(nombre: "Laptop", precio: 3500, stock: 3)
        precondition(segundo.agregar(producto: laptop, cantidad: 1))
        precondition(segundo.agregar(producto: licuadora, cantidad: 1))
        igual(segundo.subtotal(), 3750)
        igual(segundo.descuento(), 375)
        igual(segundo.igv(), 607.50)
        igual(segundo.total(), 3982.50)
        precondition(segundo.categoria() == "VIP")
        print("PASS escenario 2: 3750 / 375 / 607.50 / 3982.50 / VIP")

        // Escenario 3: no modifica nada si no alcanza el stock.
        let tercero = CarritoModel()
        precondition(!tercero.agregar(producto: laptop, cantidad: 4))
        precondition(tercero.items.isEmpty)
        print("PASS escenario 3: Laptop x4 rechazada")

        // Escenario 4: una sola línea, cantidades acumuladas.
        let cuarto = CarritoModel()
        precondition(cuarto.agregar(producto: licuadora, cantidad: 1))
        precondition(cuarto.agregar(producto: licuadora, cantidad: 1))
        precondition(cuarto.items.count == 1 && cuarto.items[0].cantidad == 2)
        precondition(!cuarto.agregar(producto: licuadora, cantidad: 9))
        precondition(cuarto.items[0].cantidad == 2)
        print("PASS escenario 4: Licuadora x2 en una línea y stock acumulado validado")

        // Escenario 5: referencia compartida, stock y vaciado.
        let referencia = carrito
        precondition(referencia === carrito)
        precondition(carrito.confirmarCompra())
        precondition(refrigeradora.stock == 4 && licuadora.stock == 8)
        precondition(referencia.cantidadTotal() == 0 && carrito.items.isEmpty)
        precondition(!carrito.confirmarCompra())
        precondition(refrigeradora.stock == 4 && licuadora.stock == 8)
        print("PASS escenario 5: stocks 4 y 8, carrito vacío, confirmación idempotente")

        // Límites de descuento y categoría.
        for (precio, porcentaje, categoria) in [
            (499.0, 0.0, "Regular"),
            (500.0, 0.05, "Frecuente"),
            (1999.0, 0.05, "Frecuente"),
            (2000.0, 0.10, "VIP"),
            (4999.0, 0.10, "VIP"),
            (5000.0, 0.15, "Premium")
        ] {
            let prueba = CarritoModel()
            precondition(prueba.agregar(producto: Producto(nombre: "Prueba", precio: precio, stock: 1), cantidad: 1))
            igual(prueba.porcentajeDescuento(), porcentaje)
            precondition(prueba.categoria() == categoria)
        }
        precondition(ValidacionCliente.mensaje(apellido: "Pérez", nombre: "Ana", dni: "12345678") == nil)
        for dni in ["", "123", "123456789", "1234abcd", "１２３４５６７８"] {
            precondition(ValidacionCliente.mensaje(apellido: "Pérez", nombre: "Ana", dni: dni) != nil)
        }
        precondition(ValidacionCliente.mensaje(apellido: " ", nombre: "Ana", dni: "12345678") != nil)
        precondition(ValidacionCliente.mensaje(apellido: "Pérez", nombre: "", dni: "12345678") != nil)
        let microondas = Producto(nombre: "Microondas", precio: 450, stock: 6)
        let quinto = CarritoModel()
        precondition(quinto.agregar(producto: microondas, cantidad: 1))
        igual(quinto.total(), 531)
        print("PASS límites de descuento, categoría, DNI, campos vacíos y Microondas")
    }
}
