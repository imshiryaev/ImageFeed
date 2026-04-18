import Kingfisher
import UIKit

protocol ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfileDetails(profile: ProfileViewModel)
    func switchToSplash()
    func updateProfileImage(_ url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: (any ProfileViewPresenterProtocol)?

    private var profileImageView = UIImageView()
    private let profileName = UILabel()
    private let profileUsername = UILabel()
    private let profileDescription = UILabel()
    private let profileExitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        setupProfileImage()
        setupProfileName()
        setupProfileUsername()
        setupProfileDescription()
        setupExitProfileButton()

        view.backgroundColor = .background
    }

    func updateProfileImage(_ url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImageView.kf.setImage(with: url, options: [.processor(processor)])
    }

    func updateProfileDetails(profile: ProfileViewModel) {
        profileName.text = profile.name
        profileUsername.text = profile.loginName
        profileDescription.text = profile.bio
    }

    private func setupProfileImage() {
        let image = UIImage(resource: .profileDefault)

        profileImageView = UIImageView(image: image)

        view.addSubview(profileImageView)

        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                profileImageView.widthAnchor.constraint(equalToConstant: 70),
                profileImageView.heightAnchor.constraint(equalToConstant: 70),
                profileImageView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 32
                ),
                profileImageView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
            ]
        )

    }

    private func setupProfileName() {
        view.addSubview(profileName)
        profileName.font = Fonts.sfProDisplaytBold23
        profileName.textColor = .white
        profileName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                profileName.topAnchor.constraint(
                    equalTo: profileImageView.bottomAnchor,
                    constant: 8
                ),
                profileName.leadingAnchor.constraint(
                    equalTo: profileImageView.leadingAnchor
                ),
            ]
        )
    }

    private func setupProfileUsername() {
        view.addSubview(profileUsername)
        profileUsername.text = "@username"
        profileUsername.textColor = UIColor(resource: .gray)
        profileUsername.font = Fonts.sfProDisplaytRegular13

        profileUsername.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                profileUsername.topAnchor.constraint(
                    equalTo: profileName.bottomAnchor,
                    constant: 8
                ),
                profileUsername.leadingAnchor.constraint(
                    equalTo: profileImageView.leadingAnchor
                ),
            ]
        )
    }

    private func setupProfileDescription() {
        view.addSubview(profileDescription)
        profileDescription.text = "Hello World!"
        profileDescription.textColor = .white
        profileDescription.font = Fonts.sfProDisplaytRegular13

        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                profileDescription.topAnchor.constraint(
                    equalTo: profileUsername.bottomAnchor,
                    constant: 8
                ),
                profileDescription.leadingAnchor.constraint(
                    equalTo: profileImageView.leadingAnchor
                ),
            ]
        )
    }

    private func setupExitProfileButton() {
        view.addSubview(profileExitButton)
        profileExitButton.setImage(.logoutButton, for: .normal)
        profileExitButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let confirmLogoutAlert = UIAlertController(
                    title: "Выход",
                    message: "Уверены что хотите выйти?",
                    preferredStyle: .alert
                )
                confirmLogoutAlert.addAction(
                    UIAlertAction(title: "Да", style: .default) { _ in
                        self.presenter?.confirmProfileLogout()

                    }
                )
                confirmLogoutAlert.addAction(UIAlertAction(title: "Нет", style: .cancel))

                present(confirmLogoutAlert, animated: true)
            },
            for: .touchUpInside
        )

        profileExitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                profileExitButton.widthAnchor.constraint(equalToConstant: 24),
                profileExitButton.heightAnchor.constraint(equalToConstant: 24),
                profileExitButton.centerYAnchor.constraint(
                    equalTo: profileImageView.centerYAnchor
                ),
                profileExitButton.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16
                ),
            ]
        )
    }

    func switchToSplash() {
        guard let window = self.view.window else {
            assertionFailure("Invalid window configuration")
            return
        }
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
    }

}
