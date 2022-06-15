import UIKit

struct SummaryViewModel: CellViewModelling {
    let summary: Content
    let imageUrl: String?
    let score: Content
    let schedule: Content
    let genres: [Content]
    init(
        summary: Content,
        imageUrl: String?,
        score: Content,
        schedule: Content,
        genres: [Content] = []
    ) {
        self.summary = summary
        self.imageUrl = imageUrl
        self.score = score
        self.schedule = schedule
        self.genres = genres
    }
}
