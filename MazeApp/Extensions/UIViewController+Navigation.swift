import UIKit

extension UIViewController {
    func pushViewController(_ viewController: UIViewController,
                            hidesBottomBar: Bool = true,
                            animated: Bool = true) {
        hidesBottomBarWhenPushed = hidesBottomBar
        navigationController?.pushViewController(viewController, animated: true)
    }
}
