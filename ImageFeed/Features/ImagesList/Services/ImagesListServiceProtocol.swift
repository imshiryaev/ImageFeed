import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }

    func fetchPhotosNextPage(token: String) async throws
    func changeLike(photoId: String, isLike: Bool, token: String) async throws
}
