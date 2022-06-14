import UIKit

protocol SerieCoordinating: AnyObject {
    func goToEpisode(show: String, season: String, episode: String)
}

final class SerieCoordinator {
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies
    
    weak var viewController: UIViewController?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - SerieCoordinating
extension SerieCoordinator: SerieCoordinating {
    func goToEpisode(show: String, season: String, episode: String) {
        viewController?.pushViewController(EpisodeFactory.make(show: show,
                                                               season: season,
                                                               episode: episode))
    }
}
