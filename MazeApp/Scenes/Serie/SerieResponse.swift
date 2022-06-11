import Foundation

typealias SerieResponses = [SerieResponse]

// MARK: - SerieResponse
struct SerieResponse: Decodable {
    let id: Int
    let url: String
    let name: String
    let type: String
    let language: String
    let genres: [String]
    let status: String
    let runtime: Int?
    let averageRuntime: Int?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let schedule: Schedule
    let rating: Rating
    let weight: Int
    let network, webChannel: Network?
    let dvdCountry: Country?
    let externals: Externals
    let image: Image?
    let summary: String?
    let updated: Int
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id, url, name, type, language, genres, status, runtime, averageRuntime, premiered, ended, officialSite, schedule, rating, weight, network, webChannel, dvdCountry, externals, image, summary, updated
        case links = "_links"
    }
}

extension SerieResponse {
    
    // MARK: - Country
    struct Country: Codable {
        let name: String
        let code: String
        let timezone: String
    }
    
    // MARK: - Externals
    struct Externals: Codable {
        let tvrage: Int?
        let thetvdb: Int?
        let imdb: String?
    }
    
    // MARK: - Links
    struct Links: Codable {
        let linksSelf: Episode
        let previousEpisode: Episode?
        let nextEpisode: Episode?
        
        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case previousEpisode = "previousepisode"
            case nextEpisode = "nextepisode"
        }
    }
    
    // MARK: - Episode
    struct Episode: Codable {
        let href: String
    }
    
    // MARK: - Network
    struct Network: Codable {
        let id: Int
        let name: String
        let country: Country?
        let officialSite: String?
    }
    
    // MARK: - Image
    struct Image: Codable {
        let medium, original: String
    }
    
    // MARK: - Rating
    struct Rating: Codable {
        let average: Double?
    }
    
    // MARK: - Schedule
    struct Schedule: Codable {
        let time: String
        let days: [String]
    }
}
