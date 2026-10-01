import UIKit

final class ViewControllerConfirmacion: UIViewController {
    var pCliente = ClienteModel()

    @IBOutlet private weak var tfApellido: UILabel!
    @IBOutlet private weak var tfNombre: UILabel!
    @IBOutlet private weak var tfDni: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfApellido.text = pCliente.apellido
        tfNombre.text = pCliente.nombre
        tfDni.text = pCliente.dni
    }

    @IBAction private func btnCerrar(_ sender: Any) {
        dismiss(animated: true)
    }
}
