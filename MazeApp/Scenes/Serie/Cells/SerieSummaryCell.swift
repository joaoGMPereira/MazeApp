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
        stack.distribution = .fill
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
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Setup
    func setup(with show: Show, dependencies: Dependencies) {
        setupImage(show.image?.original, dependencies: dependencies)
        summaryInfo.setup(title: "Summary:", subtitle: show.summary?.htmlToAttributedString)
        scheduleInfo.setup(title: "Schedule:", subtitle: .init(string: "(\(show.schedule.days.joined(separator: " | "))) at \(show.schedule.time) (\(show.averageRuntime ?? 0) min)"))
        genresInfo.setup(title: "Genres:", subtitle: .init(string: show.genres.joined(separator: " | ")))
        summaryInfo.isHidden = show.summary == nil
        genresInfo.isHidden = show.genres.isEmpty
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
