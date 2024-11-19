import SwiftUI

@main
struct EuroleagueApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: DefaultTeamListViewModel())
        }
    }
}
