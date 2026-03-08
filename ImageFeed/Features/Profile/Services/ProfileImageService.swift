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

    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: API.Endpoints.defaultBaseURLString) else {
            return nil
        }
        urlComponents.path = "/users/\(username)"

        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchAsyncProfileImage(username: String) async throws {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            Log(.error, "Token is empty")
            throw NetworkError.invalidRequest
        }
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            throw NetworkError.invalidRequest
        }

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
}
