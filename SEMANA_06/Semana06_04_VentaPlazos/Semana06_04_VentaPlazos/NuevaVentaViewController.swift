import UIKit

final class NuevaVentaViewController: UIViewController {
    @IBOutlet private weak var tfElectrodomestico: UITextField!
    @IBOutlet private weak var tfPrecio: UITextField!
    @IBOutlet private weak var tfCantidad: UITextField!
    @IBOutlet private weak var tfMeses: UITextField!
    @IBOutlet private weak var tfTasa: UITextField!

    private var ventaCalculada: VentaModel?

    @IBAction private func calcular(_ sender: Any) {
        guard !(tfElectrodomestico.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty,
              let precio = Double(tfPrecio.text ?? ""), precio > 0,
              let cantidad = Double(tfCantidad.text ?? ""), cantidad > 0,
              let meses = Double(tfMeses.text ?? ""), meses > 0,
              let tasa = Double(tfTasa.text ?? ""), tasa >= 0 else {
            mostrarError()
            return
        }

        let subtotal = precio * cantidad
        let igv = subtotal * 0.18
        let base = subtotal + igv
        let intereses = base * (tasa / 100) * meses
        let total = base + intereses
        let cuota = total / meses

        ventaCalculada = VentaModel(
            subtotal: subtotal,
            igv: igv,
            base: base,
            intereses: intereses,
            total: total,
            cuota: cuota
        )
        performSegue(withIdentifier: "showResultado", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showResultado",
              let resultado = segue.destination as? ResultadoViewController else { return }
        resultado.venta = ventaCalculada
    }

    private func mostrarError() {
        let alerta = UIAlertController(
            title: "Datos incompletos",
            message: "Ingresa valores válidos. El precio, la cantidad y los meses deben ser mayores que cero.",
            preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
