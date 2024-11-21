import SwiftUI
import CoreData

struct GameListItem: View {
    
    // MARK: - Properties

    private enum Constants {
        static let vsLabel = "VS"
    }
    
    // MARK: - Properties

    var game: Game
        
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Text(game.gameDate)
                .font(.system(size: 12))
                .foregroundStyle(Color.gray)
            
            GeometryReader { geometry in
                HStack(alignment: .center) {
                    Text(game.team)
                        .font(.system(size: 16))
                        .frame(width: geometry.size.width * 0.45, height: 40)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Text(Constants.vsLabel)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.init(uiColor: .lightGray))
                    
                    Spacer()
                    
                    Text(game.opponent)
                        .font(.system(size: 16))
                        .frame(width: geometry.size.width * 0.45, height: 40)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.top, 5)
    }
}

// MARK: - Preview

#Preview {
    let context = PreviewDataStack.shared.mockContext
    let newGame = Game(context: context)
    newGame.date = "2024-06-29T00:00:00"
    newGame.team = "Team 1"
    newGame.opponent = "Team 2"
    
    return GameListItem(game: newGame)
}
