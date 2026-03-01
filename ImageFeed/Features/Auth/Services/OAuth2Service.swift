import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()

    private let tokenStorage = OAuth2TokenStorage()

    private var lastTask: URLSessionTask? = nil
    private var lastCode: String? = nil

    private init() {}

    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)

        guard lastTask == nil else {
            Log(.error, "Fetch token already in progress")
            return
        }

        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        lastTask?.cancel()
        lastCode = code

        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = URLSession.shared.data(
            for: request,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    guard let self else { return }

                    defer {
                        self.lastTask = nil
                        self.lastCode = nil
                    }
                    self.handleOAuthTokenResponse(result, completion: completion)
                }
                #if DEBUG
                    Log(.debug, "Successfully send request")
                #endif
            }
        )
        self.lastTask = task
        task.resume()
    }

    func handleOAuthTokenResponse(
        _ result: Result<Data, Error>,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        switch result {
        case .success(let data):
            do {
                let token = try JSONDecoder.snakeCase.decode(
                    OAuthTokenResponseBody.self,
                    from: data
                )
                self.tokenStorage.setToken(token.accessToken)
                completion(.success(token.accessToken))

                #if DEBUG
                    Log(.debug, "Successfully decoded access token")
                #endif
            } catch {
                completion(
                    .failure(NetworkError.decodingError(error))
                )
                Log(.error, "Decoding failed: \(error)")
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard
            var urlComponents = URLComponents(
                string: API.Endpoints.unsplashOauthTokenURLString
            )
        else {
            Log(
                .error,
                "Invalid OAuth token URL string: \(API.Endpoints.unsplashOauthTokenURLString)"
            )
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: API.keys.accessKey),
            URLQueryItem(name: "client_secret", value: API.keys.secretKey),
            URLQueryItem(name: "redirect_uri", value: API.keys.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let url = urlComponents.url else {
            Log(.error, "Invalid URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
