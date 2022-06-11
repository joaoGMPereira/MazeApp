import Foundation

public protocol SerieViewModeling: AnyObject {
    func loadSerie()
}

final class SerieViewModel {
    typealias Dependencies = HasApi
    private let dependencies: Dependencies
    private let coordinator: SerieCoordinating
    weak var displayer: SerieDisplaying?
    
    private var serie: Serie?
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
        dependencies.api.execute(endpoint: SeriesEndpoint.episodes(id: show.id)) { (result: Result<Success<Series>, ApiError>) in
        }
    }
}
