import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared

    private init() {}

    func logout() {
        cleanCookies()
        cleanKeychain()
        cleanData()
    }
    
    private func cleanData() {
        profileService.reset()
        profileImageService.reset()
        imagesListService.reset()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
            records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {}
                )
            }
        }
    }
    
    private func cleanKeychain() {
        storage.removeToken()
    }
}
