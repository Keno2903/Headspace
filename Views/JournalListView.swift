import SwiftUI

struct JournalListView: View {
    @EnvironmentObject var viewModel: MoodLoggingViewModel

    private func emoji(for score: Double) -> String {
        switch score {
        case 0..<1: return "😢"
        case 1..<2: return "😔"
        case 2..<3: return "😐"
        case 3..<4: return "😊"
        default: return "😄"
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.uiBackground.edgesIgnoringSafeArea(.all)
                
                if viewModel.journalEntries.isEmpty {
                    VStack {
                        Image(systemName: "book.closed")
                            .font(.system(size: 50))
                            .foregroundColor(.textSecondary)
                        Text("Dein Tagebuch ist leer")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.top)
                        Text("Deine Einträge erscheinen hier, sobald du sie speicherst.")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.journalEntries) { entry in
                                NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
                                    JournalEntryRow(entry: entry)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Tagebuch")
        }
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry
    
    private func emoji(for score: Double) -> String {
        switch score {
        case 0..<1: return "😢"
        case 1..<2: return "😔"
        case 2..<3: return "😐"
        case 3..<4: return "😊"
        default: return "😄"
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Text(emoji(for: entry.moodScore))
                .font(.system(size: 40))
                .padding(10)
                .background(Color.uiBackground)
                .cornerRadius(15)

            VStack(alignment: .leading) {
                Text(entry.date.formatted(date: .long, time: .omitted))
                    .font(.custom("Montserrat-Bold", size: 16))
                    .foregroundColor(.textPrimary)
                Text(entry.date.formatted(date: .omitted, time: .shortened))
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.textSecondary)
        }
        .padding()
        .background(Color.background)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    JournalListView()
        .environmentObject(MoodLoggingViewModel())
}
