import UIKit

struct EpisodesViewModel: CellViewModelling {
    let items: [EpisodeViewModel]
}

struct EpisodeViewModel {
    struct Content {
        let title: String
        let font: UIFont
        let image: String?
        init(title: String, font: UIFont, image: String? = nil) {
            self.title = title
            self.font = font
            self.image = image
        }
        
        static func header(title: String,
                           image: String? = nil,
                           season: Int? = nil,
                           font: UIFont = .preferredFont(for: .callout, weight: .bold)) -> Content {
            .init(title: title, font: font, image: image)
        }
        
        static func body(title: String,
                         image: String? = nil,
                         font: UIFont = .preferredFont(for: .footnote, weight: .medium)) -> Content {
            .init(title: title, font: font, image: image)
        }
    }
    let number: Content
    let date: Content
    let name: Content
    let score: Content
    let season: Int?
    let nameIsHighlighted: Bool
    
    static func header(
        number: String,
        date: String,
        name: String,
        score: String
    ) -> EpisodeViewModel {
        .init(number: .header(title: number),
              date: .header(title: date),
              name: .header(title: name),
              score: .header(title: score),
              season: nil,
              nameIsHighlighted: false)
    }
    
    static func body(
        number: String,
        date: String,
        name: String,
        score: String,
        season: Int
    ) -> EpisodeViewModel {
        .init(number: .body(title: number),
              date: .body(title: date),
              name: .body(title: name),
              score: .body(title: score, image: "star.fill"),
              season: season,
              nameIsHighlighted: true);
    }
}
