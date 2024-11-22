import SwiftUI
import CoreData

struct PlayerListItem: View {
    
    // MARK: - Constants

    private enum Constants {
        static let stockPlayerImage = "stockPlayerImage"
        static let squareImageHeight: CGFloat = 30
    }
    
    // MARK: - Properties

    var player: Player
    
    // MARK: - Body

    var body: some View {
        HStack {
            if player.image != nil {
                AsyncImage(url: URL(string: player.image!)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.clear
                }
                .scaledToFit()
                .frame(width: Constants.squareImageHeight, height: Constants.squareImageHeight)
                .clipShape(Circle())
            } else {
                Image(Constants.stockPlayerImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.squareImageHeight, height: Constants.squareImageHeight)
                    .clipShape(Circle())
            }
            
            Text(player.name)
                .fontWeight(.medium)
            
            Spacer()
        }
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
    
    return PlayerListItem(player: newPlayer)
}
