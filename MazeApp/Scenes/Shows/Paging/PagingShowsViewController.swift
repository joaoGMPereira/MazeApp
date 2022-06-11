import UIKit

protocol PagingShowsDisplaying: ShowsDisplaying {
    func displayError()
    func displayShows(_ shows: [ShowItem])
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
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
}

// MARK: - UICollectionViewDelegate
extension PagingShowsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pagingViewModel?.didTap(at: indexPath)
    }
    
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
        let searchBar = searchController.searchBar
        if pagingViewModel?.isSearching ?? false,
            let searchBarText = searchBar.text {
            pagingViewModel?.getFilteredShows(title: searchBarText)
        }
    }
}

// MARK: - PagingShowsDisplaying
extension PagingShowsViewController: PagingShowsDisplaying {
    func displayShows(_ shows: [ShowItem]) {
        dataSource.add(items: shows, to: .zero)
    }
    
    func displayError() {
        
    }
    
    override func displayEmptyView() {
        
    }
    func displayNextPageLoad() {
        pagingLoadingView.startAnimating()
    }
    func hideNextPageLoad() {
        pagingLoadingView.stopAnimating()
    }
}
