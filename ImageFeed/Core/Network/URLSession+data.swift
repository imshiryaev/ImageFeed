import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

extension URLSession {
    func data<T: Decodable>(for request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.urlSessionError
            }
            guard 200..<300 ~= statusCode else {
                throw NetworkError.httpStatusCode(statusCode)
            }

            do {
                return try JSONDecoder.snakeCase.decode(T.self, from: data)

            } catch {
                Log(.error, "Decoding failed: \(error)")
                throw NetworkError.decodingError(error)
            }

        } catch let error as NetworkError {
            throw error

        } catch {
            throw NetworkError.urlRequestError(error)
        }
    }
}
