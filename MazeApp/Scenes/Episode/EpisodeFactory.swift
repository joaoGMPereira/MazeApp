import UIKit

enum EpisodeFactory {
    static func make(container: AppDependencies = DependencyContainer(),
                     show: String,
                     season: String,
                     episode: String) -> UIViewController {
        let viewModel = EpisodeViewModel(dependencies: container,
                                         show: show,
                                         season: season,
                                         episodeId: episode)
        let viewController = EpisodeViewController(viewModel: viewModel,
                                                   dependencies: container,
                                                   title: "Episode")
        viewModel.displayer = viewController
        
        return viewController
    }
}
