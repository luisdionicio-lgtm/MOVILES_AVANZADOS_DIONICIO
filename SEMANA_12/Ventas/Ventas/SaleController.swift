import UIKit
import CoreData

final class SaleController: UIViewController {
    var clients = [Cliente]()
    var products = [Producto]()
    var client: Cliente?
    var product: Producto?
    let clientButton = UIButton(type: .system)
    let productButton = UIButton(type: .system)
    let quantity = UIStepper()
    let quantityLabel = Theme.label("Cantidad · 1", bold: true)
    let stockLabel = Theme.label("")
    let summary = Theme.label("", size: 19)
    override func viewDidLoad() {
        super.viewDidLoad()
        quantity.minimumValue = 1; quantity.maximumValue = 1_000_000; quantity.value = 1
        quantity.addTarget(self, action: #selector(update), for: .valueChanged)
        for button in [clientButton,productButton] {
            button.contentHorizontalAlignment = .leading
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.showsMenuAsPrimaryAction = true
            button.backgroundColor = .white; button.layer.cornerRadius = 10
        }
        formLayout(Theme.stack([
            Theme.label("Nueva operación", size: 30, bold: true),
            Theme.label("Vendedor · "+(Store.shared.current?.nombre ?? ""), bold: true),
            Theme.label("Cliente", size: 13, bold: true), clientButton,
            Theme.label("Producto", size: 13, bold: true), productButton, stockLabel,
            quantityLabel, quantity, Theme.label("RESUMEN DE LA VENTA", size: 12, bold: true), summary,
            Theme.button("Registrar venta", action: UIAction { [weak self] _ in self?.register() })
        ]))
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
    @objc func update() {
        clientButton.setTitle("  "+(client?.nombre ?? "Selecciona un cliente  ▾"), for: .normal)
        productButton.setTitle("  "+(product?.nombre ?? "Selecciona un producto  ▾"), for: .normal)
        quantity.maximumValue = max(1, Double(product?.stock ?? 1))
        stockLabel.text = "Stock disponible · \(product?.stock ?? 0)"
        quantityLabel.text = "Cantidad · \(Int(quantity.value))"
        guard let product, let client else { summary.text = "Selecciona cliente y producto."; return }
        let a = Importe(precio: product.precio, cantidad: Int(quantity.value), vip: client.categoria == "VIP")
        summary.text = """
        Subtotal           \(Theme.money(a.subtotal))
        Descuento          \(Theme.money(a.descuento))
        IGV 18%            \(Theme.money(a.igv))

        Total              \(Theme.money(a.total))
        """
    }
    func register() {
        guard let client, let product else { message("Selecciona cliente y producto."); return }
        do {
            let v = try Store.shared.sell(cliente: client, producto: product, cantidad: Int(quantity.value))
            message("Venta registrada · "+Theme.money(v.total))
            quantity.value = 1; update()
        } catch { message(error.localizedDescription) }
    }
}
