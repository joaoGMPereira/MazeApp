import UIKit

protocol PagingShowsDisplaying: ShowsDisplaying {
    func displayFilteredEmptyView()
    func displayShows(_ shows: [Show])
    func clearShows()
    func displayNextPageLoad()
    func hideNextPageLoad()
}

final class PagingShowsViewController: ShowsViewController {
    var pagingViewModel: PagingShowsViewModeling? {
        viewModel as? PagingShowsViewModeling
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
}

// MARK: - Private Extension
private extension PagingShowsViewController {
    func setupNavigation() {
        navigationItem.rightBarButtonItem = pagingLoadingButtonItem
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Shows..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
}

// MARK: - UICollectionViewDelegate
extension PagingShowsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if contentHeight > .zero && offsetY > contentHeight - scrollView.frame.size.height - Layout.paginationOffset {
            pagingViewModel?.getNextShows()
        }
    }
}

// MARK: - UISearchBarDelegate
extension PagingShowsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(PagingShowsViewController.search), object: nil)
        self.perform(#selector(PagingShowsViewController.search), with: nil, afterDelay: 1)
    }
    
    @objc
    func search() {
        let searchBar = searchController.searchBar
        if let searchBarText = searchBar.text {
            pagingViewModel?.getFilteredShows(title: searchBarText)
        }
    }
}

// MARK: - PagingShowsDisplaying
extension PagingShowsViewController: PagingShowsDisplaying {
    func displayShows(_ shows: [Show]) {
        showItems(true)
        dataSource.add(items: shows, to: .zero)
    }
    
    func clearShows() {
        dataSource.clear(.zero)
    }
    
    func displayFilteredEmptyView() {
        showItems(false)
        feedbackView.setupCommponents(title: "Didn`t find any show with you search",
                                      subtitle: "Try again searching with other name")
    }
    
    override func displayEmptyView() {
        showItems(false)
        feedbackView.setupCommponents(title: "Something didn`t work well",
                                      subtitle: "System failure, please try again",
                                      buttonName: "try again") {
            self.feedbackView.alpha = .zero
            self.pagingViewModel?.loadShows()
        }
    }
    func displayNextPageLoad() {
        pagingLoadingView.startAnimating()
    }
    func hideNextPageLoad() {
        pagingLoadingView.stopAnimating()
    }
}
