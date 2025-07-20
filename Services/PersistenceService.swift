import Foundation

class PersistenceService {
    private static let fileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("journalEntries.dat")
    }()

    static func saveEntries(_ entries: [JournalEntry]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(entries)
            
            guard let encryptedData = CryptoService.shared.encrypt(data: data) else {
                print("Encryption failed. Could not save entries.")
                return
            }
            
            try encryptedData.write(to: fileURL, options: .atomic)
            print("Successfully saved \(entries.count) encrypted entries.")
        } catch {
            print("Failed to save entries: \(error.localizedDescription)")
        }
    }

    static func loadEntries() -> [JournalEntry] {
        guard let encryptedData = try? Data(contentsOf: fileURL) else {
            print("No data file found. Starting fresh.")
            return []
        }

        guard let decryptedData = CryptoService.shared.decrypt(data: encryptedData) else {
            print("Decryption failed. Could not load entries. This might happen if the encryption key changed or data is corrupt.")
            return []
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let entries = try decoder.decode([JournalEntry].self, from: decryptedData)
            print("Successfully loaded and decrypted \(entries.count) entries.")
            return entries
        } catch {
            print("Failed to decode decrypted entries: \(error.localizedDescription)")
            return []
        }
    }
}
