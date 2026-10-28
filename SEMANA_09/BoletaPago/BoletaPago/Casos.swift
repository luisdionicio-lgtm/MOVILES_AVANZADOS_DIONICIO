import Foundation

struct CasoBoleta {
    let nombre: String
    let datos: DatosMes
    var profesional = "Trabajador de ejemplo"
    var oferta = "Caso académico · Octubre 2026"
}

enum Casos {
    static let todos = [
        CasoBoleta(nombre: "Caso 1 · ONP completo", datos: DatosMes(sueldo: 2500, dias: 30, hijos: false, sistema: .onp, afp: "AFP Guía", horas25: 0, horas35: 0, adelanto: 0)),
        CasoBoleta(nombre: "Caso 2 · 27 días", datos: DatosMes(sueldo: 1800, dias: 27, hijos: true, sistema: .onp, afp: "AFP Guía", horas25: 0, horas35: 0, adelanto: 0)),
        CasoBoleta(nombre: "Caso 3 · AFP Guía y extras", datos: DatosMes(sueldo: 3000, dias: 30, hijos: true, sistema: .afp, afp: "AFP Guía", horas25: 4, horas35: 4, adelanto: 200)),
        CasoBoleta(nombre: "Caso 4 · Evaluación", datos: DatosMes(sueldo: 4200, dias: 24, hijos: true, sistema: .afp, afp: "AFP Guía", horas25: 2, horas35: 2, adelanto: 100)),
        CasoBoleta(nombre: "Propio 1 · ONP S/ 1600", datos: DatosMes(sueldo: 1600, dias: 30, hijos: false, sistema: .onp, afp: "AFP Guía", horas25: 0, horas35: 0, adelanto: 0), profesional: "Desarrollador de Software", oferta: "TALENTE PERÚ MÁS · Octubre 2026"),
        CasoBoleta(nombre: "Propio 2 · Habitat S/ 4000", datos: DatosMes(sueldo: 4000, dias: 30, hijos: false, sistema: .afp, afp: "Habitat", horas25: 0, horas35: 0, adelanto: 0), profesional: "Desarrollador Backend .NET", oferta: "Seidor Consulting Perú · Octubre 2026"),
        CasoBoleta(nombre: "Boleta Excel · Habitat y 26 días", datos: DatosMes(sueldo: 4000, dias: 26, hijos: true, sistema: .afp, afp: "Habitat", horas25: 2, horas35: 3, adelanto: 150), profesional: "Edgar Rodolfo Quispe · Ingeniero de desarrollo de software", oferta: "Seidor Consulting Perú · Octubre 2026")
    ]
}
