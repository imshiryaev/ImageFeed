import Kingfisher
import UIKit

final class SingleImageViewController: UIViewController {

    var imageUrl: URL?

    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()

        scrollView.addSubview(imageView)
        return imageView
    }()

    private lazy var backButton: UIButton = {
        var backButton = UIButton()
        view.addSubview(backButton)

        backButton.setImage(.back, for: .normal)
        backButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }

                self.dismiss(animated: true)
            },
            for: .touchUpInside
        )
        backButton.accessibilityIdentifier = "nav back button white"

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                backButton.widthAnchor.constraint(equalToConstant: 24),
                backButton.heightAnchor.constraint(equalToConstant: 24),
                backButton.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 8
                ),
                backButton.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 8
                ),
            ]
        )

        return backButton
    }()

    private lazy var shareButton: UIButton = {
        var shareButton = UIButton()
        view.addSubview(shareButton)

        shareButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                self.tapOnShareButton()
            },
            for: .touchUpInside
        )
        shareButton.setImage(.share, for: .normal)
        shareButton.backgroundColor = .background

        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -17
            ),
        ])

        shareButton.layoutIfNeeded()
        shareButton.layer.cornerRadius = shareButton.frame.height / 2

        return shareButton
    }()

    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentMode = .scaleToFill

        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadImage()
        navigationController?.navigationBar.isHidden = true
    }

    func setUpUI() {
        view.backgroundColor = .background
        _ = scrollView
        _ = imageView
        _ = backButton
        _ = shareButton
    }

    private func loadImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { result in
            switch result {
            case .success(let value):
                self.imageView.frame.size = value.image.size
                self.rescaleAndCenterImageInScrollView(image: value.image)
            case .failure: break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }

    func tapOnShareButton() {
        guard let image = imageView.image else { return }
        let activityItems: [Any] = [image]

        let share = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )

        present(share, animated: true)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    private func centerImageAfterZoom(image: UIImage) {
        let offsetX = max(
            (scrollView.bounds.width - scrollView.contentSize.width) * 0.5,
            0
        )
        let offsetY = max(
            (scrollView.bounds.height - scrollView.contentSize.height) * 0.5,
            0
        )

        scrollView.contentInset = UIEdgeInsets(
            top: offsetY,
            left: offsetX,
            bottom: 0,
            right: 0
        )
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat
    ) {
        guard let image = imageView.image else { return }
        centerImageAfterZoom(image: image)
    }
}
