import UIKit

struct SummaryViewModel: CellViewModelling {
    let summary: Content
    let imageUrl: String?
    let schedule: Content
    let genres: [Content]
    init(
        summary: Content,
        imageUrl: String?,
        schedule: Content,
        genres: [Content] = []
    ) {
        self.summary = summary
        self.imageUrl = imageUrl
        self.schedule = schedule
        self.genres = genres
    }
}
