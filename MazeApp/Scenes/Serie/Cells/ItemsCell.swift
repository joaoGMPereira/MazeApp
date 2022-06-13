import UIKit
import SnapKit

final class ItemsCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstLabel, secondLabel, thirdLabel, fourthLabel])
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var firstLabel = Label()
    
    private lazy var secondLabel = Label()
    
    private lazy var thirdLabel = Label()
    
    private lazy var fourthLabel = Label()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(stackView)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func setup(model: ItemViewModel) {
        firstLabel.text = model.firstTitle
        secondLabel.text = model.secondTitle
        setupThirdHighlighted(model.nameIsHighlited, text: model.thirdTitle)
        fourthLabel.text = model.fourthTitle
        
        firstLabel.font = model.firstFont
        secondLabel.font = model.secondFont
        thirdLabel.font = model.secondFont
        fourthLabel.font = model.secondFont

        firstLabel.setup(imageName: model.firstImage)
        secondLabel.setup(imageName: model.secondImage)
        thirdLabel.setup(imageName: model.thirdImage)
        fourthLabel.setup(imageName: model.fourthImage)
    }
    
    func setupThirdHighlighted(_ isHighlighted: Bool, text: String) {
        guard isHighlighted else {
            thirdLabel.text = text
            return
        }
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
        thirdLabel.label.attributedText = underlineAttributedString
    }
}

