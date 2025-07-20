import SwiftUI

struct JournalEntryDetailView: View {
    let entry: JournalEntry

    private var emoji: String {
        switch entry.moodScore {
        case 0..<1: return "😢"
        case 1..<2: return "😔"
        case 2..<3: return "😐"
        case 3..<4: return "😊"
        default: return "😄"
        }
    }

    var body: some View {
        ZStack {
            Color.uiBackground.edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header Card
                    VStack {
                        Text(emoji)
                            .font(.system(size: 70))
                        Text(entry.date.formatted(date: .complete, time: .shortened))
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.background)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)

                    // Note Section
                    if let note = entry.note, !note.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Gedanken & Erlebnisse")
                                .font(.custom("Montserrat-Bold", size: 20))
                                .foregroundColor(.textPrimary)
                            Text(note)
                                .font(.custom("Inter-Regular", size: 17))
                                .lineSpacing(5)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal)
                    }

                    // Tags Section
                    if let tags = entry.tags, !tags.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tags")
                                .font(.custom("Montserrat-Bold", size: 20))
                                .foregroundColor(.textPrimary)
                            
                            FlexibleView(data: tags) { tag in
                                Text("#\(tag)")
                                    .font(.custom("Inter-Regular", size: 14))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.brandAccent.opacity(0.5))
                                    .foregroundColor(.brandPrimary)
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(
          "Eintrag vom " +
          entry.date.formatted(
            .dateTime
              .day()                             // 20
              .month(.abbreviated)               // Jul
              .year()                            // 2025
          )
        ) 
    }
}

#Preview {
    NavigationView {
        JournalEntryDetailView(entry: JournalEntry(moodScore: 3.5, note: "Ein wirklich toller Tag! Ich habe viel geschafft und mich danach mit Freunden getroffen. Das Wetter war auch super.", tags: ["produktiv", "glücklich", "freunde", "sonne", "erfolg"]))
    }
}
