import Foundation

protocol HasApi {
    var api: ApiProtocol { get }
}

protocol ApiProtocol {
    @discardableResult
    func execute<E: Decodable>(
        endpoint: ApiEndpointExposable,
        session: URLSessionable,
        jsonDecoder: JSONDecoder,
        completion: @escaping (Result<Success<E>, ApiError>) -> Void
    ) -> URLSessionDataTaskable?
}

extension ApiProtocol {
    @discardableResult
    func execute<E: Decodable>(
        endpoint: ApiEndpointExposable,
        session: URLSessionable = DependencyContainer().session,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<Success<E>, ApiError>) -> Void
    ) -> URLSessionDataTaskable? {
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
