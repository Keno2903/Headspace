import Foundation
import Combine

class MoodLoggingViewModel: ObservableObject {
    @Published var moodScore: Double = 2.0 // Default to neutral
    @Published var journalEntries: [JournalEntry] = []
    @Published var note: String = ""
    @Published var tagsText: String = ""
    @Published var dailyAverageMoods: [Date: Double] = [:]
    @Published var tagFrequencies: [String: Int] = [:]

    init() {
        loadEntries()
    }

    func saveCurrentMood() {
        let tags = tagsText.split(whereSeparator: { $0.isWhitespace || $0 == "," }).map { String($0) }
        let newEntry = JournalEntry(moodScore: moodScore, note: note.isEmpty ? nil : note, tags: tags.isEmpty ? nil : tags)
        journalEntries.append(newEntry)
        journalEntries.sort(by: { $0.date > $1.date }) // Keep the list sorted

        PersistenceService.saveEntries(journalEntries)
        updateAnalytics()
        print("New entry saved and persisted. Total entries: \(journalEntries.count)")

        // Reset fields
        moodScore = 2.0
        note = ""
        tagsText = ""
    }

    private func loadEntries() {
        self.journalEntries = PersistenceService.loadEntries().sorted(by: { $0.date > $1.date })
        print("Loaded \(journalEntries.count) entries from disk.")
        updateAnalytics()
    }

    private func updateAnalytics() {
        updateDailyAverages()
        updateTagFrequencies()
    }

    private func updateDailyAverages() {
        let groupedByDay = Dictionary(grouping: journalEntries) { entry in
            Calendar.current.startOfDay(for: entry.date)
        }

        var averages: [Date: Double] = [:]
        for (date, entries) in groupedByDay {
            let totalScore = entries.reduce(0) { $0 + $1.moodScore }
            averages[date] = totalScore / Double(entries.count)
        }

        self.dailyAverageMoods = averages
        print("Updated daily averages. \(dailyAverageMoods.count) days with data.")
    }

    private func updateTagFrequencies() {
        let allTags = journalEntries.compactMap { $0.tags }.flatMap { $0 }
        tagFrequencies = allTags.reduce(into: [:]) { counts, tag in
            counts[tag, default: 0] += 1
        }
        print("Updated tag frequencies. \(tagFrequencies.count) unique tags.")
    }
}
