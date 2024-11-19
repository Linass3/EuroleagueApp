import Foundation
import CoreData

@MainActor
protocol TeamDetailsViewModel {
    var gamesList: [Game] { get }
    var playersList: [Player] { get }
    var team: Team { get }
    
    mutating func checkGamesData(forceUpdate: Bool) async
    mutating func checkPlayersData() async
    func gamesNeedUpdate() -> Bool
    func playersNeedUpdate() -> Bool
}

struct DefaultTeamDetailsViewModel: TeamDetailsViewModel {

    // MARK: - Properties
    
    private(set) var team: Team
    private(set) var gamesList: [Game] = []
    private(set) var playersList: [Player] = []
    private var euroleagueDataClient: EuroleagueDataClient
    private var context: NSManagedObjectContext
    
    init(team: Team) {
        self.euroleagueDataClient = SwinjectUtility.forceResolve(EuroleagueDataClient.self)
        self.context = SwinjectUtility.forceResolve(NSManagedObjectContext.self)
        self.team = team
    }
    
    // MARK: - Games Data Methods
    
    private func saveGamesDataFromAPI() async {
        do {
            let gameListResponse = try await euroleagueDataClient.fetchGamesData(teamCode: team.code)
            for gameData in gameListResponse.data where !gameData.played {
                let newGame = Game(context: context)
                newGame.date = gameData.date
                newGame.team = gameData.local.club.name
                newGame.opponent = gameData.road.club.name
            }
            try context.save()
            UserDefaults.standard.set(Date(), forKey: UpdateTime.game(code: team.code).cofigurationKey)
        } catch {
            print("Error fetching games data from API or saving to CoreData: \(error)")
        }
    }
    
    mutating private func fetchGamesDataFromCoreData() {
        do {
            let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "team == %@ OR opponent == %@", team.name, team.name)
            let games = try context.fetch(fetchRequest)
            gamesList = games
        } catch {
            print("Error fetching games data from CoreData: \(error)")
            gamesList = []
        }
        gamesList.sort { $0.date < $1.date }
    }
    
    func gamesNeedUpdate() -> Bool {
        let lastUpdateDate = UserDefaults.standard.object(forKey: UpdateTime.game(code: team.code).cofigurationKey) as? Date
        guard let lastUpdateDate, abs(lastUpdateDate.timeIntervalSinceNow) < UpdateTime.game(code: team.code).timeInterval else {
            return true
        }
        return false
    }
    
    mutating func checkGamesData(forceUpdate: Bool) async {
        if gamesNeedUpdate() || forceUpdate {
            await saveGamesDataFromAPI()
        }
        fetchGamesDataFromCoreData()
    }
    
    // MARK: - Players Data Methods
    
    private func savePlayersDataFromAPI() async {
        do {
            let playerListResponse = try await euroleagueDataClient.fetchPlayersData(teamCode: team.code)
            for playerData in playerListResponse {
                let newPlayer = Player(context: context)
                newPlayer.name = playerData.person.name
                newPlayer.image = playerData.images?.action
                newPlayer.country = playerData.person.country.name
                newPlayer.position = playerData.positionName
                newPlayer.height = Int16(playerData.person.height)
                newPlayer.weight = Int16(playerData.person.weight)
                newPlayer.lastTeam = playerData.lastTeam
                newPlayer.birthDate = playerData.person.birthDate
                newPlayer.number = playerData.dorsal
                newPlayer.clubCode = playerData.club.code
            }
            try context.save()
            UserDefaults.standard.set(Date(), forKey: UpdateTime.player(code: team.code).cofigurationKey)
        } catch {
            print("Error fetching players data from API or saving to CoreData: \(error)")
        }
    }
    
    mutating private func fetchPlayersDataFromCoreData() {
        do {
            let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "clubCode == %@", team.code)
            let players = try context.fetch(fetchRequest)
            playersList = players
        } catch {
            print("Error fetching players data from CoreData: \(error)")
            playersList = []
        }
    }
    
    func playersNeedUpdate() -> Bool {
        let lastUpdateDate = UserDefaults.standard.object(forKey: UpdateTime.player(code: team.code).cofigurationKey) as? Date
        guard let lastUpdateDate, abs(lastUpdateDate.timeIntervalSinceNow) < UpdateTime.player(code: team.code).timeInterval else {
            return true
        }
        return false
    }
    
    mutating func checkPlayersData() async {
        if playersNeedUpdate() {
            await savePlayersDataFromAPI()
        }
        fetchPlayersDataFromCoreData()
    }
}
