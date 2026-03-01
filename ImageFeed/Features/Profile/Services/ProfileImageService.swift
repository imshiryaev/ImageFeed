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

    func fetchProfileImage(_ username: String, completion: @escaping (Result<UserResult, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = URLSession.shared.data(
            for: request,
            completion: { [weak self] result in
                guard let self else {
                    return
                }
                self.handleProfileImageResponce(result, completion: completion)
            }
        )
        task.resume()
    }

    func handleProfileImageResponce(
        _ result: Result<Data, Error>,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) {
        switch result {
        case .success(let data):
            do {
                let user = try JSONDecoder.snakeCase.decode(UserResult.self, from: data)
                self.avatarURL = user.profileImage.small
                guard let avatarURL else {
                    return
                }
                completion(.success(user))
            } catch {
                Log(.error, "Decoding failed: \(error)")
                completion(.failure(error))
            }
        case .failure(let error):
            Log(.error, "Fail: \(error)")
            completion(.failure(error))
        }
    }
    
}
