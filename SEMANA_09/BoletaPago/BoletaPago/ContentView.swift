import SwiftUI
import UIKit

struct ContentView: View {
    @State private var sueldo = "4000"
    @State private var dias = "26"
    @State private var hijos = true
    @State private var sistema = Sistema.afp
    @State private var afp = "Habitat"
    @State private var horas25 = "2"
    @State private var horas35 = "3"
    @State private var adelanto = "150"
    @State private var caso = 6
    @State private var profesional = Casos.todos[6].profesional
    @State private var oferta = Casos.todos[6].oferta
    @State private var resultado: ResultadoBoleta?
    @State private var mensaje = ""
    private let azul = Color(red: 0.10, green: 0.20, blue: 0.36)
    private var entradas: [String] {
        [sueldo, dias, String(hijos), sistema.rawValue, afp, horas25, horas35, adelanto, profesional, oferta]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("Boleta de pago").font(.largeTitle.bold()).foregroundStyle(azul)
                    Text("Del sueldo al neto").font(.title3).foregroundStyle(.secondary)
                    Text("Octubre 2026 · cálculo educativo").font(.caption).foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 14) {
                    Text("Datos del mes").font(.title2.bold())
                    Picker("Cargar caso de prueba", selection: $caso) {
                        ForEach(Casos.todos.indices, id: \.self) { i in
                            Text(Casos.todos[i].nombre).tag(i)
                        }
                    }.pickerStyle(.menu).accessibilityIdentifier("selectorCaso")
                    Text("Simulación alineada a Boleta_Pago_Grupo_B.xlsx. No representa una boleta personal real.")
                        .font(.caption).foregroundStyle(.secondary)
                    campo("Sueldo básico (S/)", texto: $sueldo, id: "sueldo")
                    campo("Días laborados (1–30)", texto: $dias, id: "dias", entero: true)
                    Text("¿Tiene hijos?").font(.subheadline.bold())
                    Picker("¿Tiene hijos?", selection: $hijos) {
                        Text("No").tag(false)
                        Text("Sí").tag(true)
                    }.pickerStyle(.segmented)
                    Text("Sistema de pensiones").font(.subheadline.bold())
                    Picker("Sistema de pensiones", selection: $sistema) {
                        Text("ONP").tag(Sistema.onp)
                        Text("AFP").tag(Sistema.afp)
                    }.pickerStyle(.segmented)
                    if sistema == .afp {
                        Picker("AFP (comisión por flujo)", selection: $afp) {
                            ForEach(Parametros.ordenAFP, id: \.self) { Text($0).tag($0) }
                        }.pickerStyle(.menu)
                        Text(afp == "AFP Guía" ? "AFP Guía: fondo 10%, comisión 1.60%, seguro 1.35% (académica)." :
                            "\(afp): fondo 10%, comisión \(comisionAFP), seguro 1.37%. Comisión por flujo del Excel.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    HStack(alignment: .top, spacing: 12) {
                        campo("Horas al 25%", texto: $horas25, id: "horas25")
                        campo("Horas al 35%", texto: $horas35, id: "horas35")
                    }
                    campo("Adelanto (S/)", texto: $adelanto, id: "adelanto")
                    Text("Datos del trabajador de referencia").font(.headline)
                    TextField("Profesional y puesto", text: $profesional, axis: .vertical)
                        .textFieldStyle(.roundedBorder).accessibilityIdentifier("profesional")
                    TextField("Oferta base y periodo", text: $oferta, axis: .vertical)
                        .textFieldStyle(.roundedBorder).accessibilityIdentifier("oferta")
                    Text("Sin separadores de miles. Usa punto o coma decimal. RMV: S/ 1,230.00.").font(.caption).foregroundStyle(.secondary)
                    Button(action: calcular) {
                        Text("Calcular boleta").font(.headline).frame(maxWidth: .infinity).padding(.vertical, 8)
                    }.buttonStyle(.borderedProminent).tint(azul).accessibilityIdentifier("calcular")
                    if !mensaje.isEmpty {
                        Text(mensaje).font(.subheadline).foregroundStyle(.red).accessibilityIdentifier("errorValidacion")
                    }
                }.padding(20).background(.white).clipShape(RoundedRectangle(cornerRadius: 18))

                if let resultado {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NETO A PAGAR").font(.caption.bold())
                        Text(soles(resultado.neto)).font(.largeTitle.bold()).accessibilityIdentifier("neto")
                        Text(profesional).font(.caption)
                        Text(oferta).font(.caption)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(20)
                        .foregroundStyle(.white).background(azul).clipShape(RoundedRectangle(cornerRadius: 18))
                    bloque("Remuneraciones", conceptos: resultado.remuneraciones, total: resultado.totalRemuneraciones)
                    bloque("Retenciones y descuentos", conceptos: resultado.descuentos, total: resultado.totalDescuentos)
                    bloque("Aportaciones del empleador", conceptos: resultado.aportaciones, total: nil)
                    fila("Costo del empleador", resultado.costoEmpleador).font(.headline)
                    Text("EsSalud lo paga el empleador: no reduce tu neto. Los conceptos que no aplican se muestran con 0.00.")
                        .font(.caption).foregroundStyle(.secondary)
                    Text("No incluye renta de quinta categoría, gratificaciones, CTS ni otras obligaciones. Sigue las convenciones simplificadas de la actividad.")
                        .font(.caption).foregroundStyle(.secondary)
                } else {
                    Text("Revisa los datos y pulsa Calcular para ver tu boleta.").font(.subheadline).foregroundStyle(.secondary)
                }
                Text("Fuentes y fórmulas detalladas en el Excel de la actividad. Consulta: " + Parametros.consulta)
                    .font(.caption).foregroundStyle(.secondary)
            }.padding(20).frame(maxWidth: 650)
                .frame(maxWidth: .infinity)
        }.background(Color(red: 0.94, green: 0.96, blue: 0.98))
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: caso) { nuevo in cargar(nuevo) }
            .onChange(of: entradas) { _ in resultado = nil; mensaje = "" }
    }

    private var comisionAFP: String {
        switch afp {
        case "Habitat": return "1.47%"
        case "Integra": return "1.55%"
        case "Profuturo": return "1.69%"
        default: return "1.60%"
        }
    }

    private func campo(_ titulo: String, texto: Binding<String>, id: String, entero: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo).font(.subheadline.bold())
            TextField(titulo, text: texto).textFieldStyle(.roundedBorder)
                .keyboardType(entero ? .numberPad : .decimalPad)
                .accessibilityIdentifier(id)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }

    private func fila(_ titulo: String, _ valor: Decimal) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(titulo).frame(maxWidth: .infinity, alignment: .leading)
            Text(soles(valor)).monospacedDigit().multilineTextAlignment(.trailing)
        }
    }

    private func bloque(_ titulo: String, conceptos: [Concepto], total: Decimal?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(titulo).font(.title3.bold()).foregroundStyle(azul)
            ForEach(conceptos.indices, id: \.self) { i in
                fila(conceptos[i].nombre, conceptos[i].monto).font(.subheadline)
            }
            if let total { fila("Total", total).font(.headline) }
        }.padding(20).background(.white).clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func cargar(_ indice: Int) {
        guard Casos.todos.indices.contains(indice) else { return }
        let datos = Casos.todos[indice].datos
        profesional = Casos.todos[indice].profesional
        oferta = Casos.todos[indice].oferta
        sueldo = NSDecimalNumber(decimal: datos.sueldo).stringValue
        dias = String(datos.dias)
        hijos = datos.hijos
        sistema = datos.sistema
        afp = datos.afp
        horas25 = NSDecimalNumber(decimal: datos.horas25).stringValue
        horas35 = NSDecimalNumber(decimal: datos.horas35).stringValue
        adelanto = NSDecimalNumber(decimal: datos.adelanto).stringValue
        resultado = nil
        mensaje = ""
    }

    private func calcular() {
        resultado = nil
        mensaje = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        do {
            guard let diasNumero = Int(dias.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                throw ErrorBoleta.dato("Días laborados: escribe un número entero entre 1 y 30.")
            }
            let datos = DatosMes(
                sueldo: try Entrada.decimal(sueldo, nombre: "Sueldo básico"),
                dias: diasNumero, hijos: hijos, sistema: sistema, afp: afp,
                horas25: try Entrada.decimal(horas25, nombre: "Horas al 25%"),
                horas35: try Entrada.decimal(horas35, nombre: "Horas al 35%"),
                adelanto: try Entrada.decimal(adelanto, nombre: "Adelanto"))
            resultado = try Boleta().calcular(datos)
        } catch { mensaje = error.localizedDescription }
    }
}
#Preview {
    ContentView()
}
