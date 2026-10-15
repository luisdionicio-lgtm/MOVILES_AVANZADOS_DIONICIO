import UIKit

class DetalleCulturaViewController: UIViewController {
    var cultura: Cultura?
    var mostrarRelacionadas = true

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var relacionadasLabel: UILabel!
    @IBOutlet weak var principalButton: UIButton!
    @IBOutlet weak var primeraRelacionadaButton: UIButton!
    @IBOutlet weak var segundaRelacionadaButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cultura = cultura else { return }
        title = cultura.nombre
        regionLabel.text = "Región: " + cultura.region
        descripcionLabel.text = cultura.descripcion
        imagenView.image = UIImage(named: cultura.imagen)
        imagenView.isAccessibilityElement = true
        imagenView.accessibilityLabel = "Imagen representativa de la cultura " + cultura.nombre
        nombreLabel.text = mostrarRelacionadas ? "Elige una cultura" : "Cultura " + cultura.nombre
        regionLabel.isHidden = mostrarRelacionadas
        descripcionLabel.isHidden = mostrarRelacionadas
        imagenView.isHidden = mostrarRelacionadas
        relacionadasLabel.isHidden = true
        let opciones = mostrarRelacionadas ? [cultura] + cultura.relacionadas : []
        for (indice, boton) in [principalButton, primeraRelacionadaButton, segundaRelacionadaButton].enumerated() {
            boton?.isHidden = indice >= opciones.count
            if indice < opciones.count {
                let opcion = opciones[indice]
                boton?.setTitle(opcion.nombre + " ›", for: .normal)
                var tarjeta = UIButton.Configuration.plain()
                tarjeta.title = opcion.nombre + " ›"
                tarjeta.image = UIImage(named: opcion.imagen)?.preparingThumbnail(
                    of: CGSize(width: 240, height: 100)
                )
                tarjeta.imagePlacement = .bottom
                tarjeta.imagePadding = 8
                tarjeta.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                boton?.configuration = tarjeta
                boton?.accessibilityLabel = opcion.nombre
                boton?.accessibilityHint = "Abre la imagen y descripción de esta cultura"
            }
        }
    }

    @IBAction private func elegirRelacionada(_ sender: UIButton) {
        guard mostrarRelacionadas, let cultura = cultura else { return }
        let opciones = [cultura] + cultura.relacionadas
        guard opciones.indices.contains(sender.tag) else { return }
        performSegue(withIdentifier: "verCulturaRelacionada", sender: opciones[sender.tag])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "verCulturaRelacionada",
              let destino = segue.destination as? DetalleCulturaViewController,
              let seleccion = sender as? Cultura else { return }
        destino.cultura = seleccion
        destino.mostrarRelacionadas = false
    }
}
