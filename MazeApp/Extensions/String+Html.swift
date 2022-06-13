import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(htmlString: self).trimmedAttributedString()
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
