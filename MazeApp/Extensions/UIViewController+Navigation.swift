import UIKit

extension UIViewController {
    func pushViewController(_ viewController: UIViewController,
                            hidesBottomBar: Bool = true,
                            animated: Bool = true) {
        viewController.hidesBottomBarWhenPushed = hidesBottomBar
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    var viewInTabViewController: UIViewController? {
        guard let navigationController = self as? UINavigationController,
              let viewInTabViewController = navigationController.viewControllers.first else {
                  return nil
              }
        return viewInTabViewController
    }
}
