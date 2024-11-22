import Foundation
import CoreData

@MainActor
protocol TeamListViewModel {
    var teamsList: [Team] { get }
    
    func checkTeamsData() async
}

@MainActor
final class DefaultTeamListViewModel: TeamListViewModel, ObservableObject {
    
    // MARK: - Properties
    
    enum SelectedView {
        case list
        case grid
        
        var label: String {
            switch self {
            case .list:
                return "Grid"
            case .grid:
                return "List"
            }
        }
    }
    @Published private(set) var isTeamsUpdating = false
    @Published private(set) var viewSelector: SelectedView = .list
    private(set) var teamsList: [Team] = []
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
    
    private func teamsNeedUpdate() -> Bool {
        let lastUpdateDate = UserDefaults.standard.object(forKey: UpdateTime.team.cofigurationKey) as? Date
        guard
            let lastUpdateDate,
            abs(lastUpdateDate.timeIntervalSinceNow) < UpdateTime.team.timeInterval
        else {
            return true
        }
        return false
    }
    
    // MARK: - Methods
    
    func checkTeamsData() async {
        isTeamsUpdating = true
        if teamsNeedUpdate() {
            await saveTeamsDataFromAPI()
        }
        fetchTeamsDataFromCoreData()
        isTeamsUpdating = false
    }

    func changeView() {
        switch viewSelector {
        case .list:
            viewSelector = .grid
        case .grid:
            viewSelector = .list
        }
    }
}
