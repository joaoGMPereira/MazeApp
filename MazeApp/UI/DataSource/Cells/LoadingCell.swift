import UIKit
import SnapKit

struct LoadingModel: CellViewModelling {}

final class LoadingCell: UICollectionViewCell, ViewConfiguration {
    // MARK: - UI Properties
    private lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.hidesWhenStopped = true
        return loading
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }
    
    // MARK: - View Configuration
    func buildViewHierarchy() {
        contentView.addSubviews(loading)
    }
    
    func setupConstraints() {
        loading.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    func load() {
        loading.startAnimating()
    }
}
