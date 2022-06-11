import UIKit

enum ShowsAction {
    // template
}

protocol ShowsCoordinating: AnyObject {
    func goToShow(_ show: ShowItemResponse)
}

final class ShowsCoordinator {
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies
    
    weak var viewController: UIViewController?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - ShowsCoordinating
extension ShowsCoordinator: ShowsCoordinating {
    func goToShow(_ show: ShowItemResponse) {
        viewController?.pushViewController(PagingShowsFactory.make(title: "Details"),
                                           animated: true)
    }
}
