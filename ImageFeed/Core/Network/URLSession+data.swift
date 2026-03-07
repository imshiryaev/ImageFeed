import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

extension URLSession {
    func data(for request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.urlSessionError
            }
            guard 200..<300 ~= statusCode else {
                throw NetworkError.httpStatusCode(statusCode)
            }

            return data

        } catch let error as NetworkError {
            throw error

        } catch {
            throw NetworkError.urlRequestError(error)
        }
    }
}
