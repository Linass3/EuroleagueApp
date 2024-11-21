import SwiftUI
import CoreData

struct PlayerListItem: View {
    
    // MARK: - Constants

    private enum Constants {
        static let stockPlayerImage = "stockPlayerImage"
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
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                } placeholder: {
                    Color.clear
                        .frame(width: 30, height: 30)
                }
            } else {
                Image(Constants.stockPlayerImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
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
    
    return PlayerListItem(player: newPlayer)
}
