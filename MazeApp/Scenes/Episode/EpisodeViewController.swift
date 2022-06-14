import UIKit
import SnapKit

protocol EpisodeDisplaying: AnyObject {
    func displayShow(_ show: Show)
    func displayEpisodes(_ items: EpisodesViewModel, in section: Int)
    func displayEpisodesFailure()
    func displayLoad()
}
open class EpisodeViewController: ViewController<EpisodeViewModeling, UIView> {
    enum Layout {
        static let sectionInset = UIEdgeInsets(top: 8,
                                               left: 16,
                                               bottom: 8,
                                               right: 16)
        static let spacing: CGFloat = 8
        static let paginationOffset: CGFloat = 100
        static let numberOfColumns = CGFloat(1)
        static let estimatedHeight = CGFloat(300)
    }
    
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    // MARK: - Dependencies
    let dependencies: Dependencies
    
    // MARK: - Collection
    private(set) lazy var dataSource: CollectionViewDataSource<Int, CellViewModelling> = {
        let dataSource = CollectionViewDataSource<Int, CellViewModelling>(view: collectionView)
        dataSource.itemProvider = { [weak self] view, indexPath, item in
            self?.setupCell(in: view, item: item, at: indexPath)
        }
        //        dataSource.supplementaryViewProvider = { [weak self] view, kind, index in
        //            guard let self = self else { return  UICollectionReusableView() }
        //            let header = view.dequeueReusableSupplementaryView(ofKind: kind, for: index, viewType: CollectionViewHeader.self)
        //            header.setup(title: self.title(for: index.section))
        //            return header
        //        }
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
        
        return UICollectionViewCell()
    }
}

// MARK: - EpisodeDisplaying
extension EpisodeViewController: EpisodeDisplaying {
    func displayEpisodes(_ items: EpisodesViewModel, in section: Int) {
        dataSource.update(items: [items], from: section)
    }
    
    func displayShow(_ show: Show) {
       // dataSource.set(items: [show], to: .zero)
    }
    
    func displayEpisodesFailure() {
        dataSource.update(items: [FeedbackModel(title: "Something didn't go right while we searched for the episode",
                                                subtitle: "Verify you connection and please try again",
                                                buttonName: "Try again") { [weak self] in
            self?.viewModel.loadScreen()
        }], from: .zero)
    }
    
    func displayLoad() {
        dataSource.update(items: [LoadingModel()], from: .zero)
    }
}
