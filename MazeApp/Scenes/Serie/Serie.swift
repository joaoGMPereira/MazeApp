import Foundation
typealias Series = [Serie]

// MARK: - WelcomeElement
struct Serie: Decodable {
    let id: Int
    let name: String
    let season, number: Int
    let airdate: String
    let airtime: String
    let runtime: Int
    let rating: Rating
    let image: Image?
    let summary: String?
}
