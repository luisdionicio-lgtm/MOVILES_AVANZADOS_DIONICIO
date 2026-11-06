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
    let summary = Theme.label("", size: 16)
    let subtotalValue = Theme.label("S/ 0.00", bold: true)
    let discountValue = Theme.label("S/ 0.00", bold: true)
    let taxValue = Theme.label("S/ 0.00", bold: true)
    let totalValue = Theme.label("S/ 0.00", size: 19, bold: true)
    func row(_ name: String, _ value: UILabel) -> UIStackView {
        let label = Theme.label(name, size: 16); label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        value.textAlignment = .right; value.setContentHuggingPriority(.required, for: .horizontal)
        let row = UIStackView(arrangedSubviews: [label, value]); row.axis = .horizontal; row.distribution = .fill
        return row
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        quantity.minimumValue = 1; quantity.maximumValue = 1_000_000; quantity.value = 1
        quantity.addTarget(self, action: #selector(update), for: .valueChanged)
        for button in [clientButton,productButton] {
            button.contentHorizontalAlignment = .leading
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            button.showsMenuAsPrimaryAction = true
            button.backgroundColor = .white; button.layer.cornerRadius = 10
        }
        let selection = Theme.stack([
            Theme.label("CLIENTE", size: 12, bold: true), clientButton,
            Theme.label("PRODUCTO", size: 12, bold: true), productButton, stockLabel, quantityLabel, quantity
        ])
        selection.spacing = 6
        selection.backgroundColor = .white; selection.layer.cornerRadius = 18
        selection.isLayoutMarginsRelativeArrangement = true
        selection.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        let seller = Theme.card([Theme.label("VENDEDOR", size: 11, bold: true), Theme.label(Store.shared.current?.nombre ?? "", size: 17, bold: true), Theme.label("La venta se registrará a tu nombre", size: 13)], padding: 12)
        let amounts = Theme.card([row("Subtotal", subtotalValue), row("Descuento VIP", discountValue), row("IGV 18 %", taxValue), row("Total", totalValue)])
        formLayout(Theme.stack([
            seller, selection, Theme.label("RESUMEN DE LA VENTA", size: 12, bold: true), amounts,
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
        guard let product, let client else {
            [subtotalValue, discountValue, taxValue, totalValue].forEach { $0.text = Theme.money(0) }; return
        }
        let a = Importe(precio: product.precio, cantidad: Int(quantity.value), vip: client.categoria == "VIP")
        subtotalValue.text = Theme.money(a.subtotal); discountValue.text = Theme.money(a.descuento)
        taxValue.text = Theme.money(a.igv); totalValue.text = Theme.money(a.total)
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
