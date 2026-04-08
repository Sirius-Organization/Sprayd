import Foundation
import KeychainSwift

protocol SessionTokenStoring {
    @discardableResult
    func save(token: String) -> Bool

    func token() -> String?

    @discardableResult
    func clearToken() -> Bool
}

final class SessionTokenStore: SessionTokenStoring {
    private enum Keys {
        static let userToken = "userToken"
    }

    private let keychain: KeychainSwift

    init(keychain: KeychainSwift = KeychainSwift()) {
        self.keychain = keychain
    }

    func save(token: String) -> Bool {
        keychain.set(token, forKey: Keys.userToken)
    }

    func token() -> String? {
        keychain.get(Keys.userToken)
    }

    func clearToken() -> Bool {
        keychain.delete(Keys.userToken)
    }
}
