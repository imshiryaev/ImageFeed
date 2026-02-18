import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let storage: UserDefaults = .standard
    
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
