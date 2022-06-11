import Foundation

public protocol SerieViewModeling: AnyObject {
    func loadSerie()
}

final class SerieViewModel {
    typealias Dependencies = HasStorageable & HasMainQueue
    private let dependencies: Dependencies
    private let coordinator: SerieCoordinating
    weak var displayer: SerieDisplaying?
    
    private var serie: SerieResponse?
    
    init(coordinator: SerieCoordinating,
         dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
}

// MARK: - SeriesViewModeling
extension SerieViewModel: SerieViewModeling {
    func loadSerie() {
//        displayer?.displayLoad()
//        getSeries { [weak self] in
//            self?.displayer?.hideLoad()
//        }
    }
}
