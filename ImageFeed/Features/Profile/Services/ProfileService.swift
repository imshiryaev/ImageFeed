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

    func fetchAsyncProfile(token: String) async throws {
        guard let request = makeProfileRequest(token) else {
            throw NetworkError.invalidRequest
        }

        currentTask?.cancel()
        
        let task = Task {
            defer { currentTask = nil }
            
            let data = try await URLSession.shared.data(for: request)
            do {
                let decodedData = try JSONDecoder.snakeCase.decode(ProfileResult.self, from: data)

                let profile = ProfileViewModel(
                    loginName: "@\(decodedData.username)",
                    username: decodedData.username,
                    name: decodedData.firstName + " " + decodedData.lastName,
                    bio: decodedData.bio
                )
                self.profile = profile
            } catch {
                Log(.error, "Decoding failed: \(error)")
                throw NetworkError.decodingError(error)
            }
        }
        
        currentTask = task
        try await task.value
    }
    
    private func makeProfileRequest(_ bearer: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: API.Endpoints.defaultBaseURLString) else {
            Log(.error, "Invalid base URL")
            return nil
        }
        urlComponents.path = "/me"

        guard let url = urlComponents.url else {
            Log(.error, "Invalid URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        return request
    }
}
