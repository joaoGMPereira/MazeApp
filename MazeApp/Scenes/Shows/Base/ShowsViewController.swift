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
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Layout.sectionInset
        layout.minimumInteritemSpacing = Layout.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(cellType: ShowCell.self)
        return collectionView
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
extension ShowsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTap(at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftRightMargin = Layout.sectionInset.left + Layout.sectionInset.right
        
        let numberOfColumns = Layout.numberOfColumns
        let totalCellSpace = Layout.spacing * (numberOfColumns - 1)
        let screenWidth = view.bounds.width
        let width = (screenWidth - leftRightMargin - totalCellSpace) / numberOfColumns
        let height = view.bounds.height * 0.3
        
        return .init(width: width, height: height)
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
