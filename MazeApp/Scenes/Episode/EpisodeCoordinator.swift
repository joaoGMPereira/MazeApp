import UIKit

protocol EpisodeCoordinating: AnyObject {
    func goToEpisode(show: String, season: String, episode: String)
}

final class EpisodeCoordinator {
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies
    
    weak var viewController: UIViewController?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - EpisodeCoordinating
extension EpisodeCoordinator: EpisodeCoordinating {
    func goToEpisode(show: String, season: String, episode: String) {
        
    }
}
