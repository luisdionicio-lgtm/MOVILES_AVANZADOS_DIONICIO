// Desarrollado por: LuisDB
// Laboratorio 04 - Actividad Propuesta 01

import Foundation

// Guarda los datos necesarios para identificar al alumno en la factura.
struct Estudiante {
    let nombre: String
    let dni: String
    let esAlumnoTecsup: Bool
}

// Representa un curso elegido junto con su precio y cantidad de inscripciones.
struct CursoInscrito {
    let nombre: String
    let precioUnitario: Double
    let cantidad: Int

    // Multiplica el precio por la cantidad para obtener el importe del curso.
    func calcularImporte() -> Double {
        return precioUnitario * Double(cantidad)
    }
}

// Reúne al estudiante y todos los cursos que forman parte de su matrícula.
class MatriculaCursos {
    let estudiante: Estudiante
    var cursos: [CursoInscrito] = []

    init(estudiante: Estudiante) {
        self.estudiante = estudiante
    }

    // Agrega un nuevo curso al arreglo de la matrícula.
    func agregar(curso: CursoInscrito) {
        cursos.append(curso)
    }
}
