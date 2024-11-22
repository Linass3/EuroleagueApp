import SwiftUI
import CoreData

struct TeamDetailsView: View {
    
    // MARK: - Constants

    private enum SelectedView {
        case gamesList
        case playersList
    }
    
    private enum Constants {
        static let navigationBarTitle = "Team"
        static let pickerTitleLabel = "Data"
        static let pickerSelectionLabelOne = "Games"
        static let pickerSelectionLabelTwo = "Players"
        static let searchBarIcon = "magnifyingglass"
        static let searchBarPlaceholder = "Search by name, position or country"
        static let searchBarClearIcon = "xmark.circle.fill"
        static let imageHeight: CGFloat = 350
    }
    
    // MARK: - Properties
    
    @StateObject private var viewModel: DefaultTeamDetailsViewModel
    @State private var selectedView: SelectedView = .gamesList

    init(viewModel: @autoclosure @escaping () -> DefaultTeamDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            teamCardView
            
            segmentedControlView

            if viewModel.isUpdating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.black)
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                switch selectedView {
                case .gamesList:
                    gamesListView
                case .playersList:
                    playersListView
                }
            }
            
            Spacer()
        }
        .navigationTitle(Constants.navigationBarTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.checkData()
        }
    }
    
    // MARK: - Views
    
    private var teamCardView: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: viewModel.team.image)) { image in
                image
                    .resizable()
            } placeholder: {
                Color.clear
            }
            .scaledToFit()
            .frame(height: Constants.imageHeight)
            .clipped()
            
            ZStack(alignment: .trailing) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 70)
                
                Text(viewModel.team.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var segmentedControlView: some View {
        Picker(Constants.pickerTitleLabel, selection: $selectedView) {
            Text(Constants.pickerSelectionLabelOne).tag(SelectedView.gamesList)
            Text(Constants.pickerSelectionLabelTwo).tag(SelectedView.playersList)
        }
        .pickerStyle(.segmented)
        .padding(.leading, 60)
        .padding(.trailing, 60)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var gamesListView: some View {
        List(viewModel.gamesList, id: \.objectID) { game in
            ZStack {
                GameListItem(game: game)
            }
            .frame(height: 70)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await viewModel.checkGamesData(forceUpdate: true)
        }
    }
    
    private var playersListView: some View {
        VStack {
            HStack {
                Image(systemName: Constants.searchBarIcon)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField(Constants.searchBarPlaceholder, text: $viewModel.searchQuery)
                    .frame(maxWidth: .infinity)
                
                if !viewModel.searchQuery.isEmpty {
                    Button(action: resetSearchQuery) {
                        Image(systemName: Constants.searchBarClearIcon)
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                }
            }
            .frame(height: 35)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            
            List(viewModel.filteredPlayerList, id: \.objectID) { player in
                NavigationLink(destination: PlayerDetailsView(viewModel: DefaultPlayerDetailsViewModel(player: player))) {
                    PlayerListItem(player: player)
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(PlainListStyle())
        }
    }
    
    private func resetSearchQuery() {
        viewModel.searchQuery.removeAll()
    }
}

// MARK: - Preview

#Preview {
    let context = PreviewDataStack.shared.mockContext
    let newTeam = Team(context: context)
    newTeam.name = "Zalgiris Kaunas"
    newTeam.image = "https://picsum.photos/1000"
    newTeam.address = "Test address"
    newTeam.code = "ZAL"
    return TeamDetailsView(viewModel: DefaultTeamDetailsViewModel(team: newTeam))
}
