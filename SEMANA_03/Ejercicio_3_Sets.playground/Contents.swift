// Desarrollado por: LuisDB
// Ejercicio 3: Sets

import Foundation

// ===== TODO 8: Eliminar duplicados =====
var numeros: [Int] = []

for i in 1...8 {
    print("Número \(i):")
    let numero = Int(readLine() ?? "") ?? 0
    numeros.append(numero)
}

print("Con duplicados: \(numeros)")

let sinDuplicados = Array(Set(numeros)).sorted()
print("Sin duplicados: \(sinDuplicados)")

// ===== TODO 9: Comparar asistencia =====
var asistenciaLunes: Set<String> = []
var asistenciaMartes: Set<String> = []

print("\n===== ASISTENCIA DEL LUNES =====")
for i in 1...4 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    asistenciaLunes.insert(nombre)
}

print("\n===== ASISTENCIA DEL MARTES =====")
for i in 1...4 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    asistenciaMartes.insert(nombre)
}

let ambosDias = asistenciaLunes.intersection(asistenciaMartes).sorted()
let soloLunes = asistenciaLunes.subtracting(asistenciaMartes).sorted()
let soloMartes = asistenciaMartes.subtracting(asistenciaLunes).sorted()

print("\n===== RESULTADOS DE ASISTENCIA =====")
print("Ambos días: \(ambosDias)")
print("Solo lunes: \(soloLunes)")
print("Solo martes: \(soloMartes)")

// ===== PREDICT =====
let conjuntoA: Set = [1, 2, 3, 4, 5]
let conjuntoB: Set = [4, 5, 6, 7, 8]

print(conjuntoA.intersection(conjuntoB)) // PREDICT 5: [4, 5], el orden puede variar.
print(conjuntoA.union(conjuntoB).count) // PREDICT 6: 8
print(conjuntoA.subtracting(conjuntoB)) // PREDICT 7: [1, 2, 3], el orden puede variar.

let repetidos: Set = ["A", "B", "A", "C", "B"]
print(repetidos.count) // PREDICT 8: 3
