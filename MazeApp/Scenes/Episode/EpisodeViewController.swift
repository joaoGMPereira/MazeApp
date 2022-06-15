import UIKit
import SnapKit

protocol EpisodeDisplaying: AnyObject {
    func displaySummary(_ summary: SummaryViewModel, title: String)
    func displayEpisodeFailure(with feedback: FeedbackModel)
    func displayLoad()
}
open class EpisodeViewController: ViewController<EpisodeViewModeling, UIView> {
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    // MARK: - Dependencies
    let dependencies: Dependencies
    
    // MARK: - Collection
    private(set) lazy var dataSource: CollectionViewDataSource<Int, CellViewModelling> = {
        let dataSource = CollectionViewDataSource<Int, CellViewModelling>(view: collectionView)
        dataSource.itemProvider = { [weak self] view, indexPath, item in
            self?.setupCell(in: view, item: item, at: indexPath)
        }
        return dataSource
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(
            cellType: LoadingCell.self
        )
        collectionView.register(
            cellType: FeedbackCell.self
        )
        collectionView.register(
            cellType: SummaryCell.self
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }()
    
    var backgroundConfiguration: UIBackgroundConfiguration {
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.cornerRadius = 8
        return backgroundConfiguration
    }
    
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
    
    // MARK: SearchBar
    private(set) lazy var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Initializers
    init(viewModel: EpisodeViewModeling, dependencies: Dependencies, title: String) {
        self.dependencies = dependencies
        super.init(viewModel: viewModel)
        self.title = title
    }
    
    // MARK: - Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        viewModel.loadScreen()
    }
    
    open override func buildViewHierarchy() {
        view.addSubviews(collectionView, loadingView)
    }
    
    open override func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    open override func configureViews() {
        collectionView.dataSource = dataSource
    }
}

// MARK: - Setup Cells
extension EpisodeViewController {
    func setupCell(in collectionView: UICollectionView,
                   item: CellViewModelling,
                   at indexPath: IndexPath) -> UICollectionViewCell {
        if item is LoadingModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LoadingCell.self)
            cell.load()
            cell.backgroundConfiguration = backgroundConfiguration
            return cell
        }
        
        if let feedbackModel = item as? FeedbackModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FeedbackCell.self)
            cell.setupCommponents(model: feedbackModel)
            cell.backgroundConfiguration = backgroundConfiguration
            return cell
        }
        
        if let summary = item as? SummaryViewModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SummaryCell.self)
            cell.setup(with: summary, dependencies: dependencies)
            cell.backgroundConfiguration = backgroundConfiguration
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - EpisodeDisplaying
extension EpisodeViewController: EpisodeDisplaying, SummaryCellDelegate {
    func displaySummary(_ summary: SummaryViewModel, title: String) {
        dataSource.set(items: [summary], to: .zero)
        self.title = title
    }
    
    func displayEpisodeFailure(with feedback: FeedbackModel) {
        dataSource.update(items: [feedback], from: .zero)
    }
    
    func displayLoad() {
        dataSource.update(items: [LoadingModel()], from: .zero)
    }
    
    func downloadedImage() {
        collectionView.reloadSections(.init(integer: .zero))
    }
}
