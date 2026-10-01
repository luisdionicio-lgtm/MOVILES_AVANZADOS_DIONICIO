import UIKit

final class ResultadoViewController: UIViewController {
    var venta: VentaModel?

    @IBOutlet private weak var lblSubtotal: UILabel!
    @IBOutlet private weak var lblIgv: UILabel!
    @IBOutlet private weak var lblBase: UILabel!
    @IBOutlet private weak var lblIntereses: UILabel!
    @IBOutlet private weak var lblTotal: UILabel!
    @IBOutlet private weak var lblCuota: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let venta else { return }
        lblSubtotal.text = soles(venta.subtotal)
        lblIgv.text = soles(venta.igv)
        lblBase.text = soles(venta.base)
        lblIntereses.text = soles(venta.intereses)
        lblTotal.text = soles(venta.total)
        lblCuota.text = soles(venta.cuota)
    }

    private func soles(_ valor: Double) -> String {
        String(format: "S/. %.2f", valor)
    }
}
