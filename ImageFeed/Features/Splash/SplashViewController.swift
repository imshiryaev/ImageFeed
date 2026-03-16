import UIKit

final class SplashViewController: UIViewController {

    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.image = UIImage(resource: .splash)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        _ = imageView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            let authViewVC = AuthViewController()

            authViewVC.delegate = self

            let navController = UINavigationController(rootViewController: authViewVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: false)
        }
    }

}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.navigationController?.popViewController(animated: true)

        guard let token = storage.token else { return }
        fetchProfile(token: token)
    }

    private func switchToTabBarController() {
        guard let window = view.window else {
            assertionFailure("Invalid window configuration")
            return
        }

        let tabBarController = TabBarController()

        window.rootViewController = tabBarController
    }

    func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()

        Task {
            defer { UIBlockingProgressHUD.dismiss() }

            do {
                try await self.profileService.fetchAsyncProfile(token: token)

                guard let profile = self.profileService.profile else {
                    Log(.error, "Profile is nil")
                    return
                }

                try await self.profileImageService.fetchAsyncProfileImage(
                    username: profile.username,
                    token: token
                )
                switchToTabBarController()
            } catch {
                Log(.error, "\(error)")
            }
        }
    }
}
