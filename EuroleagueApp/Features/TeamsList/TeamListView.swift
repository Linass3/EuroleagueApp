import SwiftUI
import CoreData

struct TeamListView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let listButtonTitle: String = "List"
        static let gridButtonTitle: String = "Grid"
        static let navigationBarTitle: String = "Euroleague"
    }
    
    // MARK: - Properties

    @StateObject private var viewModel: DefaultTeamListViewModel
    
    init(viewModel: @autoclosure @escaping () -> DefaultTeamListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.isTeamsUpdating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.black)
                    .scaleEffect(1.5)
            } else {
                content
            }
        }
        .task {
            await viewModel.checkTeamsData()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.changeView) {
                    Text(viewModel.viewSelector.label)
                }
            }
        }
        .navigationTitle(Constants.navigationBarTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Views
    
    private var content: some View {
        switch viewModel.viewSelector {
        case .list:
            AnyView(listView)
        case .grid:
            AnyView(gridView)
        }
    }
    
    private var listView: some View {
        List(viewModel.teamsList, id: \.objectID) { team in
            ZStack {
                TeamListItem(team: team)
                NavigationLink(destination: TeamDetailsView(viewModel: DefaultTeamDetailsViewModel(team: team))) {
                    EmptyView()
                }
                .opacity(0)
            }
            .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0,
                         leading: 20,
                         bottom: 0,
                         trailing: 20))
        }
        .listStyle(.plain)
    }
    
    private var gridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.fixed(190)), GridItem(.fixed(190))],
                spacing: 20
            ) {
                ForEach(viewModel.teamsList, id: \.objectID) { team in
                    NavigationLink(destination: TeamDetailsView(viewModel: DefaultTeamDetailsViewModel(team: team))) {
                        TeamGridItem(team: team)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Preview

#Preview {
    return TeamListView(viewModel: DefaultTeamListViewModel())
}
