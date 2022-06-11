import UIKit

enum SerieFactory {
    static func make(container: AppDependencies = DependencyContainer(), title: String) -> UIViewController {
        let coordinator = SerieCoordinator(dependencies: container)
        let viewModel = SerieViewModel(coordinator: coordinator, dependencies: container)
        let viewController = SerieViewController(viewModel: viewModel, dependencies: container, title: title)

        coordinator.viewController = viewController
        viewModel.displayer = viewController

        return viewController
    }
}
