import QuartzCore
import UIKit

extension CALayer {
    func setShadow(radius: CGFloat = 8, offSet: CGSize = .init(width: 0.5, height: 0.5), color: UIColor = .systemGray, opacity: Float = 0.5, cgPath: CGPath? = nil) {
        shadowOffset = offSet
        shadowRadius = radius
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowPath = cgPath
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
}
