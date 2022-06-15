import Foundation

public protocol SerieViewModeling: AnyObject {
    func loadScreen()
    func getSeries()
    func goToEpisode(season: String, episode: String)
    var sections: [String] { get }
}

final class SerieViewModel {
    typealias Dependencies = HasApi
    private let dependencies: Dependencies
    private let coordinator: SerieCoordinating
    weak var displayer: SerieDisplaying?
    
    private var series: [Series] = []
    private(set) var sections: [String] = [String(), "Episodes"]
    private let show: Show
    
    init(coordinator: SerieCoordinating,
         dependencies: Dependencies,
         show: Show) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        self.show = show
    }
}

// MARK: - SeriesViewModeling
extension SerieViewModel: SerieViewModeling {
    func loadScreen() {
        displayer?.displaySummary(
            .init(summary: .init(title: show.summary ?? String(),
                                 image: "tv",
                                 isHidden: show.summary == nil),
                  imageUrl: show.image?.original,
                  schedule: .init(title: schedule(),
                                  font: .preferredFont(for: .footnote, weight: .bold),
                                  alignment: .justified,
                                  image: "tv",
                                  isHidden: schedule().isEmpty),
                  genres: genres()))
        displayer?.displayLoad()
    }
    
    func getSeries() {
        dependencies.api.execute(endpoint: SerieEndpoint.episodes(id: show.id)) { [weak self] (result: Result<Success<Series>, ApiError>) in
            guard let self = self else { return }
            self.handleResponse(result)
        }
    }
    
    func handleResponse(_ result: Result<Success<Series>, ApiError>) {
        switch result {
        case .success(let response):
            let episodesForSeason = Array(Dictionary(grouping:response.model){$0.season}.values).sorted{
                guard let first = $0.first, let second = $1.first else {
                    return false
                }
                return first.season < second.season
            }
            series = episodesForSeason
            createTitles()
            episodesForSeason.enumerated().forEach {
                displayer?.displayEpisodes(items(with: $0.element), in: $0.offset + 1)
            }
        case .failure:
            displayer?.displayEpisodesFailure(
                with: FeedbackModel(
                    title: "Something didn't go right while we searched for the episodes",
                    subtitle: "Verify you connection and please try again",
                    buttonName: "Try again") { [weak self] in
                        self?.getSeries()
                    })
        }
    }
    func items(with series: [Serie]) -> EpisodesViewModel {
        return EpisodesViewModel(
            items: series.map {
                .cell(
                    number: "\($0.number)",
                    date: AppDateFormatter.format($0.airdate),
                    name: "E\($0.number): \($0.name)",
                    score: average($0.rating.average),
                    season: $0.season)
            }
        )
    }
    
    func createTitles() {
        sections = [String()]
        self.series.forEach { series in
            if let firstEpisode = series.first {
                sections.append("Season \(firstEpisode.season)")
            }
        }
    }
    
    func average(_ average: Double?) -> String {
        var averageText = "-"
        if let average = average {
            averageText = "\(average)/10"
        }
        return averageText
    }
    
    func goToEpisode(season: String, episode: String) {
        coordinator.goToEpisode(show: "\(show.id)",
                                season: season,
                                episode: episode)
    }
}

extension SerieViewModel {
    func schedule() -> String {
        var scheduleSubtitle = String()
        let days = show.schedule.days.joined(separator: " | ")
        let time = show.schedule.time
        if days.isNotEmpty {
            scheduleSubtitle = "(\(days)) at \(time) "
        }
        if let runTime = show.averageRuntime {
            scheduleSubtitle += "(\(runTime) min)"
        }
        return scheduleSubtitle
    }
    
    func genres() -> [Content] {
        show.genres.map {
            .init(title: $0, font: .preferredFont(for: .footnote, weight: .bold), alignment: .center)
        }
    }
}
