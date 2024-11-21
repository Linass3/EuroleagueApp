import SwiftUI
import CoreData

struct PlayerDetailsView: View {
    
    // MARK: - Constants

    private enum Constants {
        static let navigationBarTitle = "Player"
        static let stockPlayerImage = "stockPlayerImage"
        static let ageLabel = "Age\n"
        static let heightLabel = "Height\n"
        static let weightLabel = "Weight\n"
        static let cmLabel = " cm"
        static let kgLabel = " kg"
    }
    
    // MARK: - Properties

    private var viewModel: PlayerDetailsViewModel

    init(viewModel: PlayerDetailsViewModel) {
        self.viewModel = viewModel
    }
        
    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                if viewModel.playerImage != nil {
                    AsyncImage(url: URL(string: viewModel.playerImage!)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .clipped()
                    } placeholder: {
                        Color.clear
                            .frame(height: 350)
                            .clipped()
                    }
                } else {
                    Image(Constants.stockPlayerImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                }
                
                ZStack(alignment: .bottomTrailing) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 70)
                    
                    Text(viewModel.playerName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
            }
            
            HStack {
                Spacer()
                
                Text(Constants.ageLabel + String(viewModel.playerAge))
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                
                Text(Constants.heightLabel + String(viewModel.playerHeight) + Constants.cmLabel)
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                
                Text(Constants.weightLabel + String(viewModel.playerWeight) + Constants.kgLabel)
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .frame(height: 70)
            .background(Color.init(uiColor: .red))
            
            List {
                Text(viewModel.playerPositionLabel)
                    .badge(Text(viewModel.playerPosition))

                Text(viewModel.playerNumberLabel)
                    .badge(Text(viewModel.playerNumber))
                
                Text(viewModel.playerCountryLabel)
                    .badge(Text(viewModel.playerCountry))
                
                Text(viewModel.playerLastTeamLabel)
                    .badge(Text(viewModel.playerLastTeam))
            }
            .listStyle(PlainListStyle())
            
            Spacer()
        }
        .navigationTitle(Constants.navigationBarTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    SwinjectUtility.container.register(NSManagedObjectContext.self) { _ in
        PreviewDataStack.shared.mockContext
    }
    let context = SwinjectUtility.forceResolve(NSManagedObjectContext.self)
    let newPlayer = Player(context: context)
    newPlayer.name = "Test name"
    newPlayer.image = "https://picsum.photos/1000"
    newPlayer.birthDate = "2005-12-03T00:00:00"
    newPlayer.country = "Test country"
    newPlayer.position = "Test position"
    newPlayer.height = 199
    newPlayer.weight = 100
    newPlayer.number = "1"
    newPlayer.lastTeam = "Test team"
    
    return PlayerDetailsView(viewModel: DefaultPlayerDetailsViewModel(player: newPlayer))
}
