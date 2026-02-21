import Foundation

protocol OAuth2TokenStorageProtocol {
    var token: String? { get }
    func setToken(_ newValue: String)
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {

    private enum Keys: String {
        case token
    }

    private let storage: UserDefaults = .standard

    var token: String? {
        storage.string(forKey: Keys.token.rawValue)
    }

    func setToken(_ newValue: String) {
        storage.set(newValue, forKey: Keys.token.rawValue)
    }
}
