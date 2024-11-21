import SwiftUI

@main
private struct EuroleagueApp: App {
    
    private struct MainAppView: View {
        init() {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.systemOrange
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        var body: some View {
            NavigationStack {
                TeamListView(viewModel: DefaultTeamListViewModel())
            }
            .preferredColorScheme(.light)
            .tint(.white)
        }
    }

    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
    }
}
