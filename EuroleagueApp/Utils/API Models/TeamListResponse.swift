import Foundation

struct TeamListResponse: Codable {
    let data: [TeamDataResponse]
    let total: Int
}

struct TeamDataResponse: Codable {
    let name: String
    let images: TeamImagesResponse
    let address: String
    let code: String
}

struct TeamImagesResponse: Codable {
    let crest: String
}
