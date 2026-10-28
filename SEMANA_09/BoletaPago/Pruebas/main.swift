import Foundation

let modelo = Boleta()
let esperados: [[String]] = [
    ["2500","0","0","0","325","0","0","0","0","2500","325","2175","225","2725"],
    ["1620","123","0","0","226.59","0","0","0","0","1743","226.59","1516.41","156.87","1899.87"],
    ["3000","123","62.50","67.50","0","325.30","52.05","43.92","200","3253","621.27","2631.73","292.77","3545.77"],
    ["3360","123","43.75","47.25","0","357.40","57.18","48.25","100","3574","562.83","3011.17","321.66","3895.66"],
    ["1600","0","0","0","208","0","0","0","0","1600","208","1392","144","1744"],
    ["4000","0","0","0","0","400","58.80","54.80","0","4000","513.60","3486.40","360","4360"],
    ["3466.67","123","41.67","67.50","0","369.88","54.37","50.67","150","3698.84","624.92","3073.92","332.90","4031.74"]
]
var resultados: [[String: Any]] = []
for (i, caso) in Casos.todos.enumerated() {
    let r = try modelo.calcular(caso.datos)
    let conceptos = r.remuneraciones.map(\.monto) + r.descuentos.map(\.monto)
    let valores = conceptos + [r.totalRemuneraciones, r.totalDescuentos, r.neto, r.aportaciones[0].monto, r.costoEmpleador]
    precondition(valores == esperados[i].map { Parametros.d($0) }, "Diferencia en caso \(i + 1)")
    resultados.append(["caso": i + 1, "valores": valores.map { NSDecimalNumber(decimal: $0).stringValue }])
}
func rechazar(_ datos: DatosMes) {
    do { _ = try modelo.calcular(datos); fatalError("Se aceptó una entrada inválida") }
    catch { /* Se rechaza sin emitir resultado. */ }
}
var invalido = Casos.todos[0].datos
invalido.sueldo = 0; rechazar(invalido)
invalido.sueldo = -1; rechazar(invalido)
invalido.sueldo = 2500; invalido.dias = 0; rechazar(invalido)
invalido.dias = 31; rechazar(invalido)
invalido.dias = 30; invalido.horas25 = -1; rechazar(invalido)
invalido.horas25 = 0; invalido.horas35 = -1; rechazar(invalido)
invalido.horas35 = 0; invalido.adelanto = -1; rechazar(invalido)
invalido.adelanto = 0; invalido.sistema = .afp; invalido.afp = "No existe"; rechazar(invalido)
for texto in ["", "abc", "1,234.56", "NaN", "Infinity", "12.345"] {
    do { _ = try Entrada.decimal(texto, nombre: "Prueba"); fatalError("Formato inválido aceptado") }
    catch {}
}
let decimalConComa = try Entrada.decimal("1730,50", nombre: "Prueba")
precondition(decimalConComa == Parametros.d("1730.50"))
precondition(redondear(Parametros.d("52.048")) == Parametros.d("52.05"))
precondition(redondear(Parametros.d("43.9155")) == Parametros.d("43.92"))
precondition(redondear(Parametros.d("1.005")) == Parametros.d("1.01"))
for dias in [1, 30] {
    var limite = Casos.todos[0].datos
    limite.dias = dias
    _ = try modelo.calcular(limite)
}
let json = try JSONSerialization.data(withJSONObject: resultados, options: [.prettyPrinted, .sortedKeys])
print(String(decoding: json, as: UTF8.self))
