import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class URLRequestBuilder {
    private var baseURL: String
    private var method: HTTPMethod = .get
    private var path: String = ""
    private var queryItems: [URLQueryItem]?
    private var headers: [String: String]?

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func method(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    func path(_ path: String) -> Self {
        self.path = path
        return self
    }

    func queryItems(_ items: [URLQueryItem]) -> Self {
        self.queryItems = items
        return self
    }

    func headers(_ headers: [String: String]) -> Self {
        var currentHeaders = self.headers ?? [:]
        headers.forEach({ currentHeaders[$0] = $1 })
        self.headers = currentHeaders
        return self
    }

    func bearer(_ token: String) -> Self {
        headers(["Authorization": "Bearer \(token)"])
    }

    func build() -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            Log(.error, "Invalid baseURL")
            fatalError("Invalid baseURL")
        }

        if !path.isEmpty {
            urlComponents.path = path
        }
        
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            Log(.error, "Invalid URL in URLComponents")
            fatalError("Invalid baseURL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
