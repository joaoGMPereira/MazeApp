import Foundation

public protocol SerieViewModeling: AnyObject {
    func loadSerie()
    var sections: [String] { get }
}

final class SerieViewModel {
    typealias Dependencies = HasApi
    private let dependencies: Dependencies
    private let coordinator: SerieCoordinating
    weak var displayer: SerieDisplaying?
    
    private var series: [Series] = []
    private(set) var sections: [String] = [String()]
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
    func loadSerie() {
        displayer?.displayLoad()
        displayer?.displayShow(show)
        getSeries { [weak self] in
            self?.displayer?.hideLoad()
        }
    }
    
    func getSeries(completion: @escaping () -> Void) {
        dependencies.api.execute(endpoint: SeriesEndpoint.episodes(id: show.id)) { [weak self] (result: Result<Success<Series>, ApiError>) in
            guard let self = self else { return }
            self.handleResponse(result, completion: completion)
        }
    }
    
    func handleResponse(_ result: Result<Success<Series>, ApiError>, completion: @escaping () -> Void) {
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
                displayer?.displayEpisodes(.init(series: $0.element), in: $0.offset + 1)
            }
        case .failure: break
            //   self.backToPreviousPage()
        }
        displayer?.reloadCells()
        completion()
    }
    
    func createTitles() {
        self.series.forEach { series in
            if let firstEpisode = series.first {
                sections.append("\(firstEpisode.season) Season")
            }
        }
    }
}
