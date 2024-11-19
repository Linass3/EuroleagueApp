import Foundation
import Alamofire

@MainActor
protocol EuroleagueDataClient {
    func fetchTeamsData() async throws -> TeamListResponse
    func fetchGamesData(teamCode: String) async throws -> GameListResponse
    func fetchPlayersData(teamCode: String) async throws -> [PlayerListResponse]
}

@MainActor
final class DefaultEuroleagueDataClient: EuroleagueDataClient {
    
    private let baseURL = URL(filePath: "https://api-live.euroleague.net/v2")
    private let competitions = "/competitions"
    private let seasons = "/seasons"
    private let clubs = "/clubs"
    private let games = "/games"
    private let people = "/people"
    private let currentCompetition = "/E"
    private let currentSeason = "/E2024"
    private let personQueryValue = "J"
    private let personQueryName = "personType"
    private let teamQueryName = "teamCode"

    func fetchTeamsData() async throws -> TeamListResponse {
        return try await AF
            .request(baseURL.appendingPathComponent(competitions + currentCompetition + seasons + currentSeason + clubs, conformingTo: .url))
            .serializingDecodable(TeamListResponse.self)
            .value
    }
    
    func fetchGamesData(teamCode: String) async throws -> GameListResponse {
        let teamQuery = URLQueryItem(name: teamQueryName, value: teamCode)
        return try await AF
            .request(baseURL
                .appendingPathComponent(competitions + currentCompetition + seasons + currentSeason + games)
                .appending(queryItems: [teamQuery]))
            .serializingDecodable(GameListResponse.self)
            .value
    }
    
    func fetchPlayersData(teamCode: String) async throws -> [PlayerListResponse] {
        let teamPath = "/\(teamCode)"
        let playerQuery = URLQueryItem(name: personQueryName, value: personQueryValue)
        return try await AF
            .request(baseURL
                .appendingPathComponent(competitions + currentCompetition + seasons + currentSeason + clubs + teamPath + people)
                .appending(queryItems: [playerQuery]))
            .serializingDecodable([PlayerListResponse].self)
            .value
    }
}
