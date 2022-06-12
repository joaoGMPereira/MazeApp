import UIKit
import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate, TabControlling {
    
    static func start() -> TabController {
        let showsViewController = PagingShowsFactory.make(title: "Shows")
        let showsItem = UITabBarItem()
        showsItem.title = "Shows"
        showsItem.image = UIImage(systemName: "list.bullet")
        showsViewController.tabBarItem = showsItem
        
        
        
        let favoriteShowsViewController = FavoritesShowsFactory.make(title: "Favorites")
        let favorites = UITabBarItem()
        favorites.title = "Favorites"
        favorites.image = UIImage(systemName: "heart")
        favorites.selectedImage =  UIImage(systemName: "heart.fill")
        favoriteShowsViewController.tabBarItem = favorites
        
        let tabBarController = TabController()
        tabBarController.viewControllers = [UINavigationController(rootViewController: showsViewController), UINavigationController(rootViewController: favoriteShowsViewController)]
        setupNavigationAppearance()
        setupTabBarAppearance()
        return tabBarController
    }
    
    static func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .secondarySystemBackground
        
        appearance.compactInlineLayoutAppearance.normal.iconColor = .secondaryLabel
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.lightText]
        
        appearance.inlineLayoutAppearance.normal.iconColor = .secondaryLabel
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.secondaryLabel]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.secondaryLabel]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        UITabBar.appearance().tintColor = .systemTeal
    }
    
    static func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backgroundColor = .secondarySystemBackground
        appearance.shadowColor = .secondarySystemBackground
        UINavigationBar.appearance().tintColor = .systemTeal
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func getTabBarController() -> UITabBarController {
        self
    }
    
    func setSelected(_ index: Int) {
        selectedIndex = index
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let reloadableViewController = viewController.viewInTabViewController as? ViewControllerReloadable {
            reloadableViewController.reload()
        }
    }
}
