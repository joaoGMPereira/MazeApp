import Foundation

protocol HasURLSessionable {
    var session: URLSessionable { get }
}

protocol URLSessionable {
    func task(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable
}

extension URLSession: URLSessionable {
    func task(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskable {
        dataTask(with: request, completionHandler: completionHandler)
    }
}

protocol URLSessionDataTaskable {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskable {}
