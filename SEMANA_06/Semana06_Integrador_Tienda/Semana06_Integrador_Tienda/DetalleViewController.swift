// Desarrollado por: Luis Dionicio. Implementación asistida por IA.
import UIKit

class DetalleViewController: UIViewController {
    var producto: Producto!
    var carrito: CarritoModel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var cantidadStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = producto.nombre
        nombreLabel.text = producto.nombre
        precioLabel.text = "Precio: " + soles(producto.precio)
        stockLabel.text = "Stock: " + String(producto.stock)
        cantidadStepper.value = 1
        actualizarCantidad()
    }

    @IBAction func cantidadCambiada(_ sender: UIStepper) { actualizarCantidad() }

    private func actualizarCantidad() {
        cantidadLabel.text = "Cantidad: " + String(Int(cantidadStepper.value))
    }

    @IBAction func agregarTapped(_ sender: UIButton) {
        guard carrito.agregar(producto: producto, cantidad: Int(cantidadStepper.value)) else {
            let alerta = UIAlertController(title: "Stock insuficiente", message: "La cantidad solicitada más lo que ya está en el carrito supera el stock disponible.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }
}
