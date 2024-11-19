import Foundation

struct GameListResponse: Codable {
    let data: [GameDataResponse]
}

struct GameDataResponse: Codable {
    let local: ClubResponse
    let road: ClubResponse
    let date: String
    let played: Bool
}

struct ClubResponse: Codable {
    let club: ClubDetailsResponse
}

struct ClubDetailsResponse: Codable {
    let name: String
}
