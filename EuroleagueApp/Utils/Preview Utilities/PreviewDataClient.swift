import Alamofire

class PreviewDataClient: EuroleagueDataClient {
    func fetchTeamsData() async throws -> TeamListResponse {
        return TeamListResponse(
            data: [TeamDataResponse(
                name: "Test team name",
                images: TeamImagesResponse(crest: "https://picsum.photos/200"),
                address: "Test team address",
                code: "ZAL"
            )],
            total: 1
        )
    }
    
    func fetchGamesData(teamCode: String) async throws -> GameListResponse {
        return GameListResponse(
            data: [GameDataResponse(
                local: ClubResponse(club: ClubDetailsResponse(name: "ZALGIRIS")),
                road: ClubResponse(club: ClubDetailsResponse(name: "ZAL")),
                date: "now",
                played: false
            )]
        )
    }
    
    func fetchPlayersData(teamCode: String) async throws -> [PlayerListResponse] {
        return [PlayerListResponse(
            person: PersonResponse(name: "",
                                   height: 0,
                                   weight: 0,
                                   birthDate: "",
                                   country: CountryResponse(name: "")
                                  ),
            dorsal: "11",
            positionName: "",
            lastTeam: "",
            images: ImageResponse(action: ""),
            club: PlayerClubResponse(code: "ZAL")
        )]
    }
}
