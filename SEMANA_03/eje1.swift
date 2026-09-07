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
