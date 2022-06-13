import UIKit
import SnapKit

final class SerieEpisodeCell: UICollectionViewCell, ViewConfiguration {
    typealias Dependencies = HasMainQueue & HasURLSessionable & HasStorageable
    
    // MARK: - UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.corner(8)
        view.layer.setShadow()
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .preferredFont(for: .callout, weight: .medium)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, average])
        stack.distribution = .fillProportionally
        stack.spacing = 8
        return stack
    }()
    
//    private lazy var stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [label, average])
//        stack.distribution = .fillProportionally
//        stack.spacing = 8
//        return stack
//    }()
  
    private lazy var average: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(.init(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemTeal
        return button
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
        contentView.addSubviews(containerView)
        containerView.addSubviews(headerStackView)

    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        headerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func configureViews() {
        containerView.backgroundColor = .secondarySystemBackground
    }

    
    // MARK: - Setup
    func setup(with episodes: [Serie], dependencies: Dependencies) {
        setupAverage(episodes.first?.rating.average)
        label.text = episodes.first?.name
    }
    
    func setupAverage(_ average: Double?) {
        var averageText = "-"
        if let average = average {
            averageText = "\(average)"
        }
        self.average.setTitle(averageText, for: .normal)
        self.average.setTitleColor(.label, for: .normal)
    }
}
