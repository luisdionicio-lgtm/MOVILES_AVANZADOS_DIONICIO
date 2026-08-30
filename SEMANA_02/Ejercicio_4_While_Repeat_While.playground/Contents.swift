import Foundation

// Docente: Juan León S.
// ===== EJERCICIO 4: WHILE =====

// --- Ejemplo (ya resuelto): ---
var contador = 5
while contador > 0 {
    print("Cuenta regresiva: \(contador)")
    contador -= 1 // Resta 1 en cada vuelta.
}
print("¡Despegue!")

// --- TODO 11: Ahorro mensual ---
// Un alumno ahorra S/. 150 cada mes.
// ¿Cuántos meses necesita para juntar S/. 2000?
var ahorro = 0.0
var meses = 0
let meta = 2000.0
let ahorroMensual = 150.0

while ahorro < meta {
    ahorro += ahorroMensual
    meses += 1
}
print("Necesita \(meses) meses para juntar S/. \(meta)")

// --- TODO 12: División sucesiva ---
// Divide un número entre 2 repetidamente hasta que sea menor a 1.
var numero = 1000.0
var divisiones = 0

while numero >= 1 {
    numero = numero / 2
    divisiones += 1
    print("División \(divisiones): \(numero)")
}
print("Se dividió \(divisiones) veces")

// --- TODO 13: Validar datos con repeat-while ---
// Simula pedir una nota hasta que sea válida (entre 0 y 20).
// Se usan variables porque los arreglos se estudiarán en la semana 3.
let intento1 = 25 // Inválido: > 20
let intento2 = -3 // Inválido: < 0
let intento3 = 15 // Válido

var intentoActual = intento1
var esValido = false
var numIntento = 1

repeat {
    // La nota es válida cuando cumple ambas condiciones.
    if intentoActual >= 0 && intentoActual <= 20 {
        esValido = true
        print("Nota \(intentoActual) válida en intento \(numIntento)")
    } else {
        print("Nota \(intentoActual) inválida, intento \(numIntento)")

        // Simula el valor que se ingresaría en el siguiente intento.
        if numIntento == 1 {
            intentoActual = intento2
        }
        if numIntento == 2 {
            intentoActual = intento3
        }
        numIntento += 1
    }
} while !esValido

// PREDICT: ¿Cuántas veces se ejecuta cada bucle?

var a = 100
while a > 1 {
    a = a / 3
}
print(a) // PREDICT 8: valor final 1; se ejecuta 4 veces.

var b = 0
repeat {
    b += 1
} while b < 0
print(b) // PREDICT 9: valor 1; se ejecuta una vez.
// repeat-while ejecuta primero el bloque y comprueba la condición al final.
// Por eso siempre se ejecuta al menos una vez.
