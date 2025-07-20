import SwiftUI

struct GuidedSessionsView: View {
    let prompts = PromptService.getPrompts()

    var body: some View {
        NavigationView {
            List(prompts) { prompt in
                NavigationLink(destination: PromptResponseView(prompt: prompt)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(prompt.title)
                            .font(.custom("Montserrat-Bold", size: 20))
                            .foregroundColor(.brandPrimary)
                        Text(prompt.prompt)
                            .font(.custom("Inter-Regular", size: 15))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 10)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Geführte Sessions")
        }
    }
}

struct PromptResponseView: View {
    let prompt: JournalPrompt
    @EnvironmentObject var viewModel: MoodLoggingViewModel
    @State private var note: String = ""
    @State private var tagsText: String = ""
    @State private var moodScore: Double = 2.0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(prompt.prompt)
                .font(.custom("Inter-Regular", size: 18))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)

            TextEditor(text: $note)
                .frame(minHeight: 150)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))

            TextField("Tags (optional, getrennt durch Komma)", text: $tagsText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            HStack {
                Text("Stimmung:")
                Slider(value: $moodScore, in: 0...4, step: 0.1)
                    .accentColor(.green)
            }

            Button(action: saveEntry) {
                Text("Eintrag speichern")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(prompt.title)
    }

    private func saveEntry() {
        viewModel.note = note
        viewModel.tagsText = tagsText
        viewModel.moodScore = moodScore
        viewModel.saveCurrentMood()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    GuidedSessionsView()
        .environmentObject(MoodLoggingViewModel())
}
