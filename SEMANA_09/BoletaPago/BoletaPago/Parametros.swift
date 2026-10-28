import Foundation

struct TasasAFP {
    let fondo: Decimal
    let comision: Decimal
    let seguro: Decimal
}

enum Parametros {
    static let consulta = "22/10/2026"
    static let rmv = Decimal(1230)
    static let asignacion = Decimal(string: "0.10")!
    static let onp = Decimal(string: "0.13")!
    static let essalud = Decimal(string: "0.09")!
    static let diasMes = Decimal(30)
    static let horasDia = Decimal(8)
    static let recargo25 = Decimal(string: "0.25")!
    static let recargo35 = Decimal(string: "0.35")!
    // SBS, octubre 2026: comisión por flujo. No se descuenta comisión anual por saldo.
    // AFP Guía es ficticia y reproduce el Excel; no confundir seguro 1.35% con el 1.37% de AFP reales.
    static let afps: [String: TasasAFP] = [
        "AFP Guía": TasasAFP(fondo: d("0.10"), comision: d("0.016"), seguro: d("0.0135")),
        "Habitat": TasasAFP(fondo: d("0.10"), comision: d("0.0147"), seguro: d("0.0137")),
        "Integra": TasasAFP(fondo: d("0.10"), comision: d("0.0155"), seguro: d("0.0137")),
        "Prima": TasasAFP(fondo: d("0.10"), comision: d("0.016"), seguro: d("0.0137")),
        "Profuturo": TasasAFP(fondo: d("0.10"), comision: d("0.0169"), seguro: d("0.0137"))
    ]
    static let ordenAFP = ["AFP Guía", "Habitat", "Integra", "Prima", "Profuturo"]
    static func d(_ texto: String) -> Decimal { Decimal(string: texto, locale: Locale(identifier: "en_US_POSIX"))! }
}

func redondear(_ valor: Decimal) -> Decimal {
    var original = valor
    var resultado = Decimal()
    NSDecimalRound(&resultado, &original, 2, .plain)
    return resultado
}

func soles(_ valor: Decimal) -> String {
    let formato = NumberFormatter()
    formato.locale = Locale(identifier: "en_US")
    formato.numberStyle = .decimal
    formato.minimumFractionDigits = 2
    formato.maximumFractionDigits = 2
    return "S/ " + (formato.string(from: NSDecimalNumber(decimal: valor)) ?? "0.00")
}
