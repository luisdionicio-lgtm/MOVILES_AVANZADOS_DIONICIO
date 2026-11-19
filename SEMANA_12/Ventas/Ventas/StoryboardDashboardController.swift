import UIKit
import SwiftUI

/// Los controles visibles pertenecen a Main.storyboard; aquí se actualizan sus datos.
final class DashboardController: UIViewController {
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var variationLabel: UILabel!
    @IBOutlet weak var chartLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    private var chartHost: UIHostingController<WeekChart>?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sales = Store.shared.sales().filter { !$0.anulada }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
        let total = sales.filter { cal.isDate($0.fecha, inSameDayAs: today) }.reduce(0) { $0 + $1.total }
        let prior = sales.filter { cal.isDate($0.fecha, inSameDayAs: yesterday) }.reduce(0) { $0 + $1.total }
        let month = sales.filter { cal.isDate($0.fecha, equalTo: today, toGranularity: .month) }
        greeting.font = .systemFont(ofSize: 25, weight: .bold)
        greeting.text = "Hola, \(Store.shared.current?.nombre ?? "") · Supervisor"
        todayLabel.text = "Vendido hoy · \(Theme.money(total))"
        taxLabel.text = "IGV del mes · \(Theme.money(month.reduce(0) { $0 + $1.igv }))"
        variationLabel.text = "Variación diaria · \(Theme.money(total - prior))"
        let users: [Usuario] = Store.shared.fetch("Usuario", predicate: NSPredicate(format: "rol == %@", Role.vendedor.rawValue))
        let ranking = users.map { u in (u.nombre, month.filter { $0.vendedor == u }.reduce(0) { $0 + $1.total }) }.sorted { $0.1 > $1.1 }
        rankingLabel.text = ranking.map { "\($0.0) · \(Theme.money($0.1))" }.joined(separator: "\n")
        let low: [Producto] = Store.shared.fetch("Producto", predicate: NSPredicate(format: "stock <= 5"), sort: "stock")
        stockLabel.text = low.isEmpty ? "Inventario en buen nivel" : low.map { "\($0.nombre) · \($0.stock) unidades" }.joined(separator: "\n")
        let days = (0..<7).map { index -> DayAmount in
            let day = cal.date(byAdding: .day, value: index - 6, to: today)!
            return DayAmount(id: day, total: sales.filter { cal.isDate($0.fecha, inSameDayAs: day) }.reduce(0) { $0 + $1.total })
        }
        chartHost?.willMove(toParent: nil); chartHost?.view.removeFromSuperview(); chartHost?.removeFromParent()
        let host = UIHostingController(rootView: WeekChart(days: days)); chartHost = host
        addChild(host); chartLabel.text = nil; chartLabel.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([host.view.leadingAnchor.constraint(equalTo: chartLabel.leadingAnchor), host.view.trailingAnchor.constraint(equalTo: chartLabel.trailingAnchor), host.view.topAnchor.constraint(equalTo: chartLabel.topAnchor), host.view.bottomAnchor.constraint(equalTo: chartLabel.bottomAnchor)])
        host.didMove(toParent: self)
    }
}
