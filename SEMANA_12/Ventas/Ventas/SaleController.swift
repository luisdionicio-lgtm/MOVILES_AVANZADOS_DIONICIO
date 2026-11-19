import UIKit
import CoreData

final class SaleController: UIViewController {
    var clients = [Cliente]()
    var products = [Producto]()
    var client: Cliente?
    var product: Producto?
    @IBOutlet weak var clientButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var quantity: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var subtotalValue: UILabel!
    @IBOutlet weak var discountValue: UILabel!
    @IBOutlet weak var taxValue: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        clientButton.showsMenuAsPrimaryAction = true; productButton.showsMenuAsPrimaryAction = true
        sellerLabel.text = Store.shared.current?.nombre
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clients = Store.shared.fetch("Cliente", sort: "nombre")
        products = Store.shared.fetch("Producto", sort: "nombre")
        if client?.isDeleted == true || client?.managedObjectContext == nil { client = nil }
        if product?.isDeleted == true || product?.managedObjectContext == nil { product = nil }
        clientButton.menu = UIMenu(children: clients.map { c in
            UIAction(title: "\(c.nombre) · \(c.categoria)") { [weak self] _ in self?.client = c; self?.update() }
        })
        productButton.menu = UIMenu(children: products.map { p in
            UIAction(title: "\(p.nombre) · \(Theme.money(p.precio))") { [weak self] _ in self?.product = p; self?.quantity.value = 1; self?.update() }
        })
        update()
    }
    @IBAction func update(_ sender: Any? = nil) {
        clientButton.setTitle("  "+(client?.nombre ?? "Selecciona un cliente  ▾"), for: .normal)
        productButton.setTitle("  "+(product?.nombre ?? "Selecciona un producto  ▾"), for: .normal)
        quantity.maximumValue = 1_000_000
        stockLabel.text = "Stock disponible · \(product?.stock ?? 0)"
        quantityLabel.text = "Cantidad · \(Int(quantity.value))"
        guard let product, let client else {
            subtotalValue.text = "Subtotal · S/ 0.00"; discountValue.text = "Descuento · S/ 0.00"; taxValue.text = "IGV · S/ 0.00"; totalValue.text = "Total · S/ 0.00"; return
        }
        let a = Importe(precio: product.precio, cantidad: Int(quantity.value), vip: client.categoria == "VIP")
        subtotalValue.text = "Subtotal · " + Theme.money(a.subtotal); discountValue.text = "Descuento · " + Theme.money(a.descuento)
        taxValue.text = "IGV 18 % · " + Theme.money(a.igv); totalValue.text = "Total · " + Theme.money(a.total)
    }
    @IBAction func register(_ sender: Any) {
        guard let client, let product else { message("Selecciona cliente y producto."); return }
        do {
            let v = try Store.shared.sell(cliente: client, producto: product, cantidad: Int(quantity.value))
            message("Venta registrada · "+Theme.money(v.total))
            quantity.value = 1; update()
        } catch { message(error.localizedDescription) }
    }
}
