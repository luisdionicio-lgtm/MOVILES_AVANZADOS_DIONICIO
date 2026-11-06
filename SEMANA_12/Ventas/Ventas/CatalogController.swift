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
            filters.append(NSPredicate(format: "nombre CONTAINS[cd] %@", text))
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let object = rows[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        cell.textLabel?.textColor = Theme.navy
        cell.detailTextLabel?.numberOfLines = 2
        if let p = object as? Producto {
            cell.textLabel?.text = p.nombre
            cell.detailTextLabel?.text = "\(p.categoria) · \(Theme.money(p.precio))\nStock disponible · \(p.stock)"
            cell.detailTextLabel?.textColor = p.stock > 10 ? .systemGreen : p.stock >= 6 ? .systemOrange : .systemRed
            cell.imageView?.image = UIImage(systemName: "shippingbox.fill")
        } else if let c = object as? Cliente {
            let initials = c.nombre.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined()
            cell.textLabel?.text = "\(initials)  ·  \(c.nombre)"
            cell.detailTextLabel?.text = "\(c.documento) · \(c.categoria)\nComprado · \(Theme.money(c.comprado))"
            cell.imageView?.image = UIImage(systemName: "person.crop.circle.fill")
        }
        cell.imageView?.tintColor = Theme.copper
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
