import UIKit
import SnapKit

extension FeedbackModel: CellViewModelling {}

final class FeedbackCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    
    private lazy var feedback = FeedbackView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(feedback)
    }
    
    func setupConstraints() {
        feedback.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    func setupCommponents(model: FeedbackModel) {
        feedback.setupComponents(model: model)
    }
}
