import UIKit

enum PagingShowsFactory {
    static func make(container: AppDependencies = DependencyContainer(), title: String) -> UIViewController {
        let coordinator = ShowsCoordinator(dependencies: container)
        let viewModel = PagingShowsViewModel(coordinator: coordinator, dependencies: container)
        let viewController = PagingShowsViewController(viewModel: viewModel, dependencies: container, title: title)

        coordinator.viewController = viewController
        viewModel.displayer = viewController

        return viewController
    }
}
