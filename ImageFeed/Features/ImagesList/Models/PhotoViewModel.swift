import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let smallImageURL: String
    let regularImageURL: String
    var isLiked: Bool
    var aspectRatio: CGFloat { size.height / size.width }
}
