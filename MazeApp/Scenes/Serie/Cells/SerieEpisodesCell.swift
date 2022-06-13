import UIKit
import SnapKit

protocol SerieEpisodeCellDelegate: AnyObject {
    func didTap(season: String, number: String)
}

final class SerieEpisodeCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(
            cellType: ItemsCell.self
        )
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.footerMode = .none
        configuration.headerMode = .none
        configuration.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }()
    
    private(set) lazy var dataSource: CollectionViewDataSource<Int, EpisodeViewModel> = {
        let dataSource = CollectionViewDataSource<Int, EpisodeViewModel>(view: collectionView)
        dataSource.itemProvider = { [weak self] view, indexPath, item in
            self?.setupCell(in: view, item: item, at: indexPath)
        }
        return dataSource
    }()
    
    weak var delegate: SerieEpisodeCellDelegate?
    
    func setupCell(in collectionView: UICollectionView,
                   item: EpisodeViewModel,
                   at indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ItemsCell.self)
        cell.setup(model: item)
        return cell
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
            $0.height.greaterThanOrEqualTo(150)
        }
    }
    
    func configureViews() {
        collectionView.dataSource = dataSource
    }
    
    // MARK: - Setup
    func setup(with items: [EpisodeViewModel]) {
        dataSource.set(items: items, to: .zero)
    }
    
    func average(_ average: Double?) -> String {
        var averageText = "-"
        if let average = average {
            averageText = "\(average)"
        }
        return averageText
    }
}

extension SerieEpisodeCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.item(at: indexPath), let season = item.season {
            delegate?.didTap(season: "\(season)", number: item.number.title)
        }
    }
}
