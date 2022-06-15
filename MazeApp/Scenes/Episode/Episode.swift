import Foundation

// MARK: - Welcome
struct Episode: Decodable {
    let id: Int
    let name: String
    let season, number: Int
    let rating: Rating
    let image: Image?
    let summary: String?
    let airtime: String?
    let runtime: Int?
}

