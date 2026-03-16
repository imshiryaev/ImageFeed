import CoreGraphics
import Foundation

struct PhotoDto: Decodable {
    let id: String
    let createdAt: String
    let updatedAt: String
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

final class ImagesListService {
    private var photos: [Photo] = []

    private var lastLoadedPage: Int?
    private var currentTask: Task<Void, Error>?

    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    func fetchPhotosNextPage(token: String) async throws {
        if let task = currentTask {
            task.cancel()
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
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": photos]
                )
            }

        }

        currentTask = task
        try await task.value
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
}
