import UIKit

class FlexibleLabel: UIView, ViewConfiguration {
    // MARK: - UI Properties
    var text = String() {
        didSet {
            label.text = text
        }
    }
    
    var font = UIFont() {
        didSet {
            label.font = font
        }
    }
    
    private lazy var containerView = UIView()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemTeal
        return imageView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubviews(imageView, label)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).inset(-4)
            $0.top.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func setup(isFlexible: Bool, imageName: String? = nil) {
        label.snp.remakeConstraints {
            if let imageName = imageName {
                imageView.image = .init(systemName: imageName)
                $0.leading.equalTo(imageView.snp.trailing).inset(-4)
            } else {
                imageView.image = nil
                $0.leading.equalToSuperview()
            }
            $0.top.trailing.equalToSuperview()
            if isFlexible {
                $0.bottom.lessThanOrEqualToSuperview()
            } else {
                $0.bottom.equalToSuperview()
            }
        }
    }
}
