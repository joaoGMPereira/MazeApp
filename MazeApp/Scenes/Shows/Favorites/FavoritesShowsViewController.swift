import UIKit
protocol FavoritesShowsDisplaying: ShowsDisplaying {
    func displayShows(_ shows: [Show])
    func showReset()
    func hideReset()
}

final class FavoritesShowsViewController: ShowsViewController {
    var favoriteViewModel: FavoritesShowsViewModeling? {
        viewModel as? FavoritesShowsViewModeling
    }
    
    lazy var sortBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: .init(systemName: "arrow.up.arrow.down"),
                        primaryAction: .init() { [weak self] _ in
            self?.favoriteViewModel?.changeSort()
        })
        return item
    }()
    
    lazy var resetBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem.init(systemItem: .undo, primaryAction: .init(){ [weak self] _ in
            self?.favoriteViewModel?.reset()
        })
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [sortBarButtonItem]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadShows()
    }
}

// MARK: - PagingShowsDisplaying
extension FavoritesShowsViewController: FavoritesShowsDisplaying {
    func displayShows(_ shows: [Show]) {
        showItems(true)
        dataSource.set(items: shows, to: .zero)
        collectionView.invalidateIntrinsicContentSize()
    }
    
    override func displayEmptyView() {
        showItems(false)
        feedbackView.setupCommponents(title: "Empty Favorites",
                                      subtitle: "Go to Shows list and select your favorites shows",
                                      buttonName: "OK") { [weak self] in
            self?.favoriteViewModel?.goToShows()
        }
    }
    
    func showReset() {
        navigationItem.rightBarButtonItems = [sortBarButtonItem, resetBarButtonItem]
    }
    
    func hideReset() {
        navigationItem.rightBarButtonItems = [sortBarButtonItem]
    }
}
