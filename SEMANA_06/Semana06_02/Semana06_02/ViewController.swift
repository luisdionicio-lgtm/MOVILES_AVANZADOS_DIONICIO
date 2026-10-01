import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var tfApellido: UITextField!
    @IBOutlet private weak var tfNombre: UITextField!
    @IBOutlet private weak var tfDni: UITextField!

    @IBAction private func btnContinuar(_ sender: Any) {
        let cliente = ClienteModel(
            codigo: 0,
            apellido: tfApellido.text ?? "",
            nombre: tfNombre.text ?? "",
            dni: tfDni.text ?? ""
        )

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let confirmacion = storyboard.instantiateViewController(
            withIdentifier: "ViewControllerConfirmacion"
        ) as? ViewControllerConfirmacion else { return }

        confirmacion.pCliente = cliente
        confirmacion.modalPresentationStyle = .pageSheet
        present(confirmacion, animated: true)
    }
}
