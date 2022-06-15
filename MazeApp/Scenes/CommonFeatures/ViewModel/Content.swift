import UIKit
struct Content {
    let title: String
    let font: UIFont
    let alignment: NSTextAlignment
    let image: String?
    let isHidden: Bool
    init(title: String,
         font: UIFont = .preferredFont(for: .footnote, weight: .bold),
         alignment: NSTextAlignment = .justified,
         image: String? = nil,
         isHidden: Bool = false) {
        self.title = title
        self.font = font
        self.alignment = alignment
        self.image = image
        self.isHidden = isHidden
    }
    
    static func cell(title: String,
                     image: String? = nil,
                     alignment: NSTextAlignment = .justified,
                     font: UIFont = .preferredFont(for: .footnote, weight: .medium)) -> Content {
        .init(title: title,
              font: font, alignment: alignment, image: image)
    }
}
