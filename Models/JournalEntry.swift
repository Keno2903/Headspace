import Foundation

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var moodScore: Double // 0.0 (worst) to 4.0 (best)
    var note: String? = nil
    var tags: [String]? = nil

    init(id: UUID = UUID(), date: Date = Date(), moodScore: Double, note: String? = nil, tags: [String]? = nil) {
        self.id = id
        self.date = date
        self.moodScore = moodScore
        self.note = note
        self.tags = tags
    }
}
