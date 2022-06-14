import UIKit

protocol SerieCoordinating: AnyObject {
    func goToEpisode(show: String, season: String, episode: String)
}

final class SerieCoordinator {
    weak var viewController: UIViewController?
}

// MARK: - SerieCoordinating
extension SerieCoordinator: SerieCoordinating {
    func goToEpisode(show: String, season: String, episode: String) {
        viewController?.pushViewController(EpisodeFactory.make(show: show,
                                                               season: season,
                                                               episode: episode))
    }
}
