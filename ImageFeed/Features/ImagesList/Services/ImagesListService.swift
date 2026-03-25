import CoreGraphics
import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()

    private let useMock = true
    private(set) var photos: [Photo] = []

    private var lastLoadedPage: Int?
    private var currentTask: Task<Void, Error>?

    private init() {}

    func reset() {
        photos.removeAll()
    }

    func fetchPhotosNextPage(token: String) async throws {
        if let task = currentTask {
            task.cancel()
            currentTask = nil
        }

        let task = Task {
            defer { currentTask = nil }

            let nextPage = (lastLoadedPage ?? 0) + 1
            let request = makePhotosRequest(token: token, nextPage: nextPage)

            let data: [PhotoDto] = try await URLSession.shared.data(for: request)

            await MainActor.run {
                photos.append(contentsOf: data.map(\.toPhoto))

                lastLoadedPage = nextPage

                NotificationCenter.default.post(
                    name: .imagesListDidChange,
                    object: self,
                    userInfo: ["Photos": photos]
                )
            }

        }

        currentTask = task
        try await task.value
    }

    func changeLike(photoId: String, isLike: Bool, token: String) {
        Task {
            let request = makeLikePhotoRequest(photoId: photoId, isLike: isLike, token: token)

            _ = try await URLSession.shared.data(for: request)

            if let index = photos.firstIndex(where: { $0.id == photoId }) {
                photos[index].isLiked.toggle()

                NotificationCenter.default.post(
                    name: .imagesListDidChange,
                    object: self,
                    userInfo: ["photoId": photos[index].id]
                )
            }

        }
    }

    private func makePhotosRequest(token: String, nextPage: Int = 1, itemsPerPage: Int = 10) -> URLRequest {
        URLRequestBuilder(baseURL: API.Endpoint.defaultBaseURLString)
            .bearer(token)
            .queryItems([
                URLQueryItem(name: "page", value: "\(nextPage)"),
                URLQueryItem(name: "per_page", value: "\(itemsPerPage)"),
            ])
            .path(API.Path.photos)
            .build()
    }

    private func makeLikePhotoRequest(photoId: String, isLike: Bool, token: String) -> URLRequest {
        URLRequestBuilder(baseURL: API.Endpoint.defaultBaseURLString)
            .path(API.Path.like(photoId))
            .bearer(token)
            .method(isLike ? .delete : .post)
            .build()
    }
}
