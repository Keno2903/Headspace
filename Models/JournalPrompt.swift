import Foundation

struct JournalPrompt: Identifiable {
    let id = UUID()
    let title: String
    let prompt: String
}
