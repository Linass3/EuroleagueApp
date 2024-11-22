import SwiftUI
import CoreData

struct PlayerDetailsView: View {
    
    // MARK: - Constants

    private enum Constants {
        static let navigationBarTitle = "Player"
        static let stockPlayerImage = "stockPlayerImage"
        static let ageLabel = "Age"
        static let heightLabel = "Height"
        static let weightLabel = "Weight"
        static let heightUnitLabel = "cm"
        static let weightUnitLabel = "kg"
        static let imageHeight: CGFloat = 350
        static let mainAttributesLabelFontSize: CGFloat = 18
        static let playerPositionLabel = "Position"
        static let playerNumberLabel = "Jersey Number"
        static let playerCountryLabel = "Country"
        static let playerLastTeamLabel = "Last Team"
    }
    
    // MARK: - Properties

    private var viewModel: PlayerDetailsViewModel

    init(viewModel: PlayerDetailsViewModel) {
        self.viewModel = viewModel
    }
        
    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            playerCardView
            
            mainAttributesView
            
            additionalAttributesView
            
            Spacer()
        }
        .navigationTitle(Constants.navigationBarTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Views
    
    private var playerCardView: some View {
        ZStack(alignment: .bottom) {
            if viewModel.playerImage != nil {
                AsyncImage(url: URL(string: viewModel.playerImage!)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.clear
                }
                .scaledToFit()
                .frame(height: Constants.imageHeight)
                .clipped()
            } else {
                Image(Constants.stockPlayerImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: Constants.imageHeight)
            }
            
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
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
    }
    
    private var mainAttributesView: some View {
        HStack {
            Spacer()
            
            Text(Constants.ageLabel + "\n" + String(viewModel.playerAge))
                .font(.system(size: Constants.mainAttributesLabelFontSize, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
            
            Text(Constants.heightLabel + "\n" + String(viewModel.playerHeight) + " " + Constants.heightUnitLabel)
                .font(.system(size: Constants.mainAttributesLabelFontSize, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
            
            Text(Constants.weightLabel + "\n" + String(viewModel.playerWeight) + " " + Constants.weightUnitLabel)
                .font(.system(size: Constants.mainAttributesLabelFontSize, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .frame(height: 70)
        .background(Color.init(uiColor: .red))
    }
        
    private var additionalAttributesView: some View {
        List {
            Text(Constants.playerPositionLabel)
                .badge(Text(viewModel.playerPosition))

            Text(Constants.playerNumberLabel)
                .badge(Text(viewModel.playerNumber))
            
            Text(Constants.playerCountryLabel)
                .badge(Text(viewModel.playerCountry))
            
            Text(Constants.playerLastTeamLabel)
                .badge(Text(viewModel.playerLastTeam))
        }
        .listStyle(PlainListStyle())
    }
}

// MARK: - Preview

#Preview {
    let context = PreviewDataStack.shared.mockContext
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
