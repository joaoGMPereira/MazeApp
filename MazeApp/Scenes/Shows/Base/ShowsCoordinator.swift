import UIKit

protocol ShowsCoordinating: AnyObject {
    func goToSerie(_ show: ShowItemResponse)
    func goToShows()
}

final class ShowsCoordinator {
    typealias Dependencies = HasTabControlling
    private let dependencies: Dependencies
    
    weak var viewController: UIViewController?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - ShowsCoordinating
extension ShowsCoordinator: ShowsCoordinating {
    func goToSerie(_ show: ShowItemResponse) {
        viewController?.pushViewController(SerieFactory.make(title: show.name),
                                           animated: true)
    }
    
    func goToShows() {
        dependencies.tabBarController.setSelected(.zero)
    }
}
