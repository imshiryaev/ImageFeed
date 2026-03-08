import UIKit

final class SplashViewController: UIViewController {

    private let storage = OAuth2TokenStorage()
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
        
        _ = imageView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            switchToTabBarController()
            fetchProfile(token: token)

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
