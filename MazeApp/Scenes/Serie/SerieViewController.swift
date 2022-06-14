import UIKit
import SnapKit

protocol SerieDisplaying: AnyObject {
    func displaySummary(_ summary: SerieSummaryViewModel)
    func displayEpisodes(_ items: EpisodesViewModel, in section: Int)
    func displayEpisodesFailure(with feedback: FeedbackModel)
    func displayLoad()
}
open class SerieViewController: ViewController<SerieViewModeling, UIView> {
    enum Layout {
        static let spacing: CGFloat = 8
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
        dataSource.supplementaryViewProvider = { [weak self] view, kind, index in
            guard let self = self else { return  UICollectionReusableView() }
            let header = view.dequeueReusableSupplementaryView(ofKind: kind, for: index, viewType: CollectionViewHeader.self)
            header.setup(title: self.title(for: index.section))
            return header
        }
        return dataSource
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(
            cellType: SerieSummaryCell.self
        )
        collectionView.register(
            cellType: SerieEpisodeCell.self
        )
        collectionView.register(
            cellType: LoadingCell.self
        )
        collectionView.register(
            cellType: FeedbackCell.self
        )
        collectionView.register(
            supplementaryViewType: CollectionViewHeader.self,
            ofKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }()
    
    var backgroundConfiguration: UIBackgroundConfiguration {
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.cornerRadius = Layout.spacing
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
    init(viewModel: SerieViewModeling, dependencies: Dependencies, title: String) {
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
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getSeries()
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
    
    func title(for section: Int) -> String {
        if let seasonSection = viewModel.sections[safe: section] {
            return seasonSection
        }
        return String()
    }
}

// MARK: - Setup Cells
extension SerieViewController {
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
        
        if let summary = item as? SerieSummaryViewModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SerieSummaryCell.self)
            cell.setup(with: summary, dependencies: self.dependencies)
            cell.backgroundConfiguration = backgroundConfiguration
            return cell
        }
        
        if let itemsViewModels = item as? EpisodesViewModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SerieEpisodeCell.self)
            cell.setup(with: itemsViewModels.items)
            cell.backgroundConfiguration = backgroundConfiguration
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension SerieViewController: SerieEpisodeCellDelegate {
    func didTap(season: String, number: String) {
        viewModel.goToEpisode(season: season, episode: number)
    }
}
// MARK: - SerieDisplaying
extension SerieViewController: SerieDisplaying {
    func displayEpisodes(_ items: EpisodesViewModel, in section: Int) {
        dataSource.update(items: [items], from: section)
    }
    
    func displaySummary(_ summary: SerieSummaryViewModel) {
        dataSource.set(items: [summary], to: .zero)
    }
    
    func displayEpisodesFailure(with feedback: FeedbackModel) {
        dataSource.update(items: [feedback], from: 1)
    }
    
    func displayLoad() {
        dataSource.update(items: [LoadingModel()], from: 1)
    }
}
