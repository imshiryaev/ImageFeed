import Foundation

protocol AuthHelperProtocol {

    func makeRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    private let apiConfiguration: ApiConfiguration

    init(apiConfiguration: ApiConfiguration = .standart) {
        self.apiConfiguration = apiConfiguration
    }
    
    func code(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.host == "unsplash.com",
            urlComponents.path == "/oauth/authorize/native",
            let item = urlComponents.queryItems?.first(where: { $0.name == "code" })
        else {
            #if DEBUG
                Log(
                    .debug,
                    "No OAuth code found in navigation URL — probably a regular page load \(url.absoluteString)"
                )
            #endif
            return nil
        }
        #if DEBUG
            Log(.debug, "Successfully extracted OAuth code")
        #endif

        return item.value
    }

    func makeRequest() -> URLRequest {
        URLRequestBuilder(baseURL: apiConfiguration.unsplashAuthorizeURLString)
            .queryItems([
                URLQueryItem(name: "client_id", value: apiConfiguration.accessKey),
                URLQueryItem(name: "redirect_uri", value: apiConfiguration.redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: apiConfiguration.accessScope),
            ])
            .build()
    }
}
