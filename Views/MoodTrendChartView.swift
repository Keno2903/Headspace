import SwiftUI
import Charts

struct MoodTrendChartView: View {
    let entries: [JournalEntry]

    private var last30DaysEntries: [JournalEntry] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        return entries.filter { $0.date >= thirtyDaysAgo }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Stimmungs-Trend (Letzte 30 Tage)")
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(.brandPrimary)
                .padding(.bottom, 10)

            if last30DaysEntries.count < 2 {
                ContentUnavailableView(
                    "Nicht genügend Daten",
                    systemImage: "chart.bar.xaxis.ascending",
                    description: Text("Erfasse mehr Einträge, um deinen Trend zu sehen.")
                )
                .frame(height: 250)
            } else {
                Chart(last30DaysEntries) {
                    entry in
                    LineMark(
                        x: .value("Datum", entry.date, unit: .day),
                        y: .value("Stimmung", entry.moodScore)
                    )
                    .foregroundStyle(Color.brandAccent)
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("Datum", entry.date, unit: .day),
                        y: .value("Stimmung", entry.moodScore)
                    )
                    .foregroundStyle(Color.brandPrimary)
                    .symbolSize(CGSize(width: 8, height: 8))
                }
                .chartYScale(domain: 0...4)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        if let date = value.as(Date.self), Calendar.current.component(.day, from: date) % 5 == 0 {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.day())
                        }
                    }
                }
                .frame(height: 250)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    // Create mock data for preview
    let mockEntries: [JournalEntry] = (0..<30).map { i in
        let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
        let score = Double.random(in: 1.5...3.8)
        return JournalEntry(date: date, moodScore: score)
    }
    return MoodTrendChartView(entries: mockEntries)
        .padding()
}
