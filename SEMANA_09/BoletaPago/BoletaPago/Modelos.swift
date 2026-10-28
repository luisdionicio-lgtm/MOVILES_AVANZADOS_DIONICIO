import Foundation

enum Sistema: String, CaseIterable {
    case onp = "ONP"
    case afp = "AFP"
}

struct DatosMes {
    var sueldo: Decimal
    var dias: Int
    var hijos: Bool
    var sistema: Sistema
    var afp: String
    var horas25: Decimal
    var horas35: Decimal
    var adelanto: Decimal
}

struct Concepto {
    let nombre: String
    let monto: Decimal
}

struct ResultadoBoleta {
    let remuneraciones: [Concepto]
    let descuentos: [Concepto]
    let aportaciones: [Concepto]
    var totalRemuneraciones: Decimal { remuneraciones.reduce(0) { $0 + $1.monto } }
    var totalDescuentos: Decimal { descuentos.reduce(0) { $0 + $1.monto } }
    var neto: Decimal { totalRemuneraciones - totalDescuentos }
    var costoEmpleador: Decimal { totalRemuneraciones + aportaciones.reduce(0) { $0 + $1.monto } }
}

enum ErrorBoleta: LocalizedError {
    case dato(String)
    var errorDescription: String? {
        switch self { case .dato(let mensaje): return mensaje }
    }
}

enum Entrada {
    // Acepta 1730.50 o 1730,50; no admite separadores de miles ambiguos.
    static func decimal(_ texto: String, nombre: String) throws -> Decimal {
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !limpio.isEmpty,
              limpio.range(of: #"^[+-]?[0-9]+([.,][0-9]{1,2})?$"#, options: .regularExpression) != nil,
              let numero = Decimal(string: limpio.replacingOccurrences(of: ",", with: "."),
                                   locale: Locale(identifier: "en_US_POSIX")),
              !numero.isNaN else {
            throw ErrorBoleta.dato("\(nombre): ingresa un número, sin separadores de miles y con hasta dos decimales.")
        }
        guard numero <= Parametros.d("10000000") else {
            throw ErrorBoleta.dato("\(nombre): el monto supera el límite de esta calculadora educativa (10 millones).")
        }
        return numero
    }
}
