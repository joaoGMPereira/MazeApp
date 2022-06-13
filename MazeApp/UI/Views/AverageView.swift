import UIKit

enum AverageView {
    static func create() -> UIButton {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(.init(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemTeal
        return button
    }
}
