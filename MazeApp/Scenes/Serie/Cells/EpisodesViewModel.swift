struct EpisodesViewModel: CellViewModelling {
    let items: [EpisodeCellViewModel]
}

struct EpisodeCellViewModel {
    let number: String
    let date: Content
    let name: Content
    let score: Content
    let season: Int?
    let nameIsHighlighted: Bool
    
    static func cell(
        number: String,
        date: String,
        name: String,
        score: String,
        season: Int
    ) -> EpisodeCellViewModel {
        .init(number: number,
              date: .cell(title: date),
              name: .cell(title: name, font: .preferredFont(for: .footnote, weight: .bold)),
              score: .cell(title: score, image: "star.fill"),
              season: season,
              nameIsHighlighted: true);
    }
}
