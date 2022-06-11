import UIKit
import SnapKit

protocol ShowCelling: AnyObject {
    func displayFavorited()
    func displayNotFavorite()
}

final class ShowCell: UICollectionViewCell, ViewConfiguration {
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    
    // MARK: - UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.corner(8)
        view.layer.setShadow()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.corner(8)
        return imageView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .preferredFont(for: .callout, weight: .medium)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [favoriteButton, average])
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(primaryAction: .init(handler: { action in
            self.viewModel?.tapFavorite()
        }))
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.tintColor = .systemTeal
        return button
    }()
    
    private lazy var average: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(.init(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemTeal
        return button
    }()

    
    // MARK: - Initializers
    var viewModel: ShowCellViewModel?
    var task: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(containerView)
        containerView.addSubviews(imageView,label, stackView, loadingView)

    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(4)
            $0.bottom.equalTo(label.snp.top).inset(-4)
        }
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(stackView.snp.top).inset(-4)
            $0.height.greaterThanOrEqualTo(20)
        }
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(4)
            $0.leading.greaterThanOrEqualToSuperview().inset(4)
            $0.trailing.lessThanOrEqualToSuperview().inset(-4)
            $0.centerX.equalToSuperview()
        }
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configureViews() {
        containerView.backgroundColor = .secondarySystemBackground
    }

    
    // MARK: - Setup
    func setup(with item: Show, dependencies: Dependencies) {
        let viewModel = ShowCellViewModel(dependencies: dependencies,
                                          showItem: item)
        self.viewModel = viewModel
        viewModel.displayer = self
        updateFavoriteState(with: viewModel.getFavoriteState())
        setupImage(item.image?.medium, dependencies: dependencies)
        setupAverage(item.rating.average)
        label.text = item.name
    }
    
    func setupImage(_ imageUrl: String?, dependencies: Dependencies) {
        loadingView.startAnimating()
        imageView.alpha = .zero
        task = imageView.loadImage(urlString: imageUrl,
                             placeholder: "photo.fill.on.rectangle.fill",
                             dependencies: dependencies) { [weak self] in
            self?.loadingView.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self?.imageView.alpha = 1
                self?.layoutIfNeeded()
            }
        }
    }
    
    func setupAverage(_ average: Double?) {
        var averageText = "-"
        if let average = average {
            averageText = "\(average)"
        }
        self.average.setTitle(averageText, for: .normal)
        self.average.setTitleColor(.label, for: .normal)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        task?.cancel()
    }
}

// MARK: - Displaying
extension ShowCell: ShowCelling {
    func displayFavorited() {
        updateFavoriteState(with: true)
    }
    
    func displayNotFavorite() {
        updateFavoriteState(with: false)
    }
}

private extension ShowCell {
    func updateFavoriteState(with favorite: Bool) {
        if favorite {
            favoriteButton.setImage(.init(systemName: "heart.fill"), for: .normal)
            return
        }
        favoriteButton.setImage(.init(systemName: "heart"), for: .normal)
    }
}
