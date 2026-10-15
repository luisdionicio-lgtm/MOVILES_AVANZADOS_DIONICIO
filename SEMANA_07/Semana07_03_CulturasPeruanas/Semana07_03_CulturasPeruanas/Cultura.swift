import UIKit

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String

    // Sugerencias de lectura, no subdivisiones ni una genealogía cultural.
    var relacionadas: [Cultura] {
        let nombres: [String]
        switch nombre {
        case "Inca": nombres = ["Wari", "Tiwanaku"]
        case "Nazca": nombres = ["Chincha", "Lima"]
        case "Chavín": nombres = ["Cupisnique", "Moche"]
        case "Paracas": nombres = ["Chimú", "Chancay"]
        default: return []
        }
        return nombres.compactMap { nombre in
            (Self.ejemplos + Self.adicionales).first { $0.nombre == nombre }
        }
    }

    static let adicionales = [
        Cultura(nombre: "Wari", region: "Ayacucho y Andes centrales",
                descripcion: "Wari fue una sociedad andina anterior a los incas. Su arte destacó por las cerámicas decoradas y los textiles. Esta botella de cerámica presenta asas con figuras de monos.",
                imagen: "wari"),
        Cultura(nombre: "Chimú", region: "Costa norte del Perú",
                descripcion: "La cultura Chimú destacó por el trabajo de los metales y su producción artística. El tumi de la imagen es un cuchillo ceremonial de cobre, ejemplo del conocimiento de sus artesanos.",
                imagen: "chimu"),
        Cultura(nombre: "Cupisnique", region: "Costa norte del Perú",
                descripcion: "Cupisnique se desarrolló durante el periodo Formativo. Sus artesanos elaboraron cerámicas oscuras con decoraciones incisas y asas de estribo. Muchos objetos tenían un uso ceremonial.",
                imagen: "cupisnique"),
        Cultura(nombre: "Moche", region: "Costa norte del Perú",
                descripcion: "Moche destacó por sus cerámicas escultóricas. Sus huacos retrato representan rostros humanos con gran detalle. La imagen muestra una vasija que permite apreciar esa habilidad artística.",
                imagen: "moche"),
        Cultura(nombre: "Tiwanaku", region: "Altiplano andino, Perú y Bolivia",
                descripcion: "Tiwanaku fue una sociedad del altiplano vinculada al entorno del lago Titicaca. Su centro monumental se encuentra en Bolivia. La Puerta del Sol muestra su trabajo en piedra y sus representaciones religiosas.",
                imagen: "tiwanaku"),
        Cultura(nombre: "Chincha", region: "Valle de Chincha, Ica",
                descripcion: "La sociedad Chincha se desarrolló en la costa sur del Perú. La Centinela fue uno de sus principales centros, con grandes construcciones de adobe. Sus restos permiten conocer la arquitectura de esta sociedad.",
                imagen: "chincha"),
        Cultura(nombre: "Lima", region: "Costa central del Perú",
                descripcion: "La cultura Lima construyó importantes centros ceremoniales de adobe. Huaca Pucllana, ubicada en Miraflores, es uno de sus testimonios. Sus plataformas muestran cómo se organizaban estos espacios monumentales.",
                imagen: "lima"),
        Cultura(nombre: "Chancay", region: "Costa central del Perú",
                descripcion: "Chancay destacó por sus tejidos y objetos textiles. La figura de la imagen está elaborada con tela y representa parte de esa tradición artesanal. Su producción muestra el cuidado en los materiales y las formas.",
                imagen: "chancay")
    ]

    static let ejemplos = [
        Cultura(
            nombre: "Inca",
            region: "Cusco, sierra sur del Perú",
            descripcion: "La cultura inca dejó un importante legado arquitectónico en los Andes. Machu Picchu es uno de sus sitios más representativos: sus muros de piedra, terrazas y construcciones se integran al paisaje montañoso.",
            imagen: "inca"
        ),
        Cultura(
            nombre: "Nazca",
            region: "Ica, costa sur del Perú",
            descripcion: "La cultura Nazca es conocida por los geoglifos trazados en el desierto. Entre sus figuras se encuentran animales, plantas y formas geométricas. El colibrí es una de las imágenes más reconocidas de este patrimonio.",
            imagen: "nazca"
        ),
        Cultura(
            nombre: "Chavín",
            region: "Áncash, sierra norte del Perú",
            descripcion: "Chavín de Huántar fue un importante centro ceremonial de los Andes. Su arquitectura y sus esculturas de piedra reflejan una tradición religiosa de gran influencia. Las cabezas clavas son una de sus expresiones más representativas.",
            imagen: "chavin"
        ),
        Cultura(
            nombre: "Paracas",
            region: "Ica, costa sur del Perú",
            descripcion: "La cultura Paracas destacó por la calidad de sus textiles, elaborados con algodón y fibras de camélidos. Sus tejidos presentan figuras y colores que expresan su tradición artística. La península de Paracas, en Ica, conserva importantes testimonios de esta cultura.",
            imagen: "paracas"
        )
    ]
}
