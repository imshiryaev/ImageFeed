import UIKit

final class SplashViewController: UIViewController {

    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {

            fetchProfile(token: token)
            switchToTabBarController()

        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authViewVC =
                storyboard.instantiateViewController(
                    withIdentifier: "AuthViewController"
                ) as? AuthViewController

            guard let authViewVC else { return }

            authViewVC.delegate = self
            navigationController?.pushViewController(
                authViewVC,
                animated: false
            )
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.navigationController?.popViewController(animated: true)

        guard let token = storage.token else { return }
        fetchProfile(token: token)
        switchToTabBarController()
    }

    private func switchToTabBarController() {
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive })
                as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else {
            assertionFailure("Invalid window configuration")
            return
        }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }

    func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(
            token,
            completion: { profile in
                UIBlockingProgressHUD.dismiss()
                switch profile {
                case .success(let profle):
                    self.profileImageService.fetchProfileImage(profle.username, completion: {_ in })
                    Log(.info, "Succesfull request")
                case .failure:
                    Log(.error, "Error")
                }
            }
        )
    }

}
