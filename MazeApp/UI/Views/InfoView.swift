import UIKit
import SnapKit

class InfoView: UIView, ViewConfiguration {
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .preferredFont(for: .body, weight: .bold)
        return label
    }()
    
    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .preferredFont(for: .callout, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViewHierarchy() {
        addSubviews(title, subtitle)
    }
    
    func setupConstraints() {
        title.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(30)
        }
        
        subtitle.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).inset(-4)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.greaterThanOrEqualTo(30)
        }
    }
    
    func setup(title: String, subtitle: NSAttributedString?) {
        self.title.text = title
        self.subtitle.attributedText = subtitle
        self.subtitle.textColor = .label
        self.layoutIfNeeded()
    }
}
