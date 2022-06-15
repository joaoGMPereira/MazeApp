import UIKit
import SnapKit

final class ItemsCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, scoreLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var nameLabel = Label()
    
    private lazy var scoreLabel: Label = {
        let scoreLabel = Label()
        scoreLabel.label.textAlignment = .left
        return scoreLabel
    }()
    
    private lazy var dateLabel: Label = {
        let dateLabel = Label()
        dateLabel.label.textAlignment = .right
        return dateLabel
    }()
    private lazy var chevron: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
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
        contentView.addSubviews(stackView, dateLabel, chevron)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(8)
            $0.trailing.equalTo(dateLabel.snp.leading).inset(-4)
            $0.width.greaterThanOrEqualToSuperview().multipliedBy(0.5)
        }
        
        dateLabel.snp.makeConstraints {
            $0.bottom.top.equalToSuperview().inset(8)
            $0.trailing.equalTo(chevron.snp.leading).inset(-8)
        }
        
        chevron.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(15)
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    func setup(model: EpisodeCellViewModel) {
        dateLabel.setup(text: model.date.title,
                        font: model.date.font,
                        imageName: model.date.image)
        nameLabel.setup(text: model.name.title,
                        font: model.name.font,
                        imageName: model.name.image)
        scoreLabel.setup(text: model.score.title,
                         font: model.score.font,
                         imageName: model.score.image)
    }
}
