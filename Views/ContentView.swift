import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: MoodLoggingViewModel
    @State private var showingSettings = false

    private var currentEmoji: String {
        switch viewModel.moodScore {
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
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Text("Wie fühlst du dich heute?")
                            .font(.custom("Montserrat-Bold", size: 28))
                            .foregroundColor(.primary)
                            .padding(.horizontal)

                        VStack {
                            Text(currentEmoji)
                                .font(.system(size: 70))
                                .padding(.vertical, 10)

                            Slider(value: $viewModel.moodScore, in: 0...4, step: 0.1)
                                .accentColor(.green)
                                .tint(.brandPrimary)
                        }
                        .padding(20)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notiz hinzufügen")
                                .font(.custom("Montserrat-Bold", size: 16))
                                .foregroundColor(.textSecondary)
                            
                            TextEditor(text: $viewModel.note)
                                .frame(height: 120)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.custom("Montserrat-Bold", size: 16))
                                .foregroundColor(.textSecondary)
                            
                            TextField("z.B. #Dankbarkeit, #Stress", text: $viewModel.tagsText)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        Button(action: viewModel.saveCurrentMood) {
                            Text("Eintrag speichern")
                                .font(.custom("Montserrat-Bold", size: 18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brandPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .padding(.vertical)
                    }
                    .padding()
                }
            }
            .navigationTitle("Heute")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.brandPrimary)
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Fertig") {
                        hideKeyboard()
                    }
                    .foregroundColor(.brandPrimary)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .accentColor(.brandPrimary)
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(MoodLoggingViewModel())
}
