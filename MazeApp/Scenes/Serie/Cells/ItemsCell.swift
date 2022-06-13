import UIKit
import SnapKit

struct ItemsViewModel: CellViewModelling {
    let items: [ItemViewModel]
}

struct ItemViewModel {
    let firstTitle: String, secondTitle: String, thirdTitle: String, fourthTitle: String
    let firstImage: String?, secondImage: String?, thirdImage: String?, fourthImage: String?
    let firstFont: UIFont, secondFont: UIFont, thirdFont: UIFont, fourthFont: UIFont
    let isFlexibles: Bool
    
    static func header(
        firstTitle: String,
        secondTitle: String,
        thirdTitle: String,
        fourthTitle: String,
        firstFont: UIFont = .preferredFont(for: .callout, weight: .bold),
        secondFont: UIFont = .preferredFont(for: .callout, weight: .bold),
        thirdFont: UIFont = .preferredFont(for: .callout, weight: .bold),
        fourthFont: UIFont = .preferredFont(for: .callout, weight: .bold)
    ) -> ItemViewModel {
        .init(firstTitle: firstTitle,
              secondTitle: secondTitle,
              thirdTitle: thirdTitle,
              fourthTitle: fourthTitle,
              firstImage: nil,
              secondImage: nil,
              thirdImage: nil,
              fourthImage: nil,
              firstFont: firstFont,
              secondFont: secondFont,
              thirdFont: thirdFont,
              fourthFont: fourthFont,
              isFlexibles: false)
    }
    
    static func body(
        firstTitle: String,
        secondTitle: String,
        thirdTitle: String,
        fourthTitle: String,
        firstFont: UIFont = .preferredFont(for: .footnote, weight: .medium),
        secondFont: UIFont = .preferredFont(for: .footnote, weight: .medium),
        thirdFont: UIFont = .preferredFont(for: .footnote, weight: .medium),
        fourthFont: UIFont = .preferredFont(for: .footnote, weight: .medium)
    ) -> ItemViewModel {
        .init(firstTitle: firstTitle,
              secondTitle: secondTitle,
              thirdTitle: thirdTitle,
              fourthTitle: fourthTitle,
              firstImage: nil,
              secondImage: nil,
              thirdImage: nil,
              fourthImage: "star.fill",
              firstFont: firstFont,
              secondFont: secondFont,
              thirdFont: thirdFont,
              fourthFont: fourthFont,
              isFlexibles: true)
    }
}

final class ItemsCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstLabel, secondLabel, thirdLabel, fourthLabel])
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var firstLabel = FlexibleLabel()
    
    private lazy var secondLabel = FlexibleLabel()
    
    private lazy var thirdLabel = FlexibleLabel()
    
    private lazy var fourthLabel = FlexibleLabel()
    
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
        thirdLabel.text = model.thirdTitle
        fourthLabel.text = model.fourthTitle
        
        firstLabel.font = model.firstFont
        secondLabel.font = model.secondFont
        thirdLabel.font = model.secondFont
        fourthLabel.font = model.secondFont
        
        firstLabel.setup(isFlexible: model.isFlexibles, imageName: model.firstImage)
        secondLabel.setup(isFlexible: model.isFlexibles, imageName: model.secondImage)
        thirdLabel.setup(isFlexible: model.isFlexibles, imageName: model.thirdImage)
        fourthLabel.setup(isFlexible: model.isFlexibles, imageName: model.fourthImage)
    }
}

