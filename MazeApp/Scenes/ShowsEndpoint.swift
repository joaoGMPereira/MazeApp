enum ShowsEndpoint {
    case list(page: Int, search: String)
}

extension ShowsEndpoint: ApiEndpointExposable {
    var path: String {
        if case let .list(page, search) = self {
            if search.isNotEmpty {
                return "/search/shows?q=\(search)"
            }
            return "/shows?page=\(page)"
        }
        return String()
    }
    
    var method: HTTPMethod {
        .get
    }
}
