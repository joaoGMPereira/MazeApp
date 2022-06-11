enum ShowsEndpoint {
    case list(page: Int, search: String)
    case serieEpisodes(id: Int)
}

extension ShowsEndpoint: ApiEndpointExposable {
    var path: String {
        if case let .list(page, search) = self {
            if search.isNotEmpty {
                return "/search/shows?q=\(search)"
            }
            return "/shows?page=\(page)"
        }
        if case let .serieEpisodes(id) = self {
            return "/shows/\(id)/episodes"
        }
        return String()
    }
    
    var method: HTTPMethod {
        .get
    }
}
