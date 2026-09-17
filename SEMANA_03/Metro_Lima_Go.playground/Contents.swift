import Foundation

// METRO LIMA GO - Consola Swift
// Datos base del prototipo: septiembre de 2026.
// Próximos servicios, saldo y datos creados por administrador son SIMULADOS.

enum Linea: Equatable {
    case l1, l2, l4, met, admin(String)

    var nombre: String {
        switch self {
        case .l1: return "Línea 1"
        case .l2: return "Línea 2"
        case .l4: return "Ramal Línea 4"
        case .met: return "Metropolitano"
        case .admin(let nombre): return nombre
        }
    }

    var esAdministrativa: Bool {
        if case .admin = self { return true }
        return false
    }
}

enum Estado: String {
    case operativa = "Operativa"
    case construccion = "En construcción"
    case proyectada = "Proyectada"
}

enum TipoConexion: String {
    case intercambio = "Intercambio"
    case metropolitano = "Conexión con Metropolitano"
}

struct Conexion {
    let tipo: TipoConexion
    let destino: String
    let estado: Estado
    let detalle: String
}

struct Estacion {
    let codigo, nombre: String
    let linea: Linea
    let estado: Estado
    let ascensor: Bool?
    let accesible: Bool
    let anio: Int?
    var conexiones: [Conexion] = []
    var nota: String = ""
}

struct Destino {
    let nombre, estacion, detalle: String
}

struct LineaAdmin {
    let nombre: String
    var paraderos: [String]
    let estado: Estado
}

func norm(_ s: String) -> String {
    s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "es_PE"))
        .lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
}

func l2(_ s: String) -> String { "\(s) (L2)" }
func l4(_ s: String) -> String { "\(s) (L4)" }
func met(_ s: String) -> String { "\(s) (Metropolitano)" }
func adminKey(_ linea: String, _ estacion: String) -> String { "\(estacion) [\(linea)]" }
func siNo(_ b: Bool) -> String { b ? "Sí" : "No" }
func datoAscensor(_ b: Bool?) -> String { b.map { $0 ? "Sí" : "No" } ?? "No verificado" }
func enlaceID(_ a: String, _ b: String) -> String { [a, b].sorted().joined(separator: "||") }

let totalLineasMetro = 6
let lineasBase: [Linea] = [.l1, .l2, .l4, .met]

let referenciaMetL1: [String: (paradero: String, detalle: String)] = [
    "Cabitos": ("Benavides", "Referencia aproximada por el eje Benavides/Higuereta; requiere transporte complementario."),
    "Angamos": ("Angamos", "Referencia aproximada por la avenida Angamos; requiere transporte complementario."),
    "La Cultura": ("Javier Prado", "Referencia aproximada por el corredor Javier Prado; requiere transporte complementario."),
    "Grau": ("Central", "Integración prevista mediante la Vía Expresa Grau; todavía no es un intercambio directo operativo.")
]

let enlacesSuperficieL1Met = [
    ("Cabitos", met("Benavides")),
    ("Angamos", met("Angamos")),
    ("La Cultura", met("Javier Prado"))
]

let recomendacionClave: [String: String] = [
    l2("28 de Julio"): "Referencia temporal: Gamarra (Línea 1) mediante traslado peatonal propuesto; el intercambio definitivo L1-L2 será en 28 de Julio.",
    l2("Estación Central"): "Al culminar las obras, conecta directamente con Central del Metropolitano mediante una galería subterránea de ~180 m.",
    "Grau": "No es cruce directo. Como alternativa futura, se puede considerar la integración Central -> Metropolitano -> conexión hacia Grau."
]

var referenciasCercanas: [String: [String]] = [
    "Gamarra": ["Tienda Humboldt (referencia local de ejemplo)", "Emporio Comercial de Gamarra"],
    "La Cultura": ["Museo de la Nación"],
    met("Central"): ["Centro Cívico"],
    met("Estadio Nacional"): ["Estadio Nacional del Perú"],
    met("Ricardo Palma"): ["Parque Kennedy"],
    met("Canaval y Moreyra"): ["Centro financiero de San Isidro"]
]

var saldoTarjeta = 10.00
var enlacesAdmin: [(String, String)] = []
var enlacesBloqueados: Set<String> = []
var lineasAdmin: [String: LineaAdmin] = [:]
var estaciones: [String: Estacion] = [:]

func guardar(_ clave: String, _ e: Estacion) { estaciones[clave] = e }

func conectar(_ clave: String, _ c: Conexion) {
    guard var e = estaciones[clave] else { return }
    e.conexiones.append(c)
    estaciones[clave] = e
}

// MARK: - DATOS BASE

let nombresL1 = ["Villa El Salvador","Parque Industrial","Pumacahua","Villa María","María Auxiliadora","San Juan","Atocongo","Jorge Chávez","Ayacucho","Cabitos","Angamos","San Borja Sur","La Cultura","Arriola","Gamarra","Grau","El Ángel","Presbítero Maestro","Caja de Agua","Pirámide del Sol","Los Jardines","Los Postes","San Carlos","San Martín","Santa Rosa","Bayóvar"]
let sinAscensor: Set<String> = ["Pumacahua","Villa María","María Auxiliadora","San Borja Sur"]

for (i, n) in nombresL1.enumerated() {
    var nota = "Estación operativa de Línea 1."
    if sinAscensor.contains(n) { nota += " Usa salvaescaleras para accesibilidad." }
    if n == "Grau" { nota += " Grau NO conecta directamente con Línea 2; el intercambio L1-L2 corresponde a 28 de Julio." }
    guardar(n, Estacion(codigo: "L1-\(String(format: "%02d", i + 1))", nombre: n, linea: .l1,
        estado: .operativa, ascensor: !sinAscensor.contains(n), accesible: true, anio: nil, nota: nota))
}

guardar("28 de Julio (L1 futura)", Estacion(codigo: "L1-FUT-28J", nombre: "28 de Julio", linea: .l1,
    estado: .proyectada, ascensor: true, accesible: true, anio: nil,
    nota: "Futura estación de intercambio con Línea 2. No está operativa."))

let nombresL2 = ["Puerto del Callao","Buenos Aires","Juan Pablo II","Insurgentes","Carmen de la Legua","Óscar R. Benavides","San Marcos","Elio","La Alborada","Tingo María","Parque Murillo","Plaza Bolognesi","Estación Central","Manco Cápac","Cangallo","28 de Julio","Nicolás Ayllón","Circunvalación","San Juan de Dios","Evitamiento","Óvalo Santa Anita","Colectora Industrial","Hermilio Valdizán","Mercado Santa Anita","Vista Alegre","Prolongación Javier Prado","Municipalidad de Ate"]

for (i, n) in nombresL2.enumerated() {
    let num = i + 1
    let operativa = (20...24).contains(num)
    let etapa1B = (12...19).contains(num) || (25...27).contains(num)
    var nota = operativa
        ? "Etapa 1A habilitada. Horario habitual: 06:00-23:00; usa Tarjeta Interoperable de Transporte (TIT)."
        : etapa1B
            ? "Etapa 1B en construcción; operación prevista de forma referencial para 2029."
            : "Etapa 2 en construcción; operación prevista de forma referencial para 2030."
    if n == "28 de Julio" { nota += " Será el intercambio L2-L1; todavía no está operativo." }
    if n == "Estación Central" { nota += " Se conectará al Metropolitano mediante una galería subterránea." }
    if n == "Carmen de la Legua" { nota += " Será intercambio con el Ramal Línea 4." }
    guardar(l2(n), Estacion(codigo: "L2-E\(String(format: "%02d", num))", nombre: n, linea: .l2,
        estado: operativa ? .operativa : .construccion, ascensor: true, accesible: true,
        anio: operativa ? nil : (etapa1B ? 2029 : 2030), nota: nota))
}

let nombresL4 = ["Gambetta","Canta Callao","Bocanegra","Aeropuerto","El Olivar","Quilca","Morales Duárez","Carmen de la Legua"]
for (i, n) in nombresL4.enumerated() {
    guardar(l4(n), Estacion(codigo: "L4-R\(String(format: "%02d", i + 1))", nombre: n, linea: .l4,
        estado: .construccion, ascensor: true, accesible: true, anio: 2030,
        nota: "Estación del Ramal Línea 4 en construcción."))
}

let nombresMet = ["Jirón de la Unión","Central","Estadio Nacional","México","Canadá","Javier Prado","Canaval y Moreyra","Aramburú","Angamos","Ricardo Palma","Benavides","28 de Julio"]
for (i, n) in nombresMet.enumerated() {
    var nota = "Estación operativa del Metropolitano incluida como punto estratégico del prototipo."
    if n == "Central" { nota += " Su futura conexión directa con Línea 2 está en construcción." }
    if n == "Jirón de la Unión" { nota += " Útil para acceder al Centro Histórico de Lima." }
    if n == "Estadio Nacional" { nota += " Recomendada para llegar al Estadio Nacional del Perú." }
    if n == "Canaval y Moreyra" { nota += " Punto útil para el centro financiero de San Isidro." }
    if n == "Ricardo Palma" { nota += " Punto útil para Parque Kennedy y el centro de Miraflores." }
    guardar(met(n), Estacion(codigo: "MET-\(String(format: "%02d", i + 1))", nombre: n, linea: .met,
        estado: .operativa, ascensor: nil, accesible: true, anio: nil, nota: nota))
}

conectar(l2("28 de Julio"), Conexion(tipo: .intercambio, destino: "28 de Julio (L1 futura)", estado: .construccion, detalle: "Intercambio L2-L1 todavía no operativo."))
conectar("28 de Julio (L1 futura)", Conexion(tipo: .intercambio, destino: l2("28 de Julio"), estado: .construccion, detalle: "Intercambio L1-L2 todavía no operativo."))
conectar(l2("Estación Central"), Conexion(tipo: .metropolitano, destino: met("Central"), estado: .construccion, detalle: "Galería de conexión aún en construcción."))
conectar(l2("Carmen de la Legua"), Conexion(tipo: .intercambio, destino: l4("Carmen de la Legua"), estado: .construccion, detalle: "Futuro intercambio Línea 2 - Ramal Línea 4."))

let destinos: [String: Destino] = [
    "estadio nacional": Destino(nombre: "Estadio Nacional del Perú", estacion: met("Estadio Nacional"), detalle: "Usa el Metropolitano y baja en Estadio Nacional."),
    "miraflores": Destino(nombre: "Miraflores", estacion: met("Ricardo Palma"), detalle: "Ricardo Palma es una opción práctica para Parque Kennedy y el centro de Miraflores."),
    "parque kennedy": Destino(nombre: "Parque Kennedy", estacion: met("Ricardo Palma"), detalle: "Baja en Ricardo Palma y continúa a pie hacia Parque Kennedy."),
    "centro de lima": Destino(nombre: "Centro Histórico de Lima", estacion: met("Jirón de la Unión"), detalle: "Jirón de la Unión es útil para el Centro Histórico; para Centro Cívico conviene Central."),
    "centro historico": Destino(nombre: "Centro Histórico de Lima", estacion: met("Jirón de la Unión"), detalle: "Jirón de la Unión es útil para el Centro Histórico."),
    "centro civico": Destino(nombre: "Centro Cívico", estacion: met("Central"), detalle: "Central del Metropolitano es una referencia directa para la zona del Centro Cívico."),
    "san isidro": Destino(nombre: "Centro financiero de San Isidro", estacion: met("Canaval y Moreyra"), detalle: "Canaval y Moreyra es un punto útil para San Isidro."),
    "gamarra": Destino(nombre: "Emporio Comercial de Gamarra", estacion: "Gamarra", detalle: "Usa Línea 1 y baja en Gamarra."),
    "museo de la nacion": Destino(nombre: "Museo de la Nación / zona Cultura", estacion: "La Cultura", detalle: "Usa Línea 1 y baja en La Cultura."),
    "aeropuerto": Destino(nombre: "Aeropuerto Internacional Jorge Chávez", estacion: l4("Aeropuerto"), detalle: "La futura estación Aeropuerto del Ramal Línea 4 aún está en construcción.")
]

// MARK: - CONSULTAS GENERALES

func buscar(_ texto: String) -> [(String, Estacion)] {
    let q = norm(texto)
    return estaciones.filter {
        norm($0.key).contains(q) || norm($0.value.nombre).contains(q) ||
        norm($0.value.codigo).contains(q) || norm($0.value.linea.nombre).contains(q)
    }.sorted { $0.value.nombre < $1.value.nombre }
}

func resolver(_ texto: String) -> String? {
    let q = norm(texto)
    if let k = estaciones.keys.first(where: { norm($0) == q }) { return k }
    let exactas = estaciones.filter { norm($0.value.nombre) == q }
    if exactas.count == 1 { return exactas.first?.key }
    let r = buscar(texto)
    return r.count == 1 ? r[0].0 : nil
}

func elegir(_ r: [(String, Estacion)]) -> String? {
    if r.count == 1 { return r[0].0 }
    for (i, x) in r.enumerated() {
        print("\(i + 1). \(x.1.nombre) - \(x.1.linea.nombre) - \(x.1.estado.rawValue)")
    }
    guard let s = readLine(), let n = Int(s), (1...r.count).contains(n) else { return nil }
    return r[n - 1].0
}

func mostrar(_ clave: String) {
    guard let e = estaciones[clave] else { return }
    print("\n=== \(e.nombre) ===")
    print("Código: \(e.codigo) | Sistema: \(e.linea.nombre) | Estado: \(e.estado.rawValue)")
    print("Accesible: \(siNo(e.accesible)) | Ascensor: \(datoAscensor(e.ascensor))")
    if let a = e.anio { print("Operación prevista/referencial: \(a)") }
    print("Nota: \(e.nota)")
    if let refs = referenciasCercanas[clave] { print("Referencias cercanas: \(refs.joined(separator: " | "))") }
    if let r = recomendacionClave[clave] { print("Recomendación: \(r)") }

    if e.linea == .l1, let ref = referenciaMetL1[e.nombre] {
        print("Metropolitano de referencia: \(ref.paradero)")
        print("  \(ref.detalle)")
    } else if e.linea == .l2 {
        print(e.nombre == "Estación Central"
            ? "Metropolitano de referencia: Central | conexión directa futura, actualmente en construcción."
            : "Metropolitano: sin cruce directo en esta estación; Estación Central será el intercambio principal.")
    }

    if e.conexiones.isEmpty { print("Conexiones especiales: ninguna registrada.") }
    for c in e.conexiones {
        print("- \(c.tipo.rawValue) -> \(c.destino) [\(c.estado.rawValue)]\n  \(c.detalle)")
    }
}

func opcionBuscar() {
    print("Estación, línea o parte del nombre:")
    guard let t = readLine(), !norm(t).isEmpty else { print("Entrada inválida."); return }
    let r = buscar(t)
    guard !r.isEmpty else { print("No se encontraron resultados."); return }
    if let k = elegir(r) { mostrar(k) }
}

func estacionesDe(_ linea: Linea) -> [(String, Estacion)] {
    estaciones.filter { $0.value.linea == linea }.sorted { $0.value.codigo < $1.value.codigo }
}

func lineasDisponibles() -> [Linea] {
    let nuevas = lineasAdmin.values.sorted { norm($0.nombre) < norm($1.nombre) }.map { Linea.admin($0.nombre) }
    return lineasBase + nuevas
}

func listar(_ linea: Linea) {
    let lista = estacionesDe(linea)
    print("\n=== \(linea.nombre)\(linea.esAdministrativa ? " (SIMULADA)" : "") ===")
    print("Total registrado: \(lista.count)")
    for (_, e) in lista {
        print("\(e.codigo) | \(e.nombre) | \(e.estado.rawValue) | Ascensor: \(datoAscensor(e.ascensor))\(e.anio.map { " | prevista: \($0)" } ?? "")")
    }

    if linea == .l1 {
        print("Accesibilidad: Pumacahua, Villa María, María Auxiliadora y San Borja Sur usan salvaescaleras en lugar de ascensor.")
    } else if linea == .l2 {
        print("Resumen base: 27 estaciones | 5 operativas | resto en construcción.")
        print("Cruces: 28 de Julio -> Línea 1 | Estación Central -> Metropolitano | Carmen de la Legua -> Ramal L4")
    } else if linea == .met {
        print("Puntos útiles: Jirón de la Unión/Centro Histórico | Central/Centro Cívico | Estadio Nacional | Canaval y Moreyra/San Isidro | Ricardo Palma/Miraflores.")
    } else if case .admin(let nombre) = linea, let datos = lineasAdmin[norm(nombre)] {
        print("Estado simulado de la línea: \(datos.estado.rawValue)")
        let comunes = datos.paraderos.compactMap { p -> String? in
            let key = adminKey(nombre, p)
            guard let e = estaciones[key] else { return nil }
            let conexiones = e.conexiones.filter { $0.tipo == .intercambio }
            return conexiones.isEmpty ? nil : "\(p) (\(conexiones.count) conexión/es)"
        }
        print(comunes.isEmpty ? "Puntos en común con otras líneas: ninguno." : "Puntos en común: \(comunes.joined(separator: " | "))")
    }
}

func opcionLinea() {
    let lineas = lineasDisponibles()
    print("\n=== LÍNEAS DISPONIBLES ===")
    for (i, l) in lineas.enumerated() { print("\(i + 1). \(l.nombre)\(l.esAdministrativa ? " (SIMULADA)" : "")") }
    guard let x = readLine(), let n = Int(x), lineas.indices.contains(n - 1) else { print("Opción inválida."); return }
    listar(lineas[n - 1])
}

func cruces() {
    print("""
    \n=== CRUCES CLAVE ===
    1. 28 de Julio: Línea 1 <-> Línea 2 | EN CONSTRUCCIÓN
    2. Estación Central: Línea 2 <-> Metropolitano | EN CONSTRUCCIÓN
    3. Carmen de la Legua: Línea 2 <-> Ramal Línea 4 | EN CONSTRUCCIÓN
    4. Grau: NO es intercambio directo con Línea 2.
    """)

    for linea in lineasAdmin.values.sorted(by: { norm($0.nombre) < norm($1.nombre) }) {
        let crucesAdmin = linea.paraderos.compactMap { p -> String? in
            let key = adminKey(linea.nombre, p)
            guard let e = estaciones[key] else { return nil }
            let otras = e.conexiones.filter { $0.tipo == .intercambio }.map { $0.detalle }
            return otras.isEmpty ? nil : "\(p): \(otras.joined(separator: " / "))"
        }
        if !crucesAdmin.isEmpty {
            print("\n\(linea.nombre) (SIMULADA):")
            crucesAdmin.forEach { print("- \($0)") }
        }
    }
}

func buscarDestino(_ t: String) -> Destino? {
    let q = norm(t)
    return destinos[q] ?? destinos.first { q.contains($0.key) || $0.key.contains(q) }?.value
}

func opcionDestino() {
    print("Destino o estación:")
    guard let t = readLine(), !norm(t).isEmpty else { print("Entrada inválida."); return }
    if let d = buscarDestino(t) {
        print("Destino: \(d.nombre)\nEstación/paradero: \(d.estacion)\n\(d.detalle)")
        if let e = estaciones[d.estacion] { print("Estado: \(e.estado.rawValue)") }
        return
    }

    let r = buscar(t)
    guard !r.isEmpty, let k = elegir(r), let e = estaciones[k] else { print("Destino no registrado."); return }
    print("Destino seleccionado: \(e.nombre) | \(e.linea.nombre) | \(e.estado.rawValue)")
    if let refs = referenciasCercanas[k] { print("Referencias: \(refs.joined(separator: " | "))") }
}

// MARK: - GRAFO Y RUTAS

typealias Grafo = [String: [String]]

func unir(_ a: String, _ b: String, _ g: inout Grafo) {
    guard !enlacesBloqueados.contains(enlaceID(a, b)) else { return }
    if !g[a, default: []].contains(b) { g[a, default: []].append(b) }
    if !g[b, default: []].contains(a) { g[b, default: []].append(a) }
}

func crearGrafo(futuro: Bool) -> Grafo {
    var g: Grafo = [:]

    for i in 0..<nombresL1.count - 1 { unir(nombresL1[i], nombresL1[i + 1], &g) }
    for i in 0..<nombresMet.count - 1 { unir(met(nombresMet[i]), met(nombresMet[i + 1]), &g) }
    for (a, b) in enlacesSuperficieL1Met { unir(a, b, &g) }

    for i in 0..<nombresL2.count - 1 {
        let a = l2(nombresL2[i]), b = l2(nombresL2[i + 1])
        if futuro || (estaciones[a]?.estado == .operativa && estaciones[b]?.estado == .operativa) { unir(a, b, &g) }
    }

    for (a, b) in enlacesAdmin {
        let ambosOperativos = estaciones[a]?.estado == .operativa && estaciones[b]?.estado == .operativa
        if futuro || ambosOperativos { unir(a, b, &g) }
    }

    if futuro {
        unir("Gamarra", "28 de Julio (L1 futura)", &g)
        unir("28 de Julio (L1 futura)", "Grau", &g)
        unir("28 de Julio (L1 futura)", l2("28 de Julio"), &g)
        unir(l2("Estación Central"), met("Central"), &g)
        for i in 0..<nombresL4.count - 1 { unir(l4(nombresL4[i]), l4(nombresL4[i + 1]), &g) }
        unir(l2("Carmen de la Legua"), l4("Carmen de la Legua"), &g)
    }
    return g
}

func bfs(_ origen: String, _ destino: String, _ g: Grafo) -> [String]? {
    var cola = [origen], visitados: Set<String> = [origen], anterior: [String: String] = [:]
    while !cola.isEmpty {
        let actual = cola.removeFirst()
        if actual == destino { break }
        for v in g[actual, default: []] where !visitados.contains(v) {
            visitados.insert(v); anterior[v] = actual; cola.append(v)
        }
    }
    guard visitados.contains(destino) else { return nil }
    var camino = [destino], actual = destino
    while let p = anterior[actual] { camino.append(p); actual = p }
    return camino.reversed()
}

func claveRuta(_ t: String) -> String? { buscarDestino(t)?.estacion ?? resolver(t) }

func lineaPorTexto(_ texto: String) -> Linea? {
    let q = norm(texto)
    return lineasDisponibles().first { norm($0.nombre) == q }
}

func origenInteractivo(_ texto: String) -> String? {
    guard let linea = lineaPorTexto(texto) else { return claveRuta(texto) }
    let lista = estacionesDe(linea)
    print("¿En qué estación de \(linea.nombre) estás?")
    for (i, x) in lista.enumerated() { print("\(i + 1). \(x.1.nombre) - \(x.1.estado.rawValue)") }
    guard let x = readLine(), let n = Int(x), lista.indices.contains(n - 1) else { return nil }
    return lista[n - 1].0
}

func minutos(_ a: String, _ b: String) -> Int {
    guard let x = estaciones[a], let y = estaciones[b] else { return 4 }
    if x.linea != y.linea {
        if (x.linea == .l1 && y.linea == .met) || (x.linea == .met && y.linea == .l1) { return 15 }
        return 7
    }
    switch x.linea {
    case .l1: return 3
    case .l2: return 2
    case .l4: return 3
    case .met: return 4
    case .admin: return 3
    }
}

func imprimirRuta(_ c: [String], _ titulo: String) {
    var total = 0
    let tramos = max(c.count - 1, 0)
    let transbordos = zip(c, c.dropFirst()).filter { estaciones[$0.0]?.linea != estaciones[$0.1]?.linea }.count
    print("\n=== \(titulo) ===")
    print("Estaciones/paraderos por recorrer: \(tramos) | Conexiones/transbordos: \(transbordos)")

    for i in c.indices {
        guard let e = estaciones[c[i]] else { continue }
        print("\(i == 0 ? "INICIO" : i == c.count - 1 ? "DESTINO" : "↓") \(e.nombre) [\(e.linea.nombre)] - \(e.estado.rawValue)")
        if let refs = referenciasCercanas[c[i]], i == 0 { print("   Referencia actual: \(refs.joined(separator: " | "))") }
        if let r = recomendacionClave[c[i]] { print("   SUGERENCIA: \(r)") }

        if i < c.count - 1 {
            print("   Faltan \(c.count - i - 1) estación(es)/paradero(s) para llegar.")
            if let sig = estaciones[c[i + 1]] {
                total += minutos(c[i], c[i + 1])
                if e.linea != sig.linea {
                    if (e.linea == .l1 && sig.linea == .met) || (e.linea == .met && sig.linea == .l1) {
                        print("   CONEXIÓN POR SUPERFICIE hacia \(sig.nombre) del Metropolitano. No es intercambio directo; ~15 min.")
                    } else {
                        print("   TRANSBORDO: cambia de \(e.linea.nombre) a \(sig.linea.nombre) en \(sig.nombre).")
                    }
                }
            }
        }
    }
    print("Tiempo estimado: ~\(total) min")
    print(String(format: "Saldo simulado de tarjeta: S/ %.2f", saldoTarjeta))
    if c.contains(where: { estaciones[$0]?.estado != .operativa }) { print("ADVERTENCIA: ruta referencial con infraestructura no operativa.") }
}

func opcionRuta() {
    print("Origen (estación o nombre de línea, incluidas las creadas por administrador):")
    guard let o = readLine(), let origen = origenInteractivo(o) else { print("Origen no identificado."); return }
    print("Destino (lugar o estación, incluida una creada por administrador):")
    guard let d = readLine(), let destino = claveRuta(d) else { print("Destino no identificado."); return }
    if estaciones[origen]?.estado != .operativa { print("El origen no está operativo; se buscará una ruta futura/referencial.") }

    if let c = bfs(origen, destino, crearGrafo(futuro: false)) {
        imprimirRuta(c, "RUTA ACTUAL")
    } else if let c = bfs(origen, destino, crearGrafo(futuro: true)) {
        print("No existe ruta integrada con la red operativa registrada.")
        imprimirRuta(c, "RUTA FUTURA / REFERENCIAL")
    } else {
        print("No se encontró una ruta.")
    }
}

func opcionServicio() {
    print("Estación:")
    guard let t = readLine() else { return }
    let r = buscar(t)
    guard !r.isEmpty, let k = elegir(r), let e = estaciones[k] else { print("Estación no encontrada."); return }
    guard e.estado == .operativa else { print("\(e.nombre): \(e.estado.rawValue). Aún no tiene servicio operativo."); return }

    let frecuencia: Int, espera: Int, tipo: String
    switch e.linea {
    case .l1: frecuencia = Int.random(in: 5...12); espera = Int.random(in: 1...frecuencia); tipo = "tren"
    case .l2: frecuencia = Int.random(in: 5...9); espera = Int.random(in: 1...frecuencia); tipo = "tren"
    case .met: frecuencia = Int.random(in: 3...7); espera = Int.random(in: 1...frecuencia); tipo = "bus"
    case .l4: print("Ramal Línea 4 en construcción."); return
    case .admin: frecuencia = Int.random(in: 5...10); espera = Int.random(in: 1...frecuencia); tipo = "servicio"
    }
    print("Próximo \(tipo): ~\(espera) min | Siguiente: ~\(espera + frecuencia) min | Frecuencia estimada: ~\(frecuencia) min")
    print("SIMULACIÓN para el prototipo; no es una API oficial en tiempo real.")
}

// MARK: - TARJETA

func menuTarjeta() {
    while true {
        print("\n=== TARJETA DE TRANSPORTE (SIMULADA) ===")
        print("1. Ver saldo  2. Recargar  3. Simular pago  0. Volver")
        switch readLine() {
        case "1": print(String(format: "Saldo actual: S/ %.2f", saldoTarjeta))
        case "2":
            print("Monto a recargar:")
            guard let t = readLine(), let monto = Double(t.replacingOccurrences(of: ",", with: ".")), monto > 0 else { print("Monto inválido."); continue }
            saldoTarjeta += monto
            print(String(format: "Recarga exitosa. Nuevo saldo: S/ %.2f", saldoTarjeta))
        case "3":
            print("Monto del pasaje simulado:")
            guard let t = readLine(), let monto = Double(t.replacingOccurrences(of: ",", with: ".")), monto > 0 else { print("Monto inválido."); continue }
            if monto <= saldoTarjeta { saldoTarjeta -= monto; print(String(format: "Pago realizado. Saldo: S/ %.2f", saldoTarjeta)) }
            else { print("Saldo insuficiente.") }
        case "0": return
        default: print("Opción inválida.")
        }
    }
}

// MARK: - ADMINISTRADOR DINÁMICO

func seleccionarLineaAdmin() -> Linea? {
    let lineas = lineasDisponibles()
    print("Selecciona la línea/sistema:")
    for (i, l) in lineas.enumerated() { print("\(i + 1). \(l.nombre)\(l.esAdministrativa ? " (SIMULADA)" : "")") }
    guard let x = readLine(), let n = Int(x), lineas.indices.contains(n - 1) else { return nil }
    return lineas[n - 1]
}

func agregarEstacionAdmin() {
    guard let linea = seleccionarLineaAdmin() else { print("Sistema inválido."); return }
    let lista = estacionesDe(linea)
    guard lista.count >= 2 else { print("La línea necesita al menos dos estaciones existentes."); return }

    print("Selecciona la PRIMERA estación:")
    for (i, x) in lista.enumerated() { print("\(i + 1). \(x.1.nombre)") }
    guard let aT = readLine(), let ai = Int(aT), lista.indices.contains(ai - 1) else { print("Selección inválida."); return }
    let a = lista[ai - 1].0

    print("Selecciona la SEGUNDA estación (debe estar conectada directamente con la primera):")
    for (i, x) in lista.enumerated() { print("\(i + 1). \(x.1.nombre)") }
    guard let bT = readLine(), let bi = Int(bT), lista.indices.contains(bi - 1) else { print("Selección inválida."); return }
    let b = lista[bi - 1].0

    let grafo = crearGrafo(futuro: true)
    guard grafo[a, default: []].contains(b) else { print("Esas estaciones no están conectadas directamente; elige dos consecutivas."); return }

    print("Nombre de la nueva estación:")
    guard let nombre = readLine(), !norm(nombre).isEmpty else { print("Nombre inválido."); return }
    if estaciones.values.contains(where: { $0.linea == linea && norm($0.nombre) == norm(nombre) }) {
        print("Ya existe una estación con ese nombre en esa línea."); return
    }

    print("Estado: 1. Operativa (simulada)  2. Proyectada")
    let estado: Estado = readLine() == "1" ? .operativa : .proyectada
    print("¿Tiene ascensor? (s/n):")
    let ascensor = norm(readLine() ?? "") == "s"
    print("Referencia cercana opcional (Enter para omitir):")
    let referencia = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

    let clave: String
    if case .admin(let nombreLinea) = linea { clave = adminKey(nombreLinea, nombre) }
    else { clave = "\(nombre) (ADMIN \(linea.nombre))" }

    guardar(clave, Estacion(codigo: "ADM-\(estaciones.count + 1)", nombre: nombre, linea: linea,
        estado: estado, ascensor: ascensor, accesible: true, anio: nil,
        nota: "Estación agregada por administrador entre \(estaciones[a]?.nombre ?? a) y \(estaciones[b]?.nombre ?? b)."))

    if !referencia.isEmpty { referenciasCercanas[clave] = [referencia] }
    enlacesBloqueados.insert(enlaceID(a, b))
    enlacesAdmin.append((a, clave)); enlacesAdmin.append((clave, b))

    if case .admin(let nombreLinea) = linea, var datos = lineasAdmin[norm(nombreLinea)] {
        if let ia = datos.paraderos.firstIndex(where: { norm($0) == norm(estaciones[a]?.nombre ?? "") }),
           let ib = datos.paraderos.firstIndex(where: { norm($0) == norm(estaciones[b]?.nombre ?? "") }) {
            datos.paraderos.insert(nombre, at: min(ia, ib) + 1)
            lineasAdmin[norm(nombreLinea)] = datos
        }
    }

    print("Estación agregada. Ya aparece en búsqueda, listado, rutas, destinos y próximo servicio según su estado.")
}

func crearLineaAdmin() {
    print("Nombre de la nueva línea simulada (ej.: Línea 6):")
    guard let nombre = readLine(), !norm(nombre).isEmpty else { print("Nombre inválido."); return }
    guard lineasAdmin[norm(nombre)] == nil else { print("Ya existe una línea simulada con ese nombre."); return }

    print("Estado de la línea: 1. Operativa (simulada)  2. Proyectada")
    let estado: Estado = readLine() == "1" ? .operativa : .proyectada
    print("Ingresa sus estaciones/paraderos separados por coma:")
    guard let texto = readLine() else { return }
    let paraderos = texto.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    guard paraderos.count >= 2 else { print("Debes ingresar al menos 2 estaciones/paraderos."); return }
    guard Set(paraderos.map(norm)).count == paraderos.count else { print("No repitas estaciones dentro de la misma línea."); return }

    let linea = Linea.admin(nombre)
    var claves: [String] = []
    var comunes: [String] = []

    for (i, p) in paraderos.enumerated() {
        let clave = adminKey(nombre, p)
        let coincidencias = estaciones.filter { norm($0.value.nombre) == norm(p) }
        var nota = "Estación de \(nombre) creada por administrador."
        if !coincidencias.isEmpty { nota += " Comparte nombre/ubicación de referencia con otro punto de la red." }

        guardar(clave, Estacion(codigo: "\(norm(nombre).replacingOccurrences(of: " ", with: "").uppercased())-\(String(format: "%02d", i + 1))",
            nombre: p, linea: linea, estado: estado, ascensor: true, accesible: true, anio: nil, nota: nota))
        claves.append(clave)

        for (otraClave, otra) in coincidencias where otraClave != clave {
            enlacesAdmin.append((clave, otraClave))
            let detalle = "Punto en común con \(otra.linea.nombre) en \(otra.nombre)."
            conectar(clave, Conexion(tipo: .intercambio, destino: otraClave, estado: estado == .operativa && otra.estado == .operativa ? .operativa : .proyectada, detalle: detalle))
            conectar(otraClave, Conexion(tipo: .intercambio, destino: clave, estado: estado == .operativa && otra.estado == .operativa ? .operativa : .proyectada, detalle: "Conexión simulada con \(nombre)."))
            comunes.append("\(p) -> \(otra.linea.nombre)")
        }
    }

    for i in 0..<claves.count - 1 { enlacesAdmin.append((claves[i], claves[i + 1])) }
    lineasAdmin[norm(nombre)] = LineaAdmin(nombre: nombre, paraderos: paraderos, estado: estado)

    print("Línea simulada creada con \(paraderos.count) estaciones/paraderos.")
    print("Ya está integrada en búsqueda, listado por línea, cruces, destinos por estación, rutas y próximos servicios.")
    print(comunes.isEmpty ? "No se detectaron puntos en común con la red actual." : "Puntos en común: \(Set(comunes).sorted().joined(separator: " | "))")
}

func menuAdmin() {
    while true {
        print("\n=== MODO ADMINISTRADOR (SIMULACIÓN EN MEMORIA) ===")
        print("1. Agregar estación entre 2 existentes")
        print("2. Crear línea nueva simulada")
        print("3. Ver líneas creadas")
        print("0. Volver")
        switch readLine() {
        case "1": agregarEstacionAdmin()
        case "2": crearLineaAdmin()
        case "3":
            if lineasAdmin.isEmpty { print("No hay líneas nuevas.") }
            else { lineasAdmin.values.sorted { norm($0.nombre) < norm($1.nombre) }.forEach { print("- \($0.nombre) [\($0.estado.rawValue)]: \($0.paraderos.joined(separator: " -> "))") } }
        case "0": return
        default: print("Opción inválida.")
        }
    }
}

// MARK: - REQUERIMIENTOS Y MENÚ

let requisitos = [
    "RF-01 Buscar una estación por nombre y mostrar su información de conectividad.",
    "RF-02 Mostrar línea, estado, ascensor, accesibilidad y referencia al Metropolitano cuando corresponda.",
    "RF-03 Listar Línea 1, Línea 2, Metropolitano, Ramal L4 y líneas creadas por administrador.",
    "RF-04 Identificar las 27 estaciones base de Línea 2 y su estado.",
    "RF-05 Mostrar cruces y referencias de conexión, diferenciando intercambios directos y conexiones por superficie.",
    "RF-06 Recomendar estación/paradero para destinos conocidos y permitir seleccionar estaciones agregadas.",
    "RF-07 Calcular rutas actuales o futuras con BFS, tiempo estimado, transbordos y estaciones restantes.",
    "RF-08 Simular próximos servicios solo en estaciones operativas y validar entradas.",
    "RF-09 Reutilizar la lógica posteriormente en una app móvil.",
    "RF-10 Gestionar una tarjeta simulada con saldo, recarga y pago.",
    "RF-11 Permitir al administrador agregar estaciones o crear líneas completas en memoria.",
    "RF-12 Mostrar referencias cercanas al usuario.",
    "RF-13 Reflejar inmediatamente los datos creados por administrador en búsqueda, líneas, cruces, destinos, rutas y servicios."
]

func verRequisitos() {
    print("\n=== REQUERIMIENTOS FUNCIONALES ===")
    requisitos.forEach { print("- \($0)") }
}

func menu() {
    print("""
    \n================ METRO LIMA GO ================
    1. Buscar estación
    2. Ver estaciones por línea
    3. Ver cruces / conexiones
    4. Consultar destino
    5. Calcular ruta
    6. Próximo servicio (SIMULADO)
    7. Requerimientos funcionales
    8. Tarjeta de transporte (SIMULADA)
    9. Modo administrador
    0. Salir
    Red Básica del Metro de Lima: \(totalLineasMetro) líneas.
    Líneas simuladas creadas en esta ejecución: \(lineasAdmin.count)
    Opción:
    """)
}

var activo = true
while activo {
    menu()
    switch readLine() {
    case "1": opcionBuscar()
    case "2": opcionLinea()
    case "3": cruces()
    case "4": opcionDestino()
    case "5": opcionRuta()
    case "6": opcionServicio()
    case "7": verRequisitos()
    case "8": menuTarjeta()
    case "9": menuAdmin()
    case "0": activo = false; print("Programa finalizado.")
    default: print("Opción inválida.")
    }
}
