import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}

    private(set) var profile: ProfileViewModel?

    private var currentTask: Task<Void, Error>?
    
    func reset() {
        profile = nil
    }

    func fetchAsyncProfile(token: String) async throws {
        let request = makeProfileRequest(token)
        
        currentTask?.cancel()

        let task = Task {
            defer { currentTask = nil }

            let data: ProfileResult = try await URLSession.shared.data(for: request)

            let profile = ProfileViewModel(
                loginName: "@\(data.username)",
                username: data.username,
                name: data.firstName + " " + data.lastName,
                bio: data.bio
            )
            self.profile = profile
        }

        currentTask = task
        try await task.value
    }

    private func makeProfileRequest(_ token: String) -> URLRequest {
        URLRequestBuilder(baseURL: API.Endpoint.defaultBaseURLString)
            .bearer(token)
            .path(API.Path.me)
            .build()
    }
}
