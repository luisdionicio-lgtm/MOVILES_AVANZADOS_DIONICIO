import UIKit

// Paso 10 de la guía: modelo para los profesores de Tecsup.
class Profesor: NSObject {
    var nombre: String = ""
    var cargo: String = ""

    init(nombre: String, cargo: String) {
        self.nombre = nombre
        self.cargo = cargo
        super.init()
    }
}
