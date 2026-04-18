import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func confirmProfileLogout()
    func updateProfileImage()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageObserver: NSObjectProtocol?

    func viewDidLoad() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)

        profileImageObserver = NotificationCenter.default.addObserver(
            forName: profileImageService.didChangeProfileImageURL,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateProfileImage()
            }
        )
        updateProfileImage()
    }

    func confirmProfileLogout() {
        self.profileLogoutService.logout()
        view?.switchToSplash()
    }

    func updateProfileImage() {
        guard let imageUrl = profileImageService.avatarURL,
            let url = URL(string: imageUrl)
        else {
            return
        }
        view?.updateProfileImage(url)
    }

}
