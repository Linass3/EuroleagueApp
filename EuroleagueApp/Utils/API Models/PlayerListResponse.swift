import Foundation

struct PlayerListResponse: Codable {
    let person: PersonResponse
    let dorsal: String
    let positionName: String
    let lastTeam: String
    let images: ImageResponse?
    let club: PlayerClubResponse
}

struct PersonResponse: Codable {
    let name: String
    let height: Int
    let weight: Int
    let birthDate: String
    let country: CountryResponse
}

struct CountryResponse: Codable {
    let name: String
}

 struct ImageResponse: Codable {
    let action: String?
}

struct PlayerClubResponse: Codable {
    let code: String
}
