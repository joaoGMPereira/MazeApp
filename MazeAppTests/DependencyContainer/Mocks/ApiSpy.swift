import Foundation
@testable import MazeApp

class ApiProtocolSpy: ApiProtocol {
    private(set) var requests: [ApiEndpointExposable] = []
    private(set) var responses: [Any] = []
    var response: Any?
    var error: ApiError?
    
    func execute<E: Decodable>(endpoint: ApiEndpointExposable, session: URLSessionable, jsonDecoder: JSONDecoder, completion: @escaping (Result<Success<E>, ApiError>) -> Void) -> URLSessionDataTaskable? {
        requests.append(endpoint)
        if let response = response as? E {
            responses.append(response)
            completion(.success(.init(model: response, data: nil)))
        }
        let error: ApiError = error ?? .unknown
        responses.append(error)
        completion(.failure(error))
        return URLSessionDataTaskableSpy()
    }
    
}

class URLSessionDataTaskableSpy: URLSessionDataTaskable {
    enum Messages: Equatable {
        case resume
        case cancel
    }
    
    private(set) var messages: [Messages] = []
    
    func resume() {
        messages.append(.resume)
    }
    
    func cancel() {
        messages.append(.cancel)
    }
    
}

class URLSessionableSpy: URLSessionable {
    enum Messages: AutoEquatable {
        case dataTask(URLRequest)
    }
    
    private(set) var messages: [Messages] = []
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    func task(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable {
        messages.append(.dataTask(request))
        completionHandler(data,urlResponse,error)
        return URLSessionDataTaskableSpy()
    }
}
