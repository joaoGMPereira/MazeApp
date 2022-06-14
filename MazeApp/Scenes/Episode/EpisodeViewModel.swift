import Foundation

public protocol EpisodeViewModeling: AnyObject {
    func loadScreen()
}

final class EpisodeViewModel {
    typealias Dependencies = HasApi
    private let dependencies: Dependencies
    private let coordinator: EpisodeCoordinating
    weak var displayer: EpisodeDisplaying?
    
    private var episode: Episode?
    private(set) var sections: [String] = [String(), "Episodes"]
    private let show: String
    private let season: String
    private let episodeId: String
    
    init(coordinator: EpisodeCoordinating,
         dependencies: Dependencies,
         show: String,
         season: String,
         episodeId: String) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        self.show = show
        self.season = season
        self.episodeId = episodeId
    }
}

// MARK: - EpisodesViewModeling
extension EpisodeViewModel: EpisodeViewModeling {
    func loadScreen() {
        displayer?.displayLoad()
        dependencies.api.execute(endpoint: EpisodeEndpoint.episode(show: show,
                                                                   season: season,
                                                                   episode: episodeId)) { [weak self] (result: Result<Success<Episode>, ApiError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.episode = response.model
            case .failure:
                self.displayer?.displayEpisodesFailure()
            }
        }
    }
}
