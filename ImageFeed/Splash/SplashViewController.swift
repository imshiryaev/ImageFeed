import UIKit

final class SplashViewController: UIViewController {

    private let storage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if storage.token != nil {
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
}
