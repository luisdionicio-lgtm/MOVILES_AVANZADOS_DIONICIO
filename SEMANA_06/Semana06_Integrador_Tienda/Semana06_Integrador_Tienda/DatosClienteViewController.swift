import UIKit

class DatosClienteViewController: UIViewController {
    var carrito: CarritoModel!
    private var cliente: ClienteModel?
    @IBOutlet weak var apellidoField: UITextField!
    @IBOutlet weak var nombreField: UITextField!
    @IBOutlet weak var dniField: UITextField!

    @IBAction func confirmarTapped(_ sender: UIButton) {
        view.endEditing(true)
        let apellido = (apellidoField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nombre = (nombreField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let dni = (dniField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if let mensaje = ValidacionCliente.mensaje(apellido: apellido, nombre: nombre, dni: dni) {
            let alerta = UIAlertController(title: "Datos del cliente", message: mensaje, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        cliente = ClienteModel(codigo: 0, apellido: apellido, nombre: nombre, dni: dni)
        performSegue(withIdentifier: "verBoleta", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verBoleta",
           let destino = segue.destination as? BoletaViewController {
            destino.carrito = carrito
            destino.cliente = cliente
        }
    }
}
