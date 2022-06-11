import Foundation

protocol ApiEndpointExposable {
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var absoluteStringUrl: String { get }
    var contentType: ContentType { get }
}

extension ApiEndpointExposable {
    var method: HTTPMethod { .get }
    
    var baseURL: URL {
        guard let url = URL.init(string: "https://api.tvmaze.com") else {
            fatalError("You need to define the api url")
        }
        return url
    }

    var absoluteStringUrl: String {
        let basePathString = baseURL.absoluteString
        let safeBasePath = basePathString.hasSuffix("/") ? String(basePathString.dropLast()) : basePathString
        let safePath = path.starts(with: "/") || path.isEmpty ? path : "/\(path)"
        return "\(safeBasePath)\(safePath)"
    }
    
    var contentType: ContentType {
        .applicationJson
    }
    
    var parameters: [String: Any] {
        [:]
    }
}
