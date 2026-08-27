import Foundation

// Definir el promedio por pesos
let parcial = 0.3
let trabajo = 0.3
let final = 0.4

// Ingreso de datos
print("Nombre del Alumno:")
let alumno = readLine() ?? ""

print("Nota del Examen Parcial:")
let exParcial = Double(readLine() ?? "") ?? 0

print("Nota del Trabajo:")
let notaTrabajo = Double(readLine() ?? "") ?? 0

print("Nota del Examen Final:")
let exFinal = Double(readLine() ?? "") ?? 0

// Cálculo del promedio
let promedio = (exParcial * parcial) +
               (notaTrabajo * trabajo) +
               (exFinal * final)
