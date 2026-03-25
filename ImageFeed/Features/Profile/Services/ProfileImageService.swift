import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImageViewModel
}

struct ProfileImageViewModel: Decodable {
    let small: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}

    private(set) var avatarURL: String?
    private var currentTask: Task<Void, Error>?

    static let didChangeProfileImageURL = Notification.Name("ProfileImageProviderDidChange")
    
    func reset() {
        avatarURL = nil
    }

    func fetchAsyncProfileImage(username: String, token: String) async throws {
        let request = makeProfileImageRequest(username: username, token: token)

        currentTask?.cancel()

        let task = Task {
            defer { currentTask = nil }

            let data: UserResult = try await URLSession.shared.data(for: request)
            self.avatarURL = data.profileImage.small

            NotificationCenter.default.post(
                name: ProfileImageService.didChangeProfileImageURL,
                object: self,
                userInfo: ["URL": data.profileImage.small]
            )
        }

        currentTask = task
        try await task.value
    }

    private func makeProfileImageRequest(username: String, token: String) -> URLRequest {
        URLRequestBuilder(baseURL: API.Endpoint.defaultBaseURLString)
            .bearer(token)
            .path(API.Path.users(username))
            .build()
    }

}
