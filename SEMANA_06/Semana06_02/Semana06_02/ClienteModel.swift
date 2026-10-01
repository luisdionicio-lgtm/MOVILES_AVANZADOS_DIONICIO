import Foundation

final class ClienteModel: NSObject {
    var codigo: Int32
    var apellido: String
    var nombre: String
    var dni: String

    override init() {
        codigo = 0
        apellido = ""
        nombre = ""
        dni = ""
        super.init()
    }

    init(codigo: Int32, apellido: String, nombre: String, dni: String) {
        self.codigo = codigo
        self.apellido = apellido
        self.nombre = nombre
        self.dni = dni
        super.init()
    }
}
