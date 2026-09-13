// Desarrollado por: LuisDB
// Laboratorio 04 - Actividad Propuesta 02

import Foundation

// La clase base reúne los datos que comparten todos los tipos de cliente.
class Cliente {
    let codigo: String
    let direccion: String
    let fechaDeRegistro: String
    let numeroCuenta: String
    let montoMinimoApertura: Double

    init(
        codigo: String,
        direccion: String,
        fechaDeRegistro: String,
        numeroCuenta: String,
        montoMinimoApertura: Double
    ) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDeRegistro = fechaDeRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }

    // Muestra la información común; las subclases añadirán sus propios datos.
    func mostrarDatos() {
        print("📄 Código: \(codigo)")
        print("📍 Dirección: \(direccion)")
        print("🗓️ Fecha de registro: \(fechaDeRegistro)")
        print("🏦 N° Cuenta: \(numeroCuenta)")
        print("💰 Monto mínimo de apertura: S/ \(String(format: "%.2f", montoMinimoApertura))")
    }
}

// Especializa Cliente con los datos personales de una persona natural.
class ClienteNatural: Cliente {
    let nombreCompleto: String
    let dni: String

    init(
        nombreCompleto: String,
        dni: String,
        codigo: String,
        direccion: String,
        fechaDeRegistro: String,
        numeroCuenta: String,
        montoMinimoApertura: Double
    ) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        super.init(
            codigo: codigo,
            direccion: direccion,
            fechaDeRegistro: fechaDeRegistro,
            numeroCuenta: numeroCuenta,
            montoMinimoApertura: montoMinimoApertura
        )
    }

    // Sobrescribe el método para incluir nombre y DNI antes de los datos comunes.
    override func mostrarDatos() {
        print("👤 Cliente Natural:")
        print("Nombre: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.mostrarDatos()
    }
}

// Especializa Cliente con la información legal de una empresa.
class ClienteJuridico: Cliente {
    let razonSocial: String
    let ruc: String
    let representanteLegal: String

    init(
        razonSocial: String,
        ruc: String,
        representanteLegal: String,
        codigo: String,
        direccion: String,
        fechaDeRegistro: String,
        numeroCuenta: String,
        montoMinimoApertura: Double
    ) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(
            codigo: codigo,
            direccion: direccion,
            fechaDeRegistro: fechaDeRegistro,
            numeroCuenta: numeroCuenta,
            montoMinimoApertura: montoMinimoApertura
        )
    }

    // Sobrescribe el método para mostrar primero los datos propios de la empresa.
    override func mostrarDatos() {
        print("🏢 Cliente Jurídico:")
        print("Razón Social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante Legal: \(representanteLegal)")
        super.mostrarDatos()
    }
}

// Crea una persona natural con los valores mostrados en el ejemplo.
let clienteNatural = ClienteNatural(
    nombreCompleto: "Juan Pérez",
    dni: "12345678",
    codigo: "C001",
    direccion: "Av. Lima 123",
    fechaDeRegistro: "2025-04-03",
    numeroCuenta: "001-2025-000123",
    montoMinimoApertura: 500.0
)

// Crea una empresa con sus datos legales y bancarios.
let clienteJuridico = ClienteJuridico(
    razonSocial: "Soluciones SAC",
    ruc: "20123456789",
    representanteLegal: "María León",
    codigo: "C002",
    direccion: "Jr. Empresas 456",
    fechaDeRegistro: "2025-04-01",
    numeroCuenta: "001-2025-000456",
    montoMinimoApertura: 3000.0
)

// El array usa el tipo base para guardar objetos de ambas subclases.
let clientes: [Cliente] = [clienteNatural, clienteJuridico]

// Una misma llamada ejecuta la versión correcta según el tipo real del cliente.
for i in 0..<clientes.count {
    clientes[i].mostrarDatos()

    if i < clientes.count - 1 {
        print("----------------------------")
    }
}
