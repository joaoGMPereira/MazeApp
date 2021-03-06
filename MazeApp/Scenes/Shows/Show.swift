import Foundation

typealias Shows = [Show]
typealias SearchShows = [SearchShow]

struct SearchShow: Decodable {
    let show: Show
}

// MARK: - Show
struct Show: Codable {
    let id: Int
    let name: String
    let genres: [String]
    let schedule: Schedule
    let rating: Rating
    let image: Image?
    let runtime: Int?
    let averageRuntime: Int?
    let summary: String?
    
}

extension Show {
    // MARK: - Schedule
    struct Schedule: Codable {
        let time: String
        let days: [String]
    }

}
