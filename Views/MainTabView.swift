import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MoodLoggingViewModel()

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Heute", systemImage: "pencil.and.scribble")
                }
                .environmentObject(viewModel)

            JournalListView()
                .tabItem {
                    Label("Tagebuch", systemImage: "book.closed.fill")
                }
                .environmentObject(viewModel)

                        InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.xaxis")
                }

                        GuidedSessionsView()
                .tabItem {
                    Label("Sessions", systemImage: "sparkles")
                }
                .environmentObject(viewModel)
        }
        .tint(.brandPrimary) // Use accent color from branding
    }
}

#Preview {
    MainTabView()
}
