import UIKit
import SnapKit

final class SummaryCell: UICollectionViewCell, ViewConfiguration {
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    
    // MARK: - UI Properties
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
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.setContentHuggingPriority(.defaultLow, for: .vertical)
        return stack
    }()
    
    // MARK: - Initializers
    var task: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(imageView, stackView, loadingView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(4)
            $0.bottom.equalTo(stackView.snp.top).inset(-4)
            $0.height.equalTo(350)
        }
        stackView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(4)
        }
        loadingView.snp.makeConstraints {
            $0.center.equalTo(imageView.snp.center)
        }
    }
    
    // MARK: - Setup
    func setup(with viewModel: SummaryViewModel, dependencies: Dependencies) {
        setupImage(viewModel.imageUrl, dependencies: dependencies)
        viewModel.infos.forEach {
            let infoView = InfoView()
            infoView.setup(title: $0.title, subtitle: $0.subtitle)
            stackView.addArrangedSubview(infoView)
            infoView.isHidden = $0.isHidden
            
        }
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
    
    override func prepareForReuse() {
        imageView.image = nil
        stackView.removeAllSubviews()
        task?.cancel()
    }
}
