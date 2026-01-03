import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!

    func configCell(data: ImagesListCellViewModel) {
        cellImage.image = data.image
        dateLabel.text = data.dateLabel

        data.isLiked ? likeButton.setImage(UIImage(named: "likeFilled"), for: .normal) : likeButton.setImage(UIImage(named: "likeEmpty"), for: .normal)
    }
}

struct ImagesListCellViewModel {
    let image: UIImage?
    let dateLabel: String
    let isLiked: Bool
}
