import UIKit
protocol HasTabControlling {
    var tabBarController: TabControlling { get }
}

protocol TabControlling {
    func getTabBarController() -> UITabBarController
    func setSelected(_ index: Int)
}
