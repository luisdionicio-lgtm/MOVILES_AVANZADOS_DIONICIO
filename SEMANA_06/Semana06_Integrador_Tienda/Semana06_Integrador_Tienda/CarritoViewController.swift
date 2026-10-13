import UIKit

class CarritoViewController: UIViewController {
    var carrito: CarritoModel!
    @IBOutlet weak var lineasLabel: UILabel!
    @IBOutlet weak var resumenLabel: UILabel!
    @IBOutlet weak var finalizarButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lineasLabel.text = carrito.items.isEmpty ? "Tu carrito está vacío." : carrito.lineasTexto()
        resumenLabel.text = carrito.resumenTexto()
        finalizarButton.isEnabled = !carrito.items.isEmpty
    }

    @IBAction func finalizarTapped(_ sender: UIButton) {
        guard !carrito.items.isEmpty else { return }
        performSegue(withIdentifier: "irDatosCliente", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irDatosCliente",
           let destino = segue.destination as? DatosClienteViewController {
            destino.carrito = carrito
        }
    }
}
