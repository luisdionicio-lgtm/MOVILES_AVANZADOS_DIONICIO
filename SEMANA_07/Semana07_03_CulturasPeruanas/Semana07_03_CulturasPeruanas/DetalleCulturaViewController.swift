import UIKit

class DetalleCulturaViewController: UIViewController {
    var cultura: Cultura?
    var mostrarRelacionadas = true

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var relacionadasLabel: UILabel!
    @IBOutlet weak var primeraRelacionadaButton: UIButton!
    @IBOutlet weak var segundaRelacionadaButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cultura = cultura else { return }
        title = cultura.nombre
        nombreLabel.text = "Cultura " + cultura.nombre
        regionLabel.text = "Región: " + cultura.region
        descripcionLabel.text = cultura.descripcion
        imagenView.image = UIImage(named: cultura.imagen)
        imagenView.isAccessibilityElement = true
        imagenView.accessibilityLabel = "Imagen representativa de la cultura " + cultura.nombre
        let opciones = mostrarRelacionadas ? cultura.relacionadas : []
        relacionadasLabel.isHidden = opciones.isEmpty
        for (indice, boton) in [primeraRelacionadaButton, segundaRelacionadaButton].enumerated() {
            boton?.isHidden = indice >= opciones.count
            if indice < opciones.count {
                boton?.setTitle("Leer sobre " + opciones[indice].nombre + " ›", for: .normal)
            }
        }
    }

    @IBAction private func elegirRelacionada(_ sender: UIButton) {
        guard let opciones = cultura?.relacionadas,
              opciones.indices.contains(sender.tag) else { return }
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
