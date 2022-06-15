import Foundation

public protocol EpisodeViewModeling: AnyObject {
    func loadScreen()
}

final class EpisodeViewModel {
    typealias Dependencies = HasApi
    private let dependencies: Dependencies
    weak var displayer: EpisodeDisplaying?
    
    private var episode: Episode?
    private(set) var sections: [String] = [String(), "Episodes"]
    private let show: String
    private let season: String
    private let episodeId: String
    
    init(dependencies: Dependencies,
         show: String,
         season: String,
         episodeId: String) {
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
                self.displayer?.displaySummary(
                    .init(summary: .init(title: episode.summary ?? String(),
                                         image: "tv",
                                         isHidden: episode.summary == nil),
                          imageUrl: episode.image?.original,
                          schedule: .init(title: self.schedule(with: episode),
                                          font: .preferredFont(for: .footnote, weight: .bold),
                                          alignment: .justified,
                                          image: "tv"),
                          genres: []
                         ),
                    title: "E\(episode.number)S\(episode.season) \(episode.name)"
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
    
    func schedule(with episode: Episode) -> String {
        var scheduleSubtitle = String()
        
        if let airTime = episode.airtime {
            scheduleSubtitle = "\(airTime) - "
        }
        if let runTime = episode.runtime {
            scheduleSubtitle += "(\(runTime) min)"
        }
        return scheduleSubtitle
    }
}
