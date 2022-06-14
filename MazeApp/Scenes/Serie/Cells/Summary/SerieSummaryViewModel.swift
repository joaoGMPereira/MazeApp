import UIKit

struct SerieSummaryViewModel: CellViewModelling {
    struct Content {
        let title: String
        let subtitle: NSAttributedString?
        let isHidden: Bool
        init(title: String, subtitle: NSAttributedString?, isHidden: Bool) {
            self.title = title
            self.subtitle = subtitle
            self.isHidden = isHidden
        }
    }
    let imageUrl: String?
    let summary: Content
    let schedule: Content
    let genres: Content
}
