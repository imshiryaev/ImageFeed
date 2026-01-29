import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileFullName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var profileLogoutButton: UIButton!
    @IBAction func tapOnLogoutButton(_ sender: Any) {
    }
}
