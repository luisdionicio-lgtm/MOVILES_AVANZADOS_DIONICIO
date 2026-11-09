import UIKit
import CoreData

final class CatalogController: UITableViewController, UISearchResultsUpdating {
    let products: Bool
    var rows = [NSManagedObject]()
    let search = UISearchController(searchResultsController: nil)
    let categories = UISegmentedControl(items: ["Todas"])
    init(products: Bool) { self.products = products; super.init(style: .insetGrouped) }
    required init?(coder: NSCoder) { fatalError() }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.background
        tableView.rowHeight = 94
        search.searchResultsUpdater = self; search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = products ? "Buscar producto" : "Buscar cliente"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        if !products || Store.shared.supervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        }
        categories.addTarget(self, action: #selector(filter), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); refresh() }
    func updateSearchResults(for searchController: UISearchController) { load() }
    func refresh() {
        if products {
            let list: [Producto] = Store.shared.fetch("Producto")
            let index = categories.selectedSegmentIndex
            let selected = index >= 0 && index < categories.numberOfSegments
                ? (categories.titleForSegment(at: index) ?? "Todas") : "Todas"
            categories.removeAllSegments()
            let names = ["Todas"] + Array(Set(list.map(\.categoria))).sorted()
            for (index,name) in names.enumerated() { categories.insertSegment(withTitle: name, at: index, animated: false) }
            categories.selectedSegmentIndex = names.firstIndex(of: selected) ?? 0
            categories.frame = CGRect(x: 16, y: 12, width: tableView.bounds.width - 32, height: 34)
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 58))
            header.addSubview(categories); tableView.tableHeaderView = header
        }
        load()
    }
    @objc func filter() { load() }
    func load() {
        var filters = [NSPredicate]()
        if let text = search.searchBar.text, !text.isEmpty {
            filters.append(products ? NSPredicate(format: "nombre CONTAINS[cd] %@", text) : NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", text, text))
        }
        if products, categories.selectedSegmentIndex > 0,
           let selected = categories.titleForSegment(at: categories.selectedSegmentIndex) {
            filters.append(NSPredicate(format: "categoria == %@", selected))
        }
        rows = Store.shared.fetch(products ? "Producto" : "Cliente",
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: filters), sort: "nombre")
        tableView.reloadData()
        tableView.backgroundView = rows.isEmpty ? Theme.label("  Aún no hay resultados.\n  Usa + para empezar.", size: 18) : nil
    }
    @objc func add() { edit(nil) }
    func edit(_ object: NSManagedObject?) {
        if products && !Store.shared.supervisor { return }
        let alert = UIAlertController(title: object == nil ? "Nuevo registro" : "Editar registro", message: products ? "Datos del producto" : "Datos del cliente", preferredStyle: .alert)
        let keys = products ? ["nombre","categoria","precio","stock"] : ["nombre","documento"]
        let labels = products ? ["Nombre","Categoría","Precio en soles","Stock"] : ["Nombre","Documento"]
        for (i,key) in keys.enumerated() {
            alert.addTextField { field in
                field.placeholder = labels[i]
                if let value = object?.value(forKey: key) { field.text = String(describing: value) }
                if i == 2 { field.keyboardType = .decimalPad }
                if i == 3 { field.keyboardType = .numberPad }
            }
        }
        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alert] _ in
            guard let self, let fields = alert?.textFields else { return }
            do {
                if self.products {
                    guard let price = Double((fields[2].text ?? "").replacingOccurrences(of: ",", with: ".")),
                          let stock = Int(fields[3].text ?? "") else { throw VentasError.message("Escribe precio y stock válidos.") }
                    try Store.shared.product(object as? Producto, nombre: fields[0].text ?? "",
                        categoria: fields[1].text ?? "", precio: price, stock: stock)
                } else {
                    try Store.shared.client(object as? Cliente, nombre: fields[0].text ?? "", documento: fields[1].text ?? "")
                }
                self.refresh()
            } catch { self.message(error.localizedDescription) }
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .white
        cell.selectionStyle = .default
        let object = rows[indexPath.row]
        let badge = UIView(); badge.backgroundColor = Theme.navy.withAlphaComponent(0.06); badge.layer.cornerRadius = 13
        let iconView = UIImageView(); iconView.contentMode = .scaleAspectFit; iconView.tintColor = Theme.navy
        badge.translatesAutoresizingMaskIntoConstraints = false; iconView.translatesAutoresizingMaskIntoConstraints = false
        badge.addSubview(iconView)
        let name = Theme.label("", size: 16, bold: true)
        let detail = Theme.label("", size: 13); detail.textColor = .secondaryLabel
        let rightTop = Theme.label("", size: 15, bold: true); rightTop.textAlignment = .right
        let rightBottom = Theme.label("", size: 11, bold: true); rightBottom.textAlignment = .center
        rightBottom.layer.cornerRadius = 9; rightBottom.clipsToBounds = true
        let labels = UIStackView(arrangedSubviews: [name, detail]); labels.axis = .vertical; labels.spacing = 5
        let values = UIStackView(arrangedSubviews: [rightTop, rightBottom]); values.axis = .vertical; values.spacing = 6; values.alignment = .trailing
        let layout = UIStackView(arrangedSubviews: [badge, labels, values]); layout.axis = .horizontal; layout.alignment = .center; layout.spacing = 12
        layout.translatesAutoresizingMaskIntoConstraints = false; cell.contentView.addSubview(layout)
        NSLayoutConstraint.activate([
            layout.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16), layout.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            layout.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12), layout.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12),
            badge.widthAnchor.constraint(equalToConstant: 48), badge.heightAnchor.constraint(equalToConstant: 48),
            iconView.centerXAnchor.constraint(equalTo: badge.centerXAnchor), iconView.centerYAnchor.constraint(equalTo: badge.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 44), iconView.heightAnchor.constraint(equalToConstant: 44)
        ])
        if let p = object as? Producto {
            name.text = p.nombre; detail.text = p.categoria
            rightTop.text = Theme.money(p.precio)
            rightBottom.text = "  \(p.stock) en stock  "
            let color: UIColor = p.stock > 10 ? .systemGreen : p.stock >= 6 ? .systemOrange : .systemRed
            rightBottom.textColor = color; rightBottom.backgroundColor = color.withAlphaComponent(0.12)
            let n = p.nombre.lowercased()
            let icon = n.contains("laptop") ? "fa-laptop" : n.contains("mouse") ? "fa-computer-mouse" : n.contains("monitor") ? "fa-desktop" : n.contains("teclado") ? "fa-keyboard" : "fa-box-open"
            let photo = n.contains("laptop") ? "foto-laptop" : n.contains("mouse") ? "foto-mouse" : n.contains("monitor") ? "foto-monitor" : n.contains("teclado") ? "foto-teclado" : ""
            if let image = UIImage(named: photo) {
                iconView.image = image; iconView.contentMode = .scaleAspectFill
                iconView.layer.cornerRadius = 10; iconView.clipsToBounds = true
            } else { iconView.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate) }
        } else if let c = object as? Cliente {
            name.text = c.nombre; detail.text = c.documento
            rightTop.text = Theme.money(c.comprado); rightBottom.text = "  \(c.categoria)  "
            rightBottom.textColor = Theme.copper; rightBottom.backgroundColor = Theme.copper.withAlphaComponent(0.12)
            iconView.image = UIImage(systemName: "person.fill")
        }
        cell.accessibilityLabel = "\(name.text ?? ""), \(detail.text ?? ""), \(rightTop.text ?? ""), \(rightBottom.text ?? "")"
        cell.accessoryType = products && !Store.shared.supervisor ? .none : .disclosureIndicator
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true); edit(rows[indexPath.row])
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { Store.shared.supervisor }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        do { try Store.shared.delete(rows[indexPath.row]); refresh() }
        catch { message(error.localizedDescription) }
    }
}
