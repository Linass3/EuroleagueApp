import SwiftUI
import CoreData

struct TeamDetailsView: View {
    
    // MARK: - Constants

    private enum Constants {
        static let navigationBarTitle = "Team"
        static let pickerTitleLabel = "Data"
        static let pickerSelectionLabelOne = "Games"
        static let pickerSelectionLabelTwo = "Players"
        static let searchBarIcon = "magnifyingglass"
        static let searchBarPlaceholder = "Search by name, position or country"
        static let searchBarClearIcon = "xmark.circle.fill"
        static let emptyString = ""
    }
    
    // MARK: - Properties
    
    @StateObject private var viewModel: DefaultTeamDetailsViewModel
    @State private var selectedView = 0
    @State private var searchQuery = Constants.emptyString

    init(viewModel: @autoclosure @escaping () -> DefaultTeamDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: viewModel.team.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                        .clipped()
                } placeholder: {
                    Color.clear
                        .frame(height: 350)
                }
                
                ZStack(alignment: .trailing) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.clear]),
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
            
            Picker(Constants.pickerTitleLabel, selection: $selectedView) {
                Text(Constants.pickerSelectionLabelOne).tag(0)
                Text(Constants.pickerSelectionLabelTwo).tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.leading, 60)
            .padding(.trailing, 60)
            .padding(.top, 10)
            .padding(.bottom, 10)

            if viewModel.isUpdating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.black)
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                switch selectedView {
                case 0:
                    gamesListView
                case 1:
                    playersListView
                default:
                    gamesListView
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
                
                TextField(Constants.searchBarPlaceholder, text: $searchQuery)
                    .frame(maxWidth: .infinity)
                    .onChange(of: searchQuery) {
                        viewModel.filter(searchQuery)
                    }
                
                if !searchQuery.isEmpty {
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
            
            if searchQuery.isEmpty {
                List(viewModel.playersList, id: \.objectID) { player in
                    NavigationLink(destination: PlayerDetailsView(viewModel: DefaultPlayerDetailsViewModel(player: player))) {
                        PlayerListItem(player: player)
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(PlainListStyle())
            } else {
                List(viewModel.playerSearchResults, id: \.objectID) { player in
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
    }
    
    private func resetSearchQuery() {
        searchQuery.removeAll()
    }
}

// MARK: - Preview

#Preview {
    SwinjectUtility.container.register(NSManagedObjectContext.self) { _ in
        PreviewDataStack.shared.mockContext
    }
    let context = SwinjectUtility.forceResolve(NSManagedObjectContext.self)
    let newTeam = Team(context: context)
    newTeam.name = "Zalgiris Kaunas"
    newTeam.image = "https://picsum.photos/1000"
    newTeam.address = "Test address"
    newTeam.code = "ZAL"
    return TeamDetailsView(viewModel: DefaultTeamDetailsViewModel(team: newTeam))
}
