import UIKit

protocol SerieCoordinating: AnyObject {
    func goToSerie(_ show: Serie)
}

final class SerieCoordinator {
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies
    
    weak var viewController: UIViewController?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - SerieCoordinating
extension SerieCoordinator: SerieCoordinating {
    func goToSerie(_ show: Serie) {
      //  viewController?.pushViewController(PagingSerieFactory.make(title: "Details"),
      //                                     animated: true)
    }
}
