import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

final class ProfileService {
    private var lastTask: URLSessionTask?

    private(set) var profile: ProfileViewModel?

    static let shared = ProfileService()
    private init() {}

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

    func fetchProfile(
        _ bearer: String,
        completion: @escaping (Result<ProfileViewModel, Error>) -> Void
    ) {
        guard let request = makeProfileRequest(bearer) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        lastTask?.cancel()
        
        let task = URLSession.shared.data(
            for: request,
            completion: { [weak self] result in
                guard let self else { return }

                defer {
                    lastTask = nil
                }
                DispatchQueue.main.async {
                    self.handleProfileResponse(result, completion: completion)
                }
            }
        )
        lastTask = task
        task.resume()
    }

    private func handleProfileResponse(
        _ result: Result<Data, Error>,
        completion: @escaping (Result<ProfileViewModel, Error>) -> Void
    ) {
        switch result {
        case .success(let data):
            do {
                let decodedData = try JSONDecoder.snakeCase.decode(ProfileResult.self, from: data)

                let profile = ProfileViewModel(
                    loginName: "@\(decodedData.username)",
                    username: decodedData.username,
                    name: decodedData.firstName + " " + decodedData.lastName,
                    bio: decodedData.bio
                )
                self.profile = profile
                completion(.success(profile))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
                Log(.error, "Decoding failed: \(error)")
            }
        case .failure(let error):
            completion(.failure(error))
            return
        }
    }
}
