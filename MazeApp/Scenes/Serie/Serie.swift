import Foundation
typealias Series = [Serie]

// MARK: - WelcomeElement
struct Serie: Codable {
    let id: Int
    let url: String
    let name: String
    let season, number: Int
    let type: String
    let airdate: String
    let airtime: String
    let airstamp: Date
    let runtime: Int
    let rating: Rating
    let image: Image
    let summary: String
}

extension Serie {
    // MARK: - Image
    struct Image: Codable {
        let medium, original: String
    }
    
    // MARK: - Rating
    struct Rating: Codable {
        let average: Double
    }
}
