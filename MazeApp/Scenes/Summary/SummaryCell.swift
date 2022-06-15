import UIKit
import SnapKit

protocol SummaryCellDelegate: AnyObject {
    func downloadedImage()
}

final class SummaryCell: UICollectionViewCell, ViewConfiguration {
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    
    // MARK: - UI Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.setContentHuggingPriority(.defaultLow, for: .vertical)
        stack.spacing = 8
        return stack
    }()
    
    private lazy var summaryLabel = Label()
    
    private lazy var scheduleLabel = Label()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.register(
            cellType: LabelCell.self
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return UICollectionViewCompositionalLayout(section: NSCollectionLayoutSection(group: group))
    }()
    
    private(set) lazy var dataSource: CollectionViewDataSource<Int, Content> = {
        let dataSource = CollectionViewDataSource<Int, Content>(view: collectionView)
        dataSource.itemProvider = { [weak self] view, indexPath, item in
            self?.setupCell(in: view, item: item, at: indexPath)
        }
        return dataSource
    }()
    
    // MARK: - Initializers
    var task: URLSessionDataTask?
    var hasGenres = false
    weak var delegate: SummaryCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
        collectionView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(imageView, stackView, loadingView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.height.equalTo(350)
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(8)
        }
        collectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(44)
        }
        loadingView.snp.makeConstraints {
            $0.center.equalTo(imageView.snp.center)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasGenres {
            collectionView.snp.updateConstraints {
                $0.height.greaterThanOrEqualTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
            }
        }
        layoutIfNeeded()
    }
    
    // MARK: - Setup
    func setup(with viewModel: SummaryViewModel, dependencies: Dependencies) {
        stackView.addArrangedSubviews(imageView, collectionView, summaryLabel, scheduleLabel)
        setupGenres(viewModel.genres)
        setupSummary(viewModel.summary)
        setupSchedule(viewModel.schedule)
    }
    
    func setupImage(_ imageUrl: String?, dependencies: Dependencies) {
        loadingView.startAnimating()
        imageView.alpha = .zero
        task = imageView.loadImage(urlString: imageUrl,
                                   placeholder: "photo.fill.on.rectangle.fill",
                                   dependencies: dependencies) { [weak self] in
            guard let self = self else { return }
            self.loadingView.stopAnimating()
            self.imageView.image = self.imageView.image?.corner()
            UIView.animate(withDuration: 1) {
                self.imageView.alpha = 1
                self.layoutIfNeeded()
                self.delegate?.downloadedImage()
                self.imageView.snp.updateConstraints {
                    $0.height.equalTo(self.imageView.contentClippingRect.height)
                }
            }
        }
    }
    
    func setupGenres(_ genres: [Content]) {
        hasGenres = genres.isNotEmpty
        guard hasGenres else {
            collectionView.snp.remakeConstraints {
                $0.height.equalTo(0)
            }
            return
        }
        
        dataSource.set(
            items:  genres.map {
                .init(
                    title: $0.title,
                    font: $0.font,
                    alignment: $0.alignment
                )
            },
            to: .zero)
        
    }
    
    func setupSummary(_ summary: Content) {
        summaryLabel.setupAttributed(text: summary.title.htmlToAttributedString)
        summaryLabel.isHidden = summary.isHidden
    }
    
    func setupSchedule(_ schedule: Content) {
        scheduleLabel.setup(text: schedule.title,
                            font: schedule.font,
                            alignment: schedule.alignment
        )
        summaryLabel.isHidden = schedule.isHidden
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        stackView.removeAllSubviews()
        task?.cancel()
    }
    
    func setupCell(in collectionView: UICollectionView,
                   item: Content,
                   at indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                      cellType: LabelCell.self)
        cell.setup(
            text: item.title,
            font: item.font,
            alignment: item.alignment,
            imageName: nil
        )
        return cell
    }
}
