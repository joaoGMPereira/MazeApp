import UIKit

struct SummaryViewModel: CellViewModelling {
    struct Content {
        let title: String
        let subtitle: NSAttributedString?
        let isHidden: Bool
        init(title: String, subtitle: NSAttributedString?, isHidden: Bool = false) {
            self.title = title
            self.subtitle = subtitle
            self.isHidden = isHidden
        }
    }
    let imageUrl: String?
    let infos: [Content]
}
