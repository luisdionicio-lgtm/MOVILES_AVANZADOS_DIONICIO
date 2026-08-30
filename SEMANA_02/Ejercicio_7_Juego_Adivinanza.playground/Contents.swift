import Foundation // Importa las funciones básicas disponibles para el programa Swift.

// ===== EJERCICIO 7: JUEGO DE ADIVINANZA - ASISTIDO POR IA =====

let numeroSecreto = 42 // Define el número fijo que se debe adivinar.
let intento1 = 20 // Simula un primer intento menor que el número secreto.
let intento2 = 50 // Simula un segundo intento mayor que el número secreto.
let intento3 = 35 // Simula un tercer intento menor que el número secreto.
let intento4 = 42 // Simula un cuarto intento igual al número secreto.
let intento5 = 60 // Simula un quinto intento disponible si los anteriores fallan.

var numeroIntento = 1 // Lleva la cuenta del intento que se está procesando.
var intentoActual = 0 // Guarda temporalmente el valor del intento seleccionado.
var adivino = false // Indica si el número secreto ya fue encontrado.

print("===== JUEGO DE ADIVINANZA =====") // Imprime el título del juego.
print("Tienes 5 intentos para adivinar el número.") // Informa el límite de intentos.

while numeroIntento <= 5 && !adivino { // Repite el juego mientras queden intentos y no se haya acertado.
    if numeroIntento == 1 { // Comprueba si corresponde procesar el primer intento.
        intentoActual = intento1 // Copia el primer valor en la variable que será comparada.
    } else if numeroIntento == 2 { // Comprueba si corresponde procesar el segundo intento.
        intentoActual = intento2 // Copia el segundo valor en la variable que será comparada.
    } else if numeroIntento == 3 { // Comprueba si corresponde procesar el tercer intento.
        intentoActual = intento3 // Copia el tercer valor en la variable que será comparada.
    } else if numeroIntento == 4 { // Comprueba si corresponde procesar el cuarto intento.
        intentoActual = intento4 // Copia el cuarto valor en la variable que será comparada.
    } else { // Selecciona esta alternativa cuando corresponde el quinto intento.
        intentoActual = intento5 // Copia el quinto valor en la variable que será comparada.
    } // Cierra la selección del intento actual.

    print("Intento \(numeroIntento): \(intentoActual)") // Muestra el número de intento y el valor elegido.

    if intentoActual > numeroSecreto { // Comprueba si el intento supera el número secreto.
        print("Muy alto") // Informa que se debe intentar con un número menor.
    } else if intentoActual < numeroSecreto { // Comprueba si el intento está por debajo del número secreto.
        print("Muy bajo") // Informa que se debe intentar con un número mayor.
    } else { // Ejecuta esta alternativa cuando el intento coincide con el número secreto.
        print("¡Correcto!") // Informa que el jugador encontró el número.
        adivino = true // Cambia el estado para detener el bucle.
    } // Cierra la comparación entre el intento y el número secreto.

    numeroIntento += 1 // Incrementa el contador después de procesar cada intento.
} // Cierra el bucle de los cinco intentos simulados.

let intentosRealizados = numeroIntento - 1 // Calcula cuántos intentos se procesaron realmente.

if adivino { // Comprueba si el jugador acertó antes de agotar los intentos.
    print("Adivinaste en \(intentosRealizados) intentos.") // Muestra la cantidad de intentos necesarios para ganar.
} else { // Ejecuta esta alternativa si terminaron los cinco intentos sin acertar.
    print("Perdiste. El número era \(numeroSecreto)") // Revela el número secreto después de perder.
} // Cierra la verificación final del resultado del juego.
