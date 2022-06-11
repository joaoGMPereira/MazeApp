import UIKit

enum FavoritesShowsFactory {
    static func make(container: AppDependencies = DependencyContainer(), title: String) -> UIViewController {
        let coordinator = ShowsCoordinator(dependencies: container)
        let viewModel = FavoritesShowsViewModel(coordinator: coordinator, dependencies: container)
        let viewController = FavoritesShowsViewController(viewModel: viewModel, dependencies: container, title: title)

        coordinator.viewController = viewController
        viewModel.displayer = viewController

        return viewController
    }
}
