import Foundation

final class Boleta {
    func calcular(_ datos: DatosMes) throws -> ResultadoBoleta {
        guard datos.sueldo > 0 else { throw ErrorBoleta.dato("El sueldo básico debe ser mayor que cero.") }
        guard (1...30).contains(datos.dias) else { throw ErrorBoleta.dato("Los días laborados deben ser un entero entre 1 y 30.") }
        guard datos.horas25 >= 0, datos.horas35 >= 0 else { throw ErrorBoleta.dato("Las horas extras no pueden ser negativas.") }
        guard datos.adelanto >= 0 else { throw ErrorBoleta.dato("El adelanto no puede ser negativo.") }
        guard let tasas = Parametros.afps[datos.afp] else { throw ErrorBoleta.dato("Selecciona una AFP válida.") }
        let hora = datos.sueldo / Parametros.diasMes / Parametros.horasDia
        let remuneraciones = [
            Concepto(nombre: "Sueldo computable", monto: redondear(datos.sueldo / Parametros.diasMes * Decimal(datos.dias))),
            Concepto(nombre: "Asignación familiar", monto: datos.hijos ? redondear(Parametros.rmv * Parametros.asignacion) : 0),
            Concepto(nombre: "Horas extras 25%", monto: redondear(hora * (1 + Parametros.recargo25) * datos.horas25)),
            Concepto(nombre: "Horas extras 35%", monto: redondear(hora * (1 + Parametros.recargo35) * datos.horas35))
        ]
        let total = remuneraciones.reduce(Decimal(0)) { $0 + $1.monto }
        let usaAFP = datos.sistema == .afp
        let descuentos = [
            Concepto(nombre: "ONP", monto: usaAFP ? 0 : redondear(total * Parametros.onp)),
            Concepto(nombre: "AFP fondo", monto: usaAFP ? redondear(total * tasas.fondo) : 0),
            Concepto(nombre: "AFP comisión", monto: usaAFP ? redondear(total * tasas.comision) : 0),
            Concepto(nombre: "AFP seguro", monto: usaAFP ? redondear(total * tasas.seguro) : 0),
            Concepto(nombre: "Adelantos", monto: datos.adelanto)
        ]
        return ResultadoBoleta(remuneraciones: remuneraciones, descuentos: descuentos,
                               aportaciones: [Concepto(nombre: "EsSalud (empleador)", monto: redondear(total * Parametros.essalud))])
    }
}
