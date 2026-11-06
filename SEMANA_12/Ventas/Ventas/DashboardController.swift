import UIKit
import Charts
import SwiftUI

struct DayAmount: Identifiable {
    let id: Date
    let total: Double
}
struct WeekChart: View {
    let days: [DayAmount]
    var body: some View {
        Chart(days) { day in
            BarMark(x: .value("Día", day.id, unit: .day), y: .value("Ventas", day.total))
                .foregroundStyle(Color(red: 0.10, green: 0.16, blue: 0.25))
                .cornerRadius(4)
        }
        .chartXAxis { AxisMarks(values: .stride(by: .day)) { _ in AxisValueLabel(format: .dateTime.day()) } }
        .padding(12)
        .background(Color.white)
    }
}
final class DashboardController: UIViewController {
    var chartHost: UIHostingController<WeekChart>?
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); render() }
    func render() {
        guard Store.shared.supervisor else { return }
        if let host = chartHost {
            host.willMove(toParent: nil); host.view.removeFromSuperview(); host.removeFromParent()
        }
        view.subviews.forEach { $0.removeFromSuperview() }
        let all = Store.shared.sales().filter { !$0.anulada }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let todaySales = all.filter { calendar.isDate($0.fecha, inSameDayAs: today) }
        let previous = all.filter { calendar.isDate($0.fecha, inSameDayAs: yesterday) }.reduce(0) { $0+$1.total }
        let total = todaySales.reduce(0) { $0+$1.total }
        let tax = all.filter { calendar.isDate($0.fecha, equalTo: Date(), toGranularity: .month) }.reduce(0) { $0+$1.igv }
        let card = Theme.stack([
            Theme.label("VENTAS DE HOY", size: 12, bold: true),
            Theme.label(Theme.money(total), size: 35, bold: true),
            Theme.label("Variación diaria · \(Theme.money(total - previous))", size: 14),
            Theme.label("\(todaySales.count) operaciones · IGV del mes \(Theme.money(tax))", size: 15)
        ])
        card.backgroundColor = .white; card.layer.cornerRadius = 16
        card.isLayoutMarginsRelativeArrangement = true; card.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        let days = (0..<7).map { index -> DayAmount in
            let day = calendar.date(byAdding: .day, value: index - 6, to: today)!
            return DayAmount(id: day, total: all.filter { calendar.isDate($0.fecha, inSameDayAs: day) }.reduce(0) { $0+$1.total })
        }
        let host = UIHostingController(rootView: WeekChart(days: days))
        chartHost = host
        addChild(host); host.didMove(toParent: self)
        host.view.heightAnchor.constraint(equalToConstant: 220).isActive = true
        let stack = Theme.stack([
            Theme.label("Hola, "+(Store.shared.current?.nombre ?? ""), size: 27, bold: true),
            Theme.label("Supervisor · Vista de la operación", size: 14),
            card, Theme.label("Últimos siete días", size: 21, bold: true), host.view,
            Theme.label("Ranking del mes", size: 21, bold: true)
        ])
        let month = all.filter { calendar.isDate($0.fecha, equalTo: Date(), toGranularity: .month) }
        let users: [Usuario] = Store.shared.fetch("Usuario", predicate: NSPredicate(format: "rol == %@", Role.vendedor.rawValue))
        let ranking = users.map { user in (user.nombre, month.filter { $0.vendedor == user }.reduce(0) { $0+$1.total }) }.sorted { $0.1 > $1.1 }
        for (i,item) in ranking.enumerated() {
            stack.addArrangedSubview(Theme.label("\(i+1). \(item.0)   ·   \(Theme.money(item.1))"))
        }
        if ranking.isEmpty { stack.addArrangedSubview(Theme.label("Aún no hay vendedores.")) }
        stack.addArrangedSubview(Theme.label("Stock bajo", size: 21, bold: true))
        let low: [Producto] = Store.shared.fetch("Producto", predicate: NSPredicate(format: "stock <= 10"), sort: "stock")
        for p in low {
            let label = Theme.label("\(p.nombre) · \(p.stock) unidades")
            label.textColor = p.stock <= 5 ? .systemRed : .systemOrange
            stack.addArrangedSubview(label)
        }
        if low.isEmpty { stack.addArrangedSubview(Theme.label("Inventario en buen nivel.")) }
        formLayout(stack)
    }
}

#Preview {
    WeekChart(days: [DayAmount(id: Date(), total: 424.8)])
}
