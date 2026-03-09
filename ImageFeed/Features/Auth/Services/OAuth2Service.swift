import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()

    private let tokenStorage = OAuth2TokenStorage.shared

    private var currentTask: Task<Void, Error>?
    private var lastCode: String? = nil

    private init() {}

    func fetchAsyncOAuthToken(code: String) async throws {
        guard let request = makeOAuthTokenRequest(code: code), lastCode != code else {
            throw NetworkError.invalidRequest
        }

        currentTask?.cancel()

        defer { self.lastCode = nil }
        self.lastCode = code

        let task = Task {
            defer { self.currentTask = nil }

            let data: OAuthTokenResponseBody = try await URLSession.shared.data(for: request)
            self.tokenStorage.setToken(data.accessToken)
        }

        self.currentTask = task
        try await task.value
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
            URLQueryItem(name: "client_id", value: API.Keys.accessKey),
            URLQueryItem(name: "client_secret", value: API.Keys.secretKey),
            URLQueryItem(name: "redirect_uri", value: API.Keys.redirectURI),
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
