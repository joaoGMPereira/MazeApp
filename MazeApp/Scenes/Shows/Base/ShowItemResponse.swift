import Foundation

typealias ShowItemResponses = [ShowItemResponse]
typealias SearchShowItemResponses = [SearchShowItemResponse]

struct SearchShowItemResponse: Decodable {
    let show: ShowItemResponse
}

// MARK: - ShowItemResponse
struct ShowItemResponse: Decodable {
    let id: Int
    let name: String
    let rating: Rating
    let image: Image?
}

// MARK: - Image
struct Image: Codable {
    let medium, original: String
}

// MARK: - Rating
struct Rating: Codable {
    let average: Double?
}
