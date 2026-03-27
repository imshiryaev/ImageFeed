import Foundation
import CoreGraphics

struct PhotoDto: Decodable {
    let id: String
    let createdAt: Date
    let updatedAt: Date
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: PhotoUrlsDto

    var toPhoto: Photo {
        Photo(
            id: id,
            size: CGSize(width: width, height: height),
            createdAt: createdAt,
            welcomeDescription: description,
            thumbImageURL: urls.thumb,
            largeImageURL: urls.full,
            smallImageURL: urls.small,
            regularImageURL: urls.regular,
            isLiked: likedByUser
        )
    }
}

struct PhotoUrlsDto: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
