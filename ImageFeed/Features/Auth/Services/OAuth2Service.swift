import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()

    private let tokenStorage = OAuth2TokenStorage.shared

    private var currentTask: Task<Void, Error>?
    private var lastCode: String? = nil

    private init() {}

    func fetchAsyncOAuthToken(code: String) async throws {
        let request = makeOAuthTokenRequest(code: code)
        
        guard lastCode != code else {
            return
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

    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        URLRequestBuilder(baseURL: API.Endpoint.unsplashOauthTokenURLString)
            .method(.post)
            .queryItems([
                URLQueryItem(name: "client_id", value: API.Key.accessKey),
                URLQueryItem(name: "client_secret", value: API.Key.secretKey),
                URLQueryItem(name: "redirect_uri", value: API.Key.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code"),
            ])
            .build()
    }

}
