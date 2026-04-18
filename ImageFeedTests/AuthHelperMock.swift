import Foundation

@testable import ImageFeed

final class AuthHelperMock: AuthHelperProtocol {
    func makeRequest() -> URLRequest {
        guard let url = URL(string: "https://example.com") else {
            fatalError("Invalid URL")
        }
        return URLRequest(url: url)
    }

    func code(from url: URL) -> String? {
        nil
    }

}
