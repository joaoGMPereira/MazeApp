enum EpisodeEndpoint {
    case episode(show: String, season: String, episode: String)
}

extension EpisodeEndpoint: ApiEndpointExposable {
    var path: String {
        if case let .episode(show, season, episode) = self {
            return "/shows/\(show)/episodebynumber?season=\(season)&number=\(episode)"
        }
        return String()
    }
    
    var method: HTTPMethod {
        .get
    }
}
