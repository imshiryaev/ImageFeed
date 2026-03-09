import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get }
    func setToken(_ newValue: String)
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {

    static let shared = OAuth2TokenStorage()

    private let storage = KeychainWrapper.standard

    private enum Keys: String {
        case token
    }

    private init() {}

    var token: String? {
        storage.string(forKey: Keys.token.rawValue)
    }

    func setToken(_ newValue: String) {
        storage.set(newValue, forKey: Keys.token.rawValue)
    }
}
