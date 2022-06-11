import UIKit

enum SerieFactory {
    static func make(container: AppDependencies = DependencyContainer(),
                     show: Show) -> UIViewController {
        let coordinator = SerieCoordinator(dependencies: container)
        let viewModel = SerieViewModel(coordinator: coordinator,
                                       dependencies: container,
                                       show: show)
        let viewController = SerieViewController(viewModel: viewModel,
                                                 dependencies: container,
                                                 title: show.name)

        coordinator.viewController = viewController
        viewModel.displayer = viewController

        return viewController
    }
}
