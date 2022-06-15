import Foundation

// MARK: - Image
struct Image: Codable {
    let medium, original: String
}

// MARK: - Rating
struct Rating: Codable {
    let average: Double?
}
