enum SerieEndpoint {
    case episodes(id: Int)
}

extension SerieEndpoint: ApiEndpointExposable {
    var path: String {
        if case let .episodes(id) = self {
            return "/shows/\(id)/episodes"
        }
        return String()
    }
    
    var method: HTTPMethod {
        .get
    }
}
