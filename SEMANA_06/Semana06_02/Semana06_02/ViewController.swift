import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var tfApellido: UITextField!
    @IBOutlet private weak var tfNombre: UITextField!
    @IBOutlet private weak var tfDni: UITextField!

    @IBAction private func btnContinuar(_ sender: Any) {
        performSegue(withIdentifier: "mostrarConfirmacion", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "mostrarConfirmacion",
              let confirmacion = segue.destination as? ViewControllerConfirmacion else { return }

        confirmacion.pCliente = ClienteModel(
            codigo: 0,
            apellido: tfApellido.text ?? "",
            nombre: tfNombre.text ?? "",
            dni: tfDni.text ?? ""
        )

    }
}
