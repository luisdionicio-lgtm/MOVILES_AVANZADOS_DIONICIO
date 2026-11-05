import Foundation
import SwiftData

// DEMOSTRACIÓN: relación 1 a muchos (un Curso tiene muchos Alumnos)
@Model
class Curso {
    var nombre: String
    // .nullify deja a los alumnos sin curso si se elimina.
    @Relationship(deleteRule: .nullify, inverse: \Alumno.curso)
    var alumnos: [Alumno] = []

    init(nombre: String) {
        self.nombre = nombre
    }
}
