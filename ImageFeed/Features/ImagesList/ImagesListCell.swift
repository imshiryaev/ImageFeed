import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!

    func configCell(data: ImagesListCellViewModel) {
        cellImage.image = data.image
        dateLabel.text = data.dateLabel

        let imageResource: ImageResource = data.isLiked ? .likeFilled : .likeEmpty
        likeButton.setImage(UIImage(resource: imageResource), for: .normal)
    }
}
