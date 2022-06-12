import UIKit
import SnapKit

protocol SerieCelling: AnyObject {}

final class SerieCell: UICollectionViewCell, ViewConfiguration {
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
        let stack = UIStackView(arrangedSubviews: [label, average])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        return stack
    }()
  
    private lazy var average: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(.init(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemTeal
        return button
    }()

    
    // MARK: - Initializers
    var viewModel: SerieCellViewModel?
    var task: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(containerView)
        containerView.addSubviews(imageView, stackView, loadingView)

    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(4)
            $0.bottom.equalTo(stackView.snp.top).inset(-4)
            $0.height.equalTo(350)
        }
        stackView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(4)
        }
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configureViews() {
        containerView.backgroundColor = .secondarySystemGroupedBackground
    }

    
    // MARK: - Setup
    func setup(with show: Show, dependencies: Dependencies) {
        let viewModel = SerieCellViewModel(dependencies: dependencies,
                                           show: show)
        self.viewModel = viewModel
        viewModel.displayer = self
        setupImage(show.image?.original, dependencies: dependencies)
        setupAverage(show.rating.average)
        label.text = show.name
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
extension SerieCell: SerieCelling {
}
