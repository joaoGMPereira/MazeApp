import UIKit

extension UIImage {
    func corner(radius: CGFloat = 16) -> UIImage {
        let imageLayer = CALayer()
        let frame = CGRect(origin: .zero, size: size)
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        imageLayer.frame = frame
        imageLayer.contents = cgImage
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = cornerRadius
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        if let imageContext = UIGraphicsGetCurrentContext() {
            imageLayer.render(in: imageContext)
        }
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage ?? UIImage()
    }
}
