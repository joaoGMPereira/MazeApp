import UIKit

class CollectionViewHeader: UICollectionReusableView, ViewConfiguration {
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
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
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(layoutMarginsGuide)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
}
