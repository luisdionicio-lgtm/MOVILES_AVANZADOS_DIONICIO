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

    // Suma las cantidades porque un mismo curso puede registrarse más de una vez.
    func cantidadTotalCursos() -> Int {
        var cantidadTotal = 0
        for curso in cursos {
            cantidadTotal += curso.cantidad
        }
        return cantidadTotal
    }

    // Acumula el importe de todos los cursos antes del impuesto.
    func calcularSubtotal() -> Double {
        var subtotal = 0.0
        for curso in cursos {
            subtotal += curso.calcularImporte()
        }
        return subtotal
    }

    // Calcula el IGV peruano usando el 18 % del subtotal.
    func calcularIGV() -> Double {
        return calcularSubtotal() * 0.18
    }

    // Suma el subtotal y el impuesto antes de aplicar descuentos.
    func calcularTotalConIGV() -> Double {
        return calcularSubtotal() + calcularIGV()
    }

    // Aplica 10 % al total con IGV cuando se compran tres cursos o más.
    func calcularDescuentoCantidad() -> Double {
        if cantidadTotalCursos() >= 3 {
            return calcularTotalConIGV() * 0.10
        }
        return 0.0
    }

    // Aplica S/ 400 adicionales solo a alumnos Tecsup con tres cursos o más.
    func calcularDescuentoTecsup() -> Double {
        if estudiante.esAlumnoTecsup && cantidadTotalCursos() >= 3 {
            return 400.0
        }
        return 0.0
    }

    // Resta ambos descuentos para obtener el importe final de la matrícula.
    func calcularTotalFinal() -> Double {
        return calcularTotalConIGV() - calcularDescuentoCantidad() - calcularDescuentoTecsup()
    }

    // Imprime una factura detallada con montos formateados a dos decimales.
    func mostrarFactura() {
        print("🎓 FACTURA DE CURSOS")
        print("Estudiante: \(estudiante.nombre)")
        print("DNI: \(estudiante.dni)")

        if estudiante.esAlumnoTecsup {
            print("Alumno de Tecsup: Sí ✅")
        } else {
            print("Alumno de Tecsup: No")
        }

        print("--------------------------------")
        for curso in cursos {
            let importe = curso.calcularImporte()
            print("\(curso.nombre) x\(curso.cantidad) - S/ \(String(format: "%.2f", importe))")
        }

        print("--------------------------------")
        print("Subtotal: S/ \(String(format: "%.2f", calcularSubtotal()))")
        print("IGV (18%): S/ \(String(format: "%.2f", calcularIGV()))")
        print("Total con IGV: S/ \(String(format: "%.2f", calcularTotalConIGV()))")
        print("Descuento 10% por cantidad: -S/ \(String(format: "%.2f", calcularDescuentoCantidad())) ✅")
        print("Descuento especial Tecsup: -S/ \(String(format: "%.2f", calcularDescuentoTecsup())) ✅")
        print("--------------------------------")
        print("💰 TOTAL FINAL A PAGAR: S/ \(String(format: "%.2f", calcularTotalFinal()))")
    }
}

// Datos de prueba tomados de la salida propuesta en la guía.
let estudiante = Estudiante(nombre: "Juan León", dni: "78965412", esAlumnoTecsup: true)
let matricula = MatriculaCursos(estudiante: estudiante)

matricula.agregar(curso: CursoInscrito(nombre: "Swift Avanzado", precioUnitario: 450.0, cantidad: 1))
matricula.agregar(curso: CursoInscrito(nombre: "IA con Python", precioUnitario: 650.0, cantidad: 2))
matricula.agregar(curso: CursoInscrito(nombre: "Diseño UX/UI", precioUnitario: 500.0, cantidad: 1))
matricula.mostrarFactura()
