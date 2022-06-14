import UIKit
import SnapKit

final class ItemsCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [numberLabel, dateLabel, nameLabel, scoreLabel])
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var numberLabel = Label()
    
    private lazy var dateLabel = Label()
    
    private lazy var nameLabel = Label()
    
    private lazy var scoreLabel = Label()
    
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
    
    func setup(model: EpisodeCellViewModel) {
        numberLabel.setup(text: model.number.title,
                          font: model.number.font,
                          imageName: model.number.image)
        dateLabel.setup(text: model.date.title,
                        font: model.number.font,
                        imageName: model.date.image)
        nameLabel.setup(text: model.name.title,
                        font: model.number.font,
                        imageName: model.name.image,
                        isHighlighted: model.nameIsHighlighted)
        scoreLabel.setup(text: model.score.title,
                         font: model.number.font,
                         imageName: model.score.image)
    }
}

