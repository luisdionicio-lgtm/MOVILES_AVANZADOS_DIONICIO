import UIKit

// Modelo de profesores; el paso 16 incorpora su fotografía.
class Profesor: NSObject {
    var nombre: String = ""
    var cargo: String = ""
    var foto: UIImage?

    init(nombre: String, cargo: String, foto: UIImage?) {
        self.nombre = nombre
        self.cargo = cargo
        self.foto = foto
        super.init()
    }
}
