import UIKit

final class AuthViewController: UIViewController {
        
    private let authButton = UIButton()
    private let authLogo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        setupAuthButton()
        setupAuthLogo()
        setupBackButton()
    }
    
    private func setupAuthButton() {
        view.addSubview(authButton)
        authButton.setTitle("Войти", for: .normal)
        authButton.setTitleColor(.background, for: .normal)
        authButton.titleLabel?.font = Fonts.sfProDisplaytRegular17
        authButton.backgroundColor = .white
        authButton.layer.cornerRadius = 16
        authButton.addAction(
            UIAction { [weak self] _ in
                print("tap")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let webViewVC = storyboard.instantiateViewController(withIdentifier: "WebViewViewController")
                
                self?.navigationController?.pushViewController(webViewVC, animated: true)
            },
            for: .touchUpInside
        )
        
        authButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.heightAnchor.constraint(equalToConstant: 48),
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            authButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
        
    private func setupAuthLogo() {
        view.addSubview(authLogo)
        authLogo.image = UIImage(resource: .authScreenLogo)
        
        authLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authLogo.widthAnchor.constraint(equalToConstant: 60),
            authLogo.heightAnchor.constraint(equalToConstant: 60),
            authLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 236)
        ])
    }
    
    private func setupBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .back)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .back)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .background
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
