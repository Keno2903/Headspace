import SwiftUI

struct HeatmapView: View {
    @EnvironmentObject var viewModel: MoodLoggingViewModel
    
    // Configuration
    private let calendar = Calendar.current
    private let month: Date
    private let days: [Date]
    private let columns: [GridItem]
    
    init(month: Date = Date()) {
        self.month = month
        self.days = Self.generateDaysInMonth(for: month)
        self.columns = Array(repeating: GridItem(.flexible()), count: 7)
    }
    
    var body: some View {
        VStack {
            // Month and Year Header
            Text(month, formatter: Self.monthYearFormatter)
                .font(.custom("Montserrat-Bold", size: 20))
                .padding()

            // Day of Week Header
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.custom("Inter-Regular", size: 12))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar Grid
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        let dayAverage = viewModel.dailyAverageMoods[calendar.startOfDay(for: date)]
                        
                        Text("\(calendar.component(.day, from: date))")
                            .font(.custom("Inter-Regular", size: 14))
                            .frame(width: 35, height: 35)
                            .background(color(for: dayAverage))
                            .cornerRadius(8)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
        .padding()
    }
    
    private func color(for moodScore: Double?) -> Color {
        guard let score = moodScore else {
            return Color.gray.opacity(0.15) // No entry
        }
        // Gradient from light green (low) to dark green (high)
        let lightGreen = Color(red: 0.8, green: 1.0, blue: 0.8)
        let darkGreen = Color.green
        return lightGreen.interpolate(to: darkGreen, fraction: score / 4.0)
    }
    
    // MARK: - Helpers
    private static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private static func generateDaysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: date),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date] = []
        var current = monthFirstWeek.start
        let endDate = monthInterval.end
        
        while current < endDate {
            days.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        
        // Ensure the grid is complete for the last week
        let lastDayWeekday = Calendar.current.component(.weekday, from: monthInterval.end)
        if lastDayWeekday < 7 {
            for _ in 0..<(7 - lastDayWeekday + 1) {
                days.append(current)
                current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
            }
        }
        
        return days
    }
}

// Helper to interpolate between two colors
extension Color {
    func interpolate(to: Color, fraction: Double) -> Color {
        let f = min(max(0, fraction), 1)
        
        guard let start = self.cgColor?.components, let end = to.cgColor?.components else {
            return self
        }
        
        let r = start[0] + (end[0] - start[0]) * f
        let g = start[1] + (end[1] - start[1]) * f
        let b = start[2] + (end[2] - start[2]) * f
        
        return Color(red: r, green: g, blue: b)
    }
}

#Preview {
    let vm = MoodLoggingViewModel()
    // Add some mock data for preview
    vm.dailyAverageMoods = [
        Calendar.current.startOfDay(for: Date()) : 3.8,
        Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400 * 2)) : 1.2,
        Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400 * 5)) : 2.5
    ]
    return HeatmapView()
        .environmentObject(vm)
}
