import UIKit

enum EpisodeFactory {
    static func make(container: AppDependencies = DependencyContainer(),
                     show: String,
                     season: String,
                     episode: String) -> UIViewController {
        let coordinator = EpisodeCoordinator(dependencies: container)
        let viewModel = EpisodeViewModel(coordinator: coordinator,
                                         dependencies: container,
                                         show: show,
                                         season: season,
                                         episodeId: episode)
        let viewController = EpisodeViewController(viewModel: viewModel,
                                                   dependencies: container,
                                                   title: "Episode")
        
        coordinator.viewController = viewController
        viewModel.displayer = viewController
        
        return viewController
    }
}
