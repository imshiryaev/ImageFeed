import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
}
extension URLSession {
    func data<T: Decodable>(for request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.urlSessionError
            }
            guard 200..<300 ~= statusCode else {
                Log(.error, NetworkError.httpStatusCode(statusCode).localizedDescription)
                throw NetworkError.httpStatusCode(statusCode)
            }

            return try JSONDecoder.snakeCase.decode(T.self, from: data)

        } catch let error as NetworkError {
            throw error

        } catch let error as DecodingError {
            Log(.error, "Decoding failed: \(error)")
            throw error

        } catch {
            Log(.error, "Ошибка: \(error.localizedDescription)")
            throw NetworkError.urlRequestError(error)
        }
    }
}
