import UIKit

class BoletaViewController: UIViewController {
    var carrito: CarritoModel!
    var cliente: ClienteModel!
    @IBOutlet weak var clienteLabel: UILabel!
    @IBOutlet weak var lineasLabel: UILabel!
    @IBOutlet weak var resumenLabel: UILabel!
    private var compraConfirmada = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        // Guardar los valores en la boleta ANTES de vaciar el mismo carrito.
        clienteLabel.text = cliente.nombre + " " + cliente.apellido + " (" + carrito.categoria() + ")\nDNI: " + cliente.dni
        lineasLabel.text = carrito.lineasTexto()
        resumenLabel.text = carrito.resumenTexto()
        compraConfirmada = carrito.confirmarCompra()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !compraConfirmada {
            let alerta = UIAlertController(title: "No se pudo confirmar", message: "El carrito está vacío o no hay stock suficiente.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.cerrar()
            })
            present(alerta, animated: true)
        }
    }

    @IBAction func cerrarTapped(_ sender: UIButton) { cerrar() }

    private func cerrar() {
        let navegacion = presentingViewController as? UINavigationController
        dismiss(animated: true) {
            navegacion?.popToRootViewController(animated: false)
        }
    }
}
