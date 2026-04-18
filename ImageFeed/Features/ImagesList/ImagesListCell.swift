import Kingfisher
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    var onTapLikeButton: (() -> Void)?

    private(set) var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            self?.onTapLikeButton?()
        }, for: .touchUpInside)
        return button
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        [cellImage, likeButton, dateLabel].forEach { contentView.addSubview($0) }
        backgroundColor = .white
        contentView.backgroundColor = .background
        contentView.layer.borderColor = UIColor.red.cgColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Cell Image
            cellImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),

            // Date Label
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),

            // Like Button
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
        ])
    }
    
    func setLikeButtonEnabled(_ isEnabled: Bool) {
        likeButton.isEnabled = isEnabled
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }

    func configCell(data: ImagesListCellViewModel) {
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: URL(string: data.imageUrl),
            placeholder: UIImage(resource: .placeholder)
        )
        dateLabel.text = data.dateLabel

        let likeImage = data.isLiked ? UIImage(resource: .likeFilled) : UIImage(resource: .likeEmpty)
        let accessibilityIdentifier = data.isLiked ? "like button on" : "like button off"
        
        likeButton.accessibilityIdentifier = accessibilityIdentifier
        likeButton.setImage(likeImage, for: .normal)
    }
}
