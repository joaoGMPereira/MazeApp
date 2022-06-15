@testable import MazeApp
import UIKit

class TabControllingSpy: TabControlling {
    enum Messages: Equatable {
        case getTabBarController
        case setSelected(Int)
    }

    private(set) var messages: [Messages] = []

    func getTabBarController() -> UITabBarController {
        messages.append(.getTabBarController)
        return UITabBarController()
    }

    func setSelected(_ index: Int) {
        messages.append(.setSelected(index))
    }

}
