import UIKit

class Label: UIView, ViewConfiguration {
    // MARK: - UI Properties
    private lazy var containerView = UIView()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        return label
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray2
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
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.size.equalTo(15)
        }
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).inset(-4)
            $0.top.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(-4)
        }
    }
    
    func setup(
        text: String,
        font: UIFont,
        alignment: NSTextAlignment = .justified,
        imageName: String? = nil
    ) {
        label.text = text
        label.font = font
        label.textAlignment = alignment
        configImage(imageName)
    }
    
    func setupAttributed(
        text: NSAttributedString?,
        imageName: String? = nil
    ) {
        label.attributedText = text
        label.textColor = .label
        configImage(imageName)
    }
    
    func configImage(_ imageName: String?) {
        label.snp.remakeConstraints {
            if let imageName = imageName {
                imageView.image = .init(systemName: imageName)
                $0.leading.equalTo(imageView.snp.trailing).inset(-4)
            } else {
                imageView.image = nil
                $0.leading.equalToSuperview()
            }
            $0.bottom.top.trailing.equalToSuperview()
        }
    }
}


class LabelCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    private lazy var label = Label()
    private lazy var containerView = UIView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(label)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func setup(
        text: String,
        font: UIFont,
        alignment: NSTextAlignment,
        imageName: String? = nil
    ) {
        label.setup(
            text: text,
            font: font,
            alignment: alignment,
            imageName: imageName
        )
        containerView.corner(borderWidth: 1, borderColor: .label)
    }
}
