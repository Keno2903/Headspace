import Foundation
import CryptoKit
import Security

class CryptoService {
    static let shared = CryptoService()
    private let keyTag = "com.eunoia.encryptionKey".data(using: .utf8)!

    private var encryptionKey: SymmetricKey? {
        // First, try to retrieve the key from the Keychain
        if let existingKey = retrieveKey() {
            return existingKey
        }

        // If no key exists, create a new one and store it
        let newKey = SymmetricKey(size: .bits256)
        guard storeKey(newKey) else {
            print("Failed to store new encryption key.")
            return nil
        }
        return newKey
    }

    private init() {}

    func encrypt(data: Data) -> Data? {
        guard let key = encryptionKey else { return nil }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            print("Encryption failed: \(error.localizedDescription)")
            return nil
        }
    }

    func decrypt(data: Data) -> Data? {
        guard let key = encryptionKey else { return nil }
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return decryptedData
        } catch {
            print("Decryption failed: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Keychain Management

    private func storeKey(_ key: SymmetricKey) -> Bool {
        let keyData = key.withUnsafeBytes { Data(Array($0)) }

        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrAccount as String: "EunoiaAppKey",
            kSecAttrApplicationTag as String: keyTag,
            kSecValueData as String: keyData
        ]

        // First, delete any existing key
        SecItemDelete(query as CFDictionary)

        // Then, add the new key
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private func retrieveKey() -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrAccount as String: "EunoiaAppKey",
            kSecAttrApplicationTag as String: keyTag,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let keyData = item as? Data else {
            return nil
        }

        return SymmetricKey(data: keyData)
    }
}
