import Kingfisher
import UIKit

final class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private var photos: [Photo] = []
    private var imageListViewObserver: NSObjectProtocol?
    private let imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    private let storage = OAuth2TokenStorage.shared

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setUpTabBar()

        imageListViewObserver = NotificationCenter.default.addObserver(
            forName: .imagesListDidChange,
            object: nil,
            queue: .main,
            using: { [weak self] notifiacion in
                guard let self else { return }
                self.updateImagesListPhotos(notifiacion)
            }
        )
        fetchPhotos()
    }

    private func updateImagesListPhotos(_ notificaton: Notification) {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos

        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        } else {
            guard let userInfo = notificaton.userInfo else { return }
            let id = userInfo["photoId"] as? String
            
            guard let index = photos.firstIndex(where: { $0.id == id }) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? ImagesListCell {
                cell.setLikeButtonEnabled(true)
            }
        }
    }

    private func fetchPhotos() {
        Task {
            guard let token = OAuth2TokenStorage.shared.token else { return }
            try await imagesListService.fetchPhotosNextPage(token: token)
        }
    }

    private func setUpTabBar() {
        guard let tabBar = tabBarController?.tabBar else { return }

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }

}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            )
                as? ImagesListCell
        else { return UITableViewCell() }

        let imageUrl = photos[indexPath.row].regularImageURL
        let isLiked = photos[indexPath.row].isLiked
        let date = dateFormatter.string(from: photos[indexPath.row].createdAt)

        let cellData = ImagesListCellViewModel(
            imageUrl: imageUrl,
            dateLabel: date,
            isLiked: isLiked,
        )

        cell.configCell(data: cellData)

        cell.onTapLikeButton = { [weak self] in
            guard let self, let token = storage.token else { return }
            
            cell.setLikeButtonEnabled(false)

            let current = self.photos[indexPath.row]
            
            self.imagesListService.changeLike(photoId: current.id, isLike: current.isLiked, token: token)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right

        let cellHeight =
            imageViewWidth * photos[indexPath.row].aspectRatio + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageVC = SingleImageViewController()
        let imageUrl = URL(string: photos[indexPath.row].largeImageURL)

        singleImageVC.imageUrl = imageUrl
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            fetchPhotos()
        }
    }
}
