import Foundation

// METRO LIMA GO - Consola Swift
// Próximos servicios: simulados para fines académicos.

enum Linea: String {
    case l1 = "Línea 1"
    case l2 = "Línea 2"
    case l4 = "Ramal Línea 4"
    case metropolitano = "Metropolitano"
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
    let codigo: String
    let nombre: String
    let linea: Linea
    let estado: Estado
    let ascensor: Bool?
    let accesible: Bool
    let anio: Int?
    var conexiones: [Conexion] = []
    var nota: String = ""
}

struct Destino {
    let nombre: String
    let estacion: String
    let detalle: String
}

func normalizar(_ texto: String) -> String {
    texto.folding(
        options: [.diacriticInsensitive, .caseInsensitive],
        locale: Locale(identifier: "es_PE")
    )
    .lowercased()
    .trimmingCharacters(in: .whitespacesAndNewlines)
}

func claveL2(_ nombre: String) -> String { "\(nombre) (L2)" }
func claveL4(_ nombre: String) -> String { "\(nombre) (L4)" }
func claveMet(_ nombre: String) -> String { "\(nombre) (Metropolitano)" }

var estaciones: [String: Estacion] = [:]

func guardar(_ clave: String, _ estacion: Estacion) {
    estaciones[clave] = estacion
}

func conectar(_ clave: String, _ conexion: Conexion) {
    guard var estacion = estaciones[clave] else { return }
    estacion.conexiones.append(conexion)
    estaciones[clave] = estacion
}

let nombresL1 = [
    "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
    "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho",
    "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra",
    "Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua", "Pirámide del Sol",
    "Los Jardines", "Los Postes", "San Carlos", "San Martín", "Santa Rosa", "Bayóvar"
]

let estacionesSinAscensor: Set<String> = [
    "Pumacahua", "Villa María", "María Auxiliadora", "San Borja Sur"
]

for (indice, nombre) in nombresL1.enumerated() {
    let tieneAscensor = !estacionesSinAscensor.contains(nombre)
    guardar(nombre, Estacion(
        codigo: "L1-\(String(format: "%02d", indice + 1))",
        nombre: nombre,
        linea: .l1,
        estado: .operativa,
        ascensor: tieneAscensor,
        accesible: true,
        anio: nil,
        nota: tieneAscensor
            ? "Estación operativa de Línea 1."
            : "Estación accesible mediante salvaescaleras."
    ))
}

guardar("28 de Julio (L1 futura)", Estacion(
    codigo: "L1-FUT-28J",
    nombre: "28 de Julio",
    linea: .l1,
    estado: .proyectada,
    ascensor: true,
    accesible: true,
    anio: nil,
    nota: "Futura estación de intercambio con Línea 2."
))

let nombresL2 = [
    "Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes",
    "Carmen de la Legua", "Óscar R. Benavides", "San Marcos", "Elio",
    "La Alborada", "Tingo María", "Parque Murillo", "Plaza Bolognesi",
    "Estación Central", "Manco Cápac", "Cangallo", "28 de Julio",
    "Nicolás Ayllón", "Circunvalación", "San Juan de Dios", "Evitamiento",
    "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán",
    "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado",
    "Municipalidad de Ate"
]

for (indice, nombre) in nombresL2.enumerated() {
    let numero = indice + 1
    let operativa = (20...24).contains(numero)
    let etapa1B = (12...19).contains(numero) || (25...27).contains(numero)
    guardar(claveL2(nombre), Estacion(
        codigo: "L2-E\(String(format: "%02d", numero))",
        nombre: nombre,
        linea: .l2,
        estado: operativa ? .operativa : .construccion,
        ascensor: true,
        accesible: true,
        anio: operativa ? nil : (etapa1B ? 2029 : 2030),
        nota: operativa ? "Etapa 1A habilitada." : "Estación en construcción."
    ))
}

let nombresL4 = [
    "Gambetta", "Canta Callao", "Bocanegra", "Aeropuerto", "El Olivar",
    "Quilca", "Morales Duárez", "Carmen de la Legua"
]

for (indice, nombre) in nombresL4.enumerated() {
    guardar(claveL4(nombre), Estacion(
        codigo: "L4-R\(String(format: "%02d", indice + 1))",
        nombre: nombre, linea: .l4, estado: .construccion,
        ascensor: true, accesible: true, anio: 2030,
        nota: "Ramal Línea 4 en construcción."
    ))
}

let nombresMetropolitano = [
    "Jirón de la Unión", "Central", "Estadio Nacional", "México", "Canadá",
    "Javier Prado", "Canaval y Moreyra", "Aramburú", "Angamos",
    "Ricardo Palma", "Benavides", "28 de Julio"
]

for (indice, nombre) in nombresMetropolitano.enumerated() {
    guardar(claveMet(nombre), Estacion(
        codigo: "MET-\(String(format: "%02d", indice + 1))",
        nombre: nombre, linea: .metropolitano, estado: .operativa,
        ascensor: nil, accesible: true, anio: nil,
        nota: "Paradero estratégico del Metropolitano."
    ))
}

conectar(claveL2("28 de Julio"), Conexion(
    tipo: .intercambio, destino: "28 de Julio (L1 futura)", estado: .construccion,
    detalle: "Intercambio L2-L1 todavía no operativo."
))
conectar("28 de Julio (L1 futura)", Conexion(
    tipo: .intercambio, destino: claveL2("28 de Julio"), estado: .construccion,
    detalle: "Intercambio L1-L2 todavía no operativo."
))
conectar(claveL2("Estación Central"), Conexion(
    tipo: .metropolitano, destino: claveMet("Central"), estado: .construccion,
    detalle: "Galería de conexión aún en construcción."
))
conectar(claveL2("Carmen de la Legua"), Conexion(
    tipo: .intercambio, destino: claveL4("Carmen de la Legua"), estado: .construccion,
    detalle: "Futuro intercambio Línea 2 - Ramal Línea 4."
))

func textoSiNo(_ valor: Bool) -> String { valor ? "Sí" : "No" }

func textoAscensor(_ valor: Bool?) -> String {
    valor.map { $0 ? "Sí" : "No" } ?? "No verificado"
}

func buscar(_ texto: String) -> [(String, Estacion)] {
    let consulta = normalizar(texto)
    return estaciones.filter {
        normalizar($0.key).contains(consulta)
            || normalizar($0.value.nombre).contains(consulta)
            || normalizar($0.value.codigo).contains(consulta)
    }
    .sorted { $0.value.nombre < $1.value.nombre }
}

func resolver(_ texto: String) -> String? {
    let consulta = normalizar(texto)
    if let clave = estaciones.keys.first(where: { normalizar($0) == consulta }) {
        return clave
    }
    let coincidencias = buscar(texto)
    return coincidencias.count == 1 ? coincidencias[0].0 : nil
}

func elegir(_ resultados: [(String, Estacion)]) -> String? {
    if resultados.count == 1 { return resultados[0].0 }
    for (indice, resultado) in resultados.enumerated() {
        print("\(indice + 1). \(resultado.1.nombre) - \(resultado.1.linea.rawValue) - \(resultado.1.estado.rawValue)")
    }
    guard let entrada = readLine(), let opcion = Int(entrada),
          resultados.indices.contains(opcion - 1) else { return nil }
    return resultados[opcion - 1].0
}

func mostrar(_ clave: String) {
    guard let estacion = estaciones[clave] else { return }
    print("\n=== \(estacion.nombre) ===")
    print("Código: \(estacion.codigo) | Sistema: \(estacion.linea.rawValue) | Estado: \(estacion.estado.rawValue)")
    print("Accesible: \(textoSiNo(estacion.accesible)) | Ascensor: \(textoAscensor(estacion.ascensor))")
    if let anio = estacion.anio { print("Operación prevista/referencial: \(anio)") }
    print("Nota: \(estacion.nota)")
    if estacion.conexiones.isEmpty {
        print("Conexiones especiales: ninguna registrada.")
    }
    for conexion in estacion.conexiones {
        print("- \(conexion.tipo.rawValue) -> \(conexion.destino) [\(conexion.estado.rawValue)]")
        print("  \(conexion.detalle)")
    }
}

func opcionBuscar() {
    print("Estación o parte del nombre:")
    guard let texto = readLine(), !normalizar(texto).isEmpty else {
        print("Entrada inválida.")
        return
    }
    let resultados = buscar(texto)
    guard !resultados.isEmpty else {
        print("No se encontraron resultados.")
        return
    }
    if let clave = elegir(resultados) { mostrar(clave) }
}

func listar(_ linea: Linea) {
    let lista = estaciones.values.filter { $0.linea == linea }.sorted { $0.codigo < $1.codigo }
    print("\n=== \(linea.rawValue) ===")
    for estacion in lista {
        print("\(estacion.codigo) | \(estacion.nombre) | \(estacion.estado.rawValue) | Ascensor: \(textoAscensor(estacion.ascensor))")
    }
}

func opcionLinea() {
    print("1. Línea 1  2. Línea 2  3. Ramal L4  4. Metropolitano")
    switch readLine() {
    case "1": listar(.l1)
    case "2": listar(.l2)
    case "3": listar(.l4)
    case "4": listar(.metropolitano)
    default: print("Opción inválida.")
    }
}

func mostrarCruces() {
    print("""
    \n=== CRUCES CLAVE ===
    1. 28 de Julio: Línea 1 <-> Línea 2 | EN CONSTRUCCIÓN
    2. Estación Central: Línea 2 <-> Metropolitano | EN CONSTRUCCIÓN
    3. Carmen de la Legua: Línea 2 <-> Ramal Línea 4 | EN CONSTRUCCIÓN
    4. Grau: no es un intercambio directo con Línea 2.
    """)
}

let destinos: [String: Destino] = [
    "estadio nacional": Destino(nombre: "Estadio Nacional del Perú", estacion: claveMet("Estadio Nacional"), detalle: "Usa el Metropolitano y baja en Estadio Nacional."),
    "miraflores": Destino(nombre: "Miraflores", estacion: claveMet("Ricardo Palma"), detalle: "Ricardo Palma es una opción práctica para Parque Kennedy y el centro de Miraflores."),
    "parque kennedy": Destino(nombre: "Parque Kennedy", estacion: claveMet("Ricardo Palma"), detalle: "Baja en Ricardo Palma y continúa a pie."),
    "centro de lima": Destino(nombre: "Centro Histórico de Lima", estacion: claveMet("Jirón de la Unión"), detalle: "Jirón de la Unión permite acceder al Centro Histórico."),
    "centro historico": Destino(nombre: "Centro Histórico de Lima", estacion: claveMet("Jirón de la Unión"), detalle: "Jirón de la Unión permite acceder al Centro Histórico."),
    "centro civico": Destino(nombre: "Centro Cívico", estacion: claveMet("Central"), detalle: "Central es la opción directa para el Centro Cívico."),
    "san isidro": Destino(nombre: "Centro financiero de San Isidro", estacion: claveMet("Canaval y Moreyra"), detalle: "Canaval y Moreyra es un punto útil para el centro financiero."),
    "gamarra": Destino(nombre: "Emporio Comercial de Gamarra", estacion: "Gamarra", detalle: "Usa Línea 1 y baja en Gamarra."),
    "aeropuerto": Destino(nombre: "Aeropuerto Internacional Jorge Chávez", estacion: claveL4("Aeropuerto"), detalle: "La futura estación Aeropuerto aún está en construcción.")
]

func buscarDestino(_ texto: String) -> Destino? {
    let consulta = normalizar(texto)
    return destinos[consulta]
        ?? destinos.first { consulta.contains($0.key) || $0.key.contains(consulta) }?.value
}

func opcionDestino() {
    print("Destino (Estadio Nacional / Miraflores / Centro de Lima / San Isidro / Gamarra / Aeropuerto):")
    guard let texto = readLine(), let destino = buscarDestino(texto) else {
        print("Destino no registrado.")
        return
    }
    print("Destino: \(destino.nombre)")
    print("Estación/paradero: \(destino.estacion)")
    print(destino.detalle)
    if let estacion = estaciones[destino.estacion] {
        print("Estado: \(estacion.estado.rawValue)")
        if estacion.estado != .operativa {
            print("ADVERTENCIA: infraestructura aún no operativa.")
        }
    }
}
