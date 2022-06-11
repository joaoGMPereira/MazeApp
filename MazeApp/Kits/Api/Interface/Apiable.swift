import Foundation

protocol Apiable {
    @discardableResult
    func execute<E: Decodable>(
        endpoint: ApiEndpointExposable,
        session: URLSessionable,
        jsonDecoder: JSONDecoder,
        completion: @escaping (Result<Success<E>, ApiError>) -> Void
    ) -> URLSessionTask?
}

extension Apiable {
    @discardableResult
    func execute<E: Decodable>(
        endpoint: ApiEndpointExposable,
        session: URLSessionable = DependencyContainer().session,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<Success<E>, ApiError>) -> Void
    ) -> URLSessionTask? {
        execute(endpoint: endpoint,
                session: session,
                jsonDecoder: jsonDecoder,
                completion: completion)
    }
}

struct Success<T: Decodable> {
    let model: T
    let data: Data?
}
