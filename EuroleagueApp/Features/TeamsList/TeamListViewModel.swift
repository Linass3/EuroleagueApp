import Foundation
import CoreData

@MainActor
protocol TeamListViewModel {
    var teamsList: [Team] { get }
    
    func checkTeamsData() async
    func teamsNeedUpdate() -> Bool
}

@MainActor
final class DefaultTeamListViewModel: TeamListViewModel, ObservableObject {
    
    // MARK: - Properties
    
    @Published var isUpdating = false
    var teamsList: [Team] = []
    private var euroleagueDataClient: EuroleagueDataClient
    private var context: NSManagedObjectContext
    
    init() {
        self.euroleagueDataClient = SwinjectUtility.forceResolve(EuroleagueDataClient.self)
        self.context = SwinjectUtility.forceResolve(NSManagedObjectContext.self)
    }
    
    // MARK: - Private
    
    private func saveTeamsDataFromAPI() async {
        do {
            let teamListResponse = try await euroleagueDataClient.fetchTeamsData()
            for teamData in teamListResponse.data {
                let newTeam = Team(context: context)
                newTeam.name = teamData.name
                newTeam.image = teamData.images.crest
                newTeam.address = teamData.address
                newTeam.code = teamData.code
            }
            try context.save()
            UserDefaults.standard.set(Date(), forKey: UpdateTime.team.cofigurationKey)
        } catch {
            print("Error fetching teams data from API or saving to CoreData: \(error)")
        }
    }
    
    private func fetchTeamsDataFromCoreData() {
        do {
            let teams = try context.fetch(Team.fetchRequest())
            teamsList = teams
        } catch {
            print("Error fetching teams data from CoreData: \(error)")
            teamsList = []
        }
    }
    
    // MARK: - Methods
    
    func checkTeamsData() async {
        isUpdating = true
        if teamsNeedUpdate() {
            await saveTeamsDataFromAPI()
        }
        fetchTeamsDataFromCoreData()
        do {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        } catch {
            
        }
        isUpdating = false
    }
    
    func teamsNeedUpdate() -> Bool {
        let lastUpdateDate = UserDefaults.standard.object(forKey: UpdateTime.team.cofigurationKey) as? Date
        guard let lastUpdateDate, abs(lastUpdateDate.timeIntervalSinceNow) < UpdateTime.team.timeInterval else {
            return true
        }
        return false
    }
}
