enum SeriesEndpoint {
    case episodes(id: Int)
}

extension SeriesEndpoint: ApiEndpointExposable {
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
