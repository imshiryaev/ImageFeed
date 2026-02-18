import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let tokenStorage = OAuth2TokenStorage()
    private let decoder = JSONDecoder()
    
    
    private init(){
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request, completion: { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let token = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = token.accessToken
                    completion(.success(token.accessToken))
                    
                    #if DEBUG
                    Log(.debug, "Successfully decoded access token")
                    #endif
                } catch {
                    completion(.failure(NetworkError.decodingError(error)))
                    Log(.error, "Decoding failed: \(error)")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
        
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashOauthTokenURLString) else {
            Log(.error, "Invalid OAuth token URL string: \(Constants.unsplashOauthTokenURLString)")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
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
