import UIKit
import SnapKit

final class SerieSummaryCell: UICollectionViewCell, ViewConfiguration {
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
    
    private lazy var summaryInfo: InfoView = InfoView()
    private lazy var scheduleInfo: InfoView = InfoView()
    private lazy var genresInfo: InfoView = InfoView()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [summaryInfo, scheduleInfo, genresInfo])
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
    func setup(with viewModel: SerieSummaryViewModel, dependencies: Dependencies) {
        setupImage(viewModel.imageUrl, dependencies: dependencies)
        summaryInfo.setup(title: viewModel.summary.title,
                          subtitle: viewModel.summary.subtitle)
        scheduleInfo.setup(title: viewModel.schedule.title, subtitle: viewModel.schedule.subtitle)
        genresInfo.setup(title: viewModel.genres.title, subtitle: viewModel.genres.subtitle)
        summaryInfo.isHidden = viewModel.summary.isHidden
        genresInfo.isHidden = viewModel.genres.isHidden
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
        task?.cancel()
    }
}
