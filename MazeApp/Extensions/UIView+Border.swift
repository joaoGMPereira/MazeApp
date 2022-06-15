import UIKit
extension UIView {
    func corner(_ cornerRadius: CGFloat = 8,
                borderWidth: CGFloat = .zero,
                borderColor: UIColor = .clear,
                maskedCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
                clipToBounds: Bool = true) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        self.clipsToBounds = clipToBounds
    }
}
