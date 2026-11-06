import UIKit

final class SalesController: UITableViewController, UISearchResultsUpdating {
    var rows = [Venta]()
    let period = UISegmentedControl(items: ["Todas","Hoy","Mes"])
    let seller = UIButton(type: .system)
    let search = UISearchController(searchResultsController: nil)
    var selectedSeller: Usuario?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.background
        tableView.rowHeight = 105
        search.searchResultsUpdater = self; search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        period.selectedSegmentIndex = 0
        period.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); refresh() }
    func updateSearchResults(for searchController: UISearchController) { refresh() }
    @objc func refresh() {
        rows = Store.shared.sales(text: search.searchBar.text ?? "", period: period.selectedSegmentIndex, seller: selectedSeller)
        let all = Store.shared.sales().filter { !$0.anulada }
        let today = all.filter { Calendar.current.isDateInToday($0.fecha) }.reduce(0) { $0+$1.total }
        let month = all.filter { Calendar.current.isDate($0.fecha, equalTo: Date(), toGranularity: .month) }.reduce(0) { $0+$1.total }
        let todayCount = all.filter { Calendar.current.isDateInToday($0.fecha) }.count
        let monthCount = all.filter { Calendar.current.isDate($0.fecha, equalTo: Date(), toGranularity: .month) }.count
        let left = Theme.card([Theme.label("Hoy", size: 13), Theme.label(Theme.money(today), size: 20, bold: true), Theme.label("\(todayCount) ventas", size: 12)], padding: 12)
        let right = Theme.card([Theme.label("Mes", size: 13), Theme.label(Theme.money(month), size: 20, bold: true), Theme.label("\(monthCount) ventas", size: 12)], padding: 12)
        let total = UIStackView(arrangedSubviews: [left, right]); total.axis = .horizontal; total.spacing = 10; total.distribution = .fillEqually
        total.heightAnchor.constraint(equalToConstant: 95).isActive = true
        let pieces: [UIView]
        if Store.shared.supervisor {
            let users: [Usuario] = Store.shared.fetch("Usuario", predicate: NSPredicate(format: "rol == %@", Role.vendedor.rawValue), sort: "nombre")
            let chips = UIStackView(); chips.axis = .horizontal; chips.spacing = 8
            let choices: [(String, Usuario?)] = [("Todos", nil)] + users.map { ($0.nombre, Optional($0)) }
            for (name, user) in choices {
                let button = UIButton(type: .system)
                var config = UIButton.Configuration.filled(); config.title = name
                config.cornerStyle = .capsule
                config.baseBackgroundColor = (selectedSeller == user) ? Theme.navy : .white
                config.baseForegroundColor = (selectedSeller == user) ? .white : Theme.navy
                button.configuration = config
                button.addAction(UIAction { [weak self] _ in self?.selectedSeller = user; self?.refresh() }, for: .touchUpInside)
                chips.addArrangedSubview(button)
            }
            let scroll = UIScrollView(); scroll.showsHorizontalScrollIndicator = false
            chips.translatesAutoresizingMaskIntoConstraints = false; scroll.addSubview(chips)
            NSLayoutConstraint.activate([chips.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor), chips.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor), chips.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor), chips.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor), chips.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor)])
            scroll.heightAnchor.constraint(equalToConstant: 38).isActive = true
            pieces = [total, period, scroll]
        } else { pieces = [total,period] }
        let stack = Theme.stack(pieces)
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: Store.shared.supervisor ? 222 : 175))
        stack.frame = header.bounds.insetBy(dx: 20, dy: 10)
        header.addSubview(stack); tableView.tableHeaderView = header
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let v = rows[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        let heading = "\(v.cliente?.nombre ?? "") · \(Theme.money(v.total))"
        if v.anulada {
            cell.textLabel?.attributedText = NSAttributedString(string: heading, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.textLabel?.textColor = .secondaryLabel
        } else { cell.textLabel?.text = heading; cell.textLabel?.textColor = Theme.navy }
        let date = v.fecha.formatted(date: .abbreviated, time: .shortened)
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(v.producto?.nombre ?? "") × \(v.cantidad) · \(date)\nVendedor · \(v.vendedor?.nombre ?? "")" +
            (v.anulada ? "\nANULADA · \(v.motivoAnulacion ?? "")" : "\nIGV · \(Theme.money(v.igv))")
        cell.imageView?.image = UIImage(systemName: v.anulada ? "xmark.circle.fill" : "checkmark.circle.fill")
        cell.imageView?.tintColor = v.anulada ? .systemRed : .systemGreen
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let v = rows[indexPath.row]
        message("\(v.producto?.nombre ?? "") × \(v.cantidad)\nCliente · \(v.cliente?.nombre ?? "")\nDescuento · \(Theme.money(v.descuento))\nIGV · \(Theme.money(v.igv))\nTotal · \(Theme.money(v.total))")
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let v = rows[indexPath.row]
        guard Store.shared.supervisor, !v.anulada else { return nil }
        let action = UIContextualAction(style: .destructive, title: "Anular") { [weak self] _,_,done in self?.cancel(v); done(true) }
        let config = UISwipeActionsConfiguration(actions: [action]); config.performsFirstActionWithFullSwipe = false
        return config
    }
    func cancel(_ venta: Venta) {
        let a = UIAlertController(title: "Anular venta", message: "\(venta.producto?.nombre ?? "") × \(venta.cantidad)\nTotal · \(Theme.money(venta.total))\nSe devolverán \(venta.cantidad) unidades al stock.", preferredStyle: .alert)
        a.addTextField { $0.placeholder = "Motivo obligatorio" }
        let confirm = UIAlertAction(title: "Anular", style: .destructive) { [weak self, weak a] _ in
            do { try Store.shared.cancel(venta, motivo: a?.textFields?.first?.text ?? ""); self?.refresh() }
            catch { self?.message(error.localizedDescription) }
        }
        confirm.isEnabled = false
        a.textFields?.first?.addAction(UIAction { [weak a, weak confirm] _ in
            confirm?.isEnabled = !(a?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        }, for: .editingChanged)
        a.addAction(confirm); a.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(a, animated: true)
    }
}
