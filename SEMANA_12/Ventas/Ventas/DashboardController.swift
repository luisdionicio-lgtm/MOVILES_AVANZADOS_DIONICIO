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
#Preview {
    WeekChart(days: (0..<7).map { DayAmount(id: Calendar.current.date(byAdding: .day, value: $0 - 6, to: Date())!, total: [180, 275, 145, 350, 245, 210, 425][$0]) })
}
