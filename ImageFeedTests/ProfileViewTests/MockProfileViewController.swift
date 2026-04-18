import Foundation

@testable import ImageFeed

final class MockProfileViewController: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var updateProfileDetailsCalled = false
    var switchToSplashCalled = false
    var receivedImageURL: URL?

    func updateProfileDetails(profile: ProfileViewModel) {
        updateProfileDetailsCalled = true
    }

    func updateProfileImage(_ url: URL) {
        receivedImageURL = url
    }

    func switchToSplash() {
        switchToSplashCalled = true
    }
}
