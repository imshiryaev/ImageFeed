import Foundation

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [Photo] = []
    
    func fetchPhotosNextPage(token: String) async throws {
                
        photos = MockData.photos
        
        NotificationCenter.default.post(
            name: .imagesListDidChange,
            object: self,
            userInfo: ["Photos": photos]
        )
    }
    
    func changeLike(photoId: String, isLike: Bool, token: String) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            photos[index].isLiked.toggle()
        }

    }
    
}
