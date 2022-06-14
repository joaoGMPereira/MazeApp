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
                let episode = response.model
                self.episode = episode
                let summarySubtitle = episode.summary?.htmlToAttributedString
                self.displayer?.displaySummary(
                    .init(imageUrl: episode.image?.original,
                          infos: [
                            .init(title: "Summary",
                                  subtitle: summarySubtitle,
                                  isHidden: summarySubtitle == nil),
                            .init(title: "Season:",
                                  subtitle: .init(string: "Season \(episode.season)")),
                            .init(title: "Episode",
                                  subtitle: .init(string: "Episode \(episode.number)")
                                 )
                          ]
                         ),
                    title: episode.name
                )
            case .failure:
                self.displayer?.displayEpisodeFailure(
                    with: FeedbackModel(
                        title: "Something didn't go right while we searched for the episode",
                        subtitle: "Verify you connection and please try again",
                        buttonName: "Try again") { [weak self] in
                            self?.loadScreen()
                        })
            }
        }
    }
}
