import UIKit
import SnapKit

protocol ShowsDisplaying: AnyObject {
    func displayEmptyView()
    func displayLoad()
    func hideLoad()
}

open class ShowsViewController: ViewController<ShowsViewModeling, UIView> {
    enum Layout {
        static let sectionInset = UIEdgeInsets(top: 8,
                                               left: 16,
                                               bottom: 8,
                                               right: 16)
        static let spacing: CGFloat = 8
        static let paginationOffset: CGFloat = 100
        static let numberOfColumns = CGFloat(2)
    }
    
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    // MARK: - Dependencies
    let dependencies: Dependencies
    
    // MARK: - Collection
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.register(
            cellType: ShowCell.self
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let fraction: CGFloat = 1 / 2
        let inset: CGFloat = 2.5
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private(set) lazy var dataSource: CollectionViewDataSource<Int, Show> = {
        let dataSource = CollectionViewDataSource<Int, Show>(view: collectionView)
        dataSource.itemProvider = { [weak self] view, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            let cell = view.dequeueReusableCell(for: indexPath, cellType: ShowCell.self)
            cell.setup(with: item, dependencies: self.dependencies)
            return cell
        }
        return dataSource
    }()
    
    // MARK: Loading
    private(set) lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    private(set) lazy var pagingLoadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    private(set) lazy var pagingLoadingButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(customView: pagingLoadingView)
        return barButtonItem
    }()
    
    private(set) lazy var feedbackView = FeedbackView(frame: .zero)
    
    // MARK: SearchBar
    private(set) lazy var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Initializers
    init(viewModel: ShowsViewModeling, dependencies: Dependencies, title: String) {
        self.dependencies = dependencies
        super.init(viewModel: viewModel)
        self.title = title
    }
    
    // MARK: - Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        viewModel.loadShows()
    }
    
    open override func buildViewHierarchy() {
        view.addSubviews(collectionView, loadingView, feedbackView)
    }
    
    open override func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        feedbackView.snp.makeConstraints {
            $0.top.leading.greaterThanOrEqualTo(view.layoutMarginsGuide)
            $0.bottom.trailing.lessThanOrEqualTo(view.layoutMarginsGuide)
            $0.centerX.centerY.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    open override func configureViews() {
        collectionView.dataSource = dataSource
        feedbackView.alpha = 0
        view.backgroundColor = .systemBackground
    }
    
    func showItems(_ show: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.alpha = show ? 1 : 0
            self.feedbackView.alpha = show ? 0 : 1
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ShowsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTap(at: indexPath)
    }
}

// MARK: - ShowsDisplaying
extension ShowsViewController: ShowsDisplaying {
    @objc
    func displayEmptyView() {}
    
    func displayLoad() {
        loadingView.startAnimating()
    }
    
    func hideLoad() {
        loadingView.stopAnimating()
    }
}
