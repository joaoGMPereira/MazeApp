import UIKit

final class FeedbackView: UIView, ViewConfiguration {
    enum Layout {
        static let spacing = CGFloat(8)
        static let buttonHeight = CGFloat(44)
    }
    lazy var component: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = Layout.spacing
        return stack
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView(image: .init(systemName: "questionmark.folder.fill"))
        image.preferredSymbolConfiguration = .init(pointSize: 100)
        image.tintColor = .systemTeal
        return image
    }()
    
    lazy var title: UILabel = {
       let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = .preferredFont(for: .body, weight: .bold)
        return label
    }()
    
    lazy var subtitle: UILabel = {
       let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = .preferredFont(for: .body, weight: .medium)
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(primaryAction: .init() { [weak self] _ in self?.completion?() })
        button.backgroundColor = .systemTeal
        button.corner()
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var completion: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViewHierarchy() {
        addSubviews(image, component, button)
        component.addArrangedSubviews(title, subtitle)
    }
    
    func setupConstraints() {
        image.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(component.snp.top).inset(-Layout.spacing)
        }
        
        component.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.top.equalTo(component.snp.bottom).inset(-Layout.spacing)
            $0.bottom.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.greaterThanOrEqualTo(Layout.buttonHeight)
        }
    }
    
    func setupCommponents(title: String? = nil,
                          subtitle: String? = nil,
                          buttonName: String? = nil,
                          completion: (() -> Void)? = nil) {
        self.completion = completion
        self.title.text = title
        self.subtitle.text = subtitle
        self.button.setTitle(buttonName, for: .normal)
        self.title.isHidden = title == nil
        self.subtitle.isHidden = subtitle == nil
        self.button.isHidden = buttonName == nil
    }
}
