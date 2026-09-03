// Desarrollado por: LuisDB
// Ejercicio 6: Gestión de notas - con IA

import Foundation // Importa utilidades como readLine y formato de texto.

var notasPorAlumno: [String: [Double]] = [:] // Guarda el nombre de cada alumno y sus tres notas.
var promediosPorAlumno: [String: Double] = [:] // Guarda el promedio calculado para cada alumno.

print("¿Cuántos alumnos desea registrar?") // Solicita la cantidad de alumnos al usuario.
let cantidadAlumnos = Int(readLine() ?? "") ?? 0 // Convierte la entrada a Int y usa cero si no es válida.

if cantidadAlumnos > 0 { // Evita construir un rango inválido cuando la cantidad es cero o negativa.
    for numeroAlumno in 1...cantidadAlumnos { // Repite el registro según la cantidad indicada.
        print("\nAlumno \(numeroAlumno) - Nombre:") // Solicita el nombre del alumno actual.
        let nombre = readLine() ?? "" // Lee el nombre y usa texto vacío si no hay entrada.
        var notas: [Double] = [] // Crea el array que almacenará las tres notas del alumno.

        for numeroNota in 1...3 { // Repite exactamente tres veces el ingreso de notas.
            print("Nota \(numeroNota):") // Indica qué nota debe ingresar el usuario.
            let nota = Double(readLine() ?? "") ?? 0 // Convierte la entrada a Double y usa cero si falla.
            notas.append(nota) // Agrega la nota al array del alumno actual.
        } // Finaliza el ingreso de las tres notas.

        notasPorAlumno[nombre] = notas // Relaciona el nombre del alumno con sus notas.
    } // Finaliza el registro de todos los alumnos.
} // Finaliza la validación de la cantidad de alumnos.

var sumaPromedios = 0.0 // Acumula los promedios para calcular el promedio general.
var notaMasAlta = 0.0 // Conserva la nota más alta encontrada en todos los alumnos.
var notaMasBaja = 20.0 // Conserva la nota más baja encontrada en todos los alumnos.
var totalAprobados = 0 // Cuenta alumnos con promedio mayor o igual a 13.
var hayNotas = false // Indica si se registró por lo menos una nota.

for (nombre, notas) in notasPorAlumno { // Recorre cada alumno junto con su array de notas.
    var sumaAlumno = 0.0 // Acumula las tres notas del alumno actual.

    for nota in notas { // Recorre cada nota del alumno actual.
        sumaAlumno += nota // Suma la nota actual para obtener después el promedio.

        if !hayNotas || nota > notaMasAlta { // Comprueba si la nota es la mayor registrada hasta ahora.
            notaMasAlta = nota // Actualiza la nota más alta.
        } // Finaliza la comparación de la nota más alta.

        if !hayNotas || nota < notaMasBaja { // Comprueba si la nota es la menor registrada hasta ahora.
            notaMasBaja = nota // Actualiza la nota más baja.
        } // Finaliza la comparación de la nota más baja.

        hayNotas = true // Confirma que ya existe al menos una nota registrada.
    } // Finaliza el recorrido de notas del alumno.

    let promedio = sumaAlumno / Double(notas.count) // Divide la suma entre tres para obtener el promedio.
    promediosPorAlumno[nombre] = promedio // Guarda el promedio asociado con el alumno.
    sumaPromedios += promedio // Acumula el promedio para la estadística general.

    if promedio >= 13 { // Verifica si el alumno alcanzó la nota mínima aprobatoria.
        totalAprobados += 1 // Incrementa el contador de alumnos aprobados.
    } // Finaliza la comprobación de aprobación.
} // Finaliza el cálculo de promedios y estadísticas.

let alumnosOrdenados = promediosPorAlumno.sorted { primero, segundo in // Ordena los alumnos por promedio descendente.
    primero.value > segundo.value // Coloca primero al alumno que tenga el promedio más alto.
} // Finaliza el criterio de ordenamiento.

print("\n===== REPORTE DE NOTAS =====") // Imprime el encabezado del reporte individual.

for (nombre, promedio) in alumnosOrdenados { // Recorre los alumnos ya ordenados por promedio.
    var clasificacion = "" // Prepara el texto que describirá el rendimiento del alumno.

    switch promedio { // Evalúa el promedio usando rangos de notas.
    case 18...20: // Identifica un promedio entre 18 y 20.
        clasificacion = "Excelente" // Asigna la clasificación más alta.
    case 15..<18: // Identifica un promedio desde 15 hasta menos de 18.
        clasificacion = "Bueno" // Asigna la clasificación de buen rendimiento.
    case 13..<15: // Identifica un promedio desde 13 hasta menos de 15.
        clasificacion = "Aprobado" // Asigna la clasificación aprobatoria básica.
    default: // Atiende cualquier promedio menor que 13 o fuera del rango esperado.
        clasificacion = "Desaprobado" // Asigna la clasificación desaprobatoria.
    } // Finaliza la clasificación con switch.

    print("\(nombre): promedio \(String(format: "%.2f", promedio)) - \(clasificacion)") // Muestra promedio y clasificación.
} // Finaliza la presentación del reporte individual.

let promedioGeneral = cantidadAlumnos > 0 ? sumaPromedios / Double(cantidadAlumnos) : 0 // Evita dividir entre cero.
let porcentajeAprobados = cantidadAlumnos > 0 ? Double(totalAprobados) * 100 / Double(cantidadAlumnos) : 0 // Calcula aprobados.

print("\n===== ESTADÍSTICAS =====") // Imprime el encabezado del resumen estadístico.
print("Promedio general: \(String(format: "%.2f", promedioGeneral))") // Muestra el promedio de toda la clase.
print("Nota más alta: \(String(format: "%.2f", hayNotas ? notaMasAlta : 0))") // Muestra la mayor nota o cero sin datos.
print("Nota más baja: \(String(format: "%.2f", hayNotas ? notaMasBaja : 0))") // Muestra la menor nota o cero sin datos.
print("Aprobados: \(totalAprobados) de \(cantidadAlumnos)") // Muestra la cantidad de alumnos aprobados.
print("Porcentaje de aprobados: \(String(format: "%.2f", porcentajeAprobados))%") // Muestra el porcentaje aprobatorio.
