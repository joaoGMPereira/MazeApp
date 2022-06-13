import UIKit
import SnapKit

protocol SerieDisplaying: AnyObject {
    func displayShow(_ show: Show)
    func displayEpisodes(_ episodes: SerieEpisodes, in section: Int)
    func reloadCells()
    func displayEmptyView()
    func displayLoad()
    func hideLoad()
}

open class SerieViewController: ViewController<SerieViewModeling, UIView> {
    enum Layout {
        static let sectionInset = UIEdgeInsets(top: 8,
                                               left: 16,
                                               bottom: 8,
                                               right: 16)
        static let spacing: CGFloat = 8
        static let paginationOffset: CGFloat = 100
        static let numberOfColumns = CGFloat(1)
        static let estimatedHeight = CGFloat(1000)
    }
    
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    // MARK: - Dependencies
    let dependencies: Dependencies
    
    // MARK: - Collection
    private(set) lazy var dataSource: CollectionViewDataSource<Int, SerieModelling> = {
        let dataSource = CollectionViewDataSource<Int, SerieModelling>(view: collectionView)
        dataSource.automaticReloadData = false
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
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Layout.sectionInset
        layout.minimumInteritemSpacing = Layout.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(
            cellType: SerieSummaryCell.self
        )
        collectionView.register(
            cellType: SerieEpisodeCell.self
        )
        collectionView.register(
            supplementaryViewType: CollectionViewHeader.self,
            ofKind: UICollectionView.elementKindSectionHeader
        )
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            
            config.headerMode = .supplementary
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Layout.estimatedHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Layout.estimatedHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
            )
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            
            return section
        }
        
        
        return layout
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
        viewModel.loadSerie()
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
        view.backgroundColor = .systemBackground
    }
    
    func setupCell(in collectionView: UICollectionView,
                   item: SerieModelling,
                   at indexPath: IndexPath) -> UICollectionViewCell {
        if let show = item as? Show {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SerieSummaryCell.self)
            cell.setup(with: show, dependencies: self.dependencies)
            return cell
        }
        
        if let serieEpisodes = item as? SerieEpisodes {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SerieEpisodeCell.self)
            cell.setup(with: serieEpisodes.series, dependencies: self.dependencies)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func title(for section: Int) -> String {
        if let seasonSection = viewModel.sections[safe: section] {
            return seasonSection
        }
        return String()
    }
}

// MARK: - UICollectionViewDelegate
extension SerieViewController: UICollectionViewDelegate {

}

// MARK: - SerieDisplaying
extension SerieViewController: SerieDisplaying {
    func displayEpisodes(_ episodes: SerieEpisodes, in section: Int) {
        dataSource.add(items: [episodes], to: section)
    }
    
    func displayShow(_ show: Show) {
        dataSource.add(items: [show], to: .zero)
    }
    
    func reloadCells() {
        collectionView.reloadData()
    }
    
    func displayEmptyView() {}
    
    func displayLoad() {
        loadingView.startAnimating()
    }
    
    func hideLoad() {
        loadingView.stopAnimating()
    }
}
