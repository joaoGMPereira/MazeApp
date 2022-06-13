import UIKit

final class ScrollableStack: UIScrollView {
    let stackView: UIStackView
    private var axisConstraint: NSLayoutConstraint?
    
    init(arrangedSubviews: [UIView],
         axis: NSLayoutConstraint.Axis = .horizontal,
         distribution: UIStackView.Distribution = .fill,
         spacing: CGFloat = 8) {
        stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.distribution = .fillProportionally
        stackView.spacing = spacing
        super.init(frame: .zero)
        buildLayout()
        configure(with: axis)
    }
    required init?(coder aDecoder: NSCoder) {
        stackView = UIStackView()
        super.init(coder: aDecoder)
        buildLayout()
    }
    
    override init(frame: CGRect) {
        stackView = UIStackView()
        super.init(frame: frame)
        buildLayout()
    }
}

extension ScrollableStack: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
}

extension ScrollableStack {
    func configure(with axis: NSLayoutConstraint.Axis) {
        axisConstraint?.isActive = false
        if axis == .vertical {
            axisConstraint = stackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        }
        if axis == .horizontal {
            axisConstraint = stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        }
        axisConstraint?.isActive = true
    }
}
