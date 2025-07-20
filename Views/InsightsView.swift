import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var viewModel: MoodLoggingViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Stimmungs-Heatmap")
                        .font(.custom("Montserrat-Bold", size: 28))
                        .foregroundColor(.brandPrimary)
                        .padding([.top, .horizontal])

                                        HeatmapView()
                        .padding(.horizontal)

                                        MoodTrendChartView(entries: viewModel.journalEntries)
                        .padding([.top, .horizontal])

                    WordCloudView(tagFrequencies: viewModel.tagFrequencies)
                        .padding([.top, .horizontal])

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
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
    return InsightsView()
        .environmentObject(vm)
}
