import UIKit
extension UIView {
    func corner(_ cornerRadius: CGFloat = 8,
                maskedCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
                clipToBounds: Bool = true) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        self.clipsToBounds = clipToBounds
    }
}
