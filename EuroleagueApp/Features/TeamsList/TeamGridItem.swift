import SwiftUI
import CoreData

struct TeamGridItem: View {
    
    // MARK: - Properties
    
    let team: Team

    // MARK: - Body
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: team.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Color.clear
            }
        }
        .padding(10)
        .frame(width: 170, height: 150)
        .background(Color.white)
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
        )
    }
}

// MARK: - Preview

#Preview {
    SwinjectUtility.container.register(NSManagedObjectContext.self) { _ in
        PreviewDataStack.shared.mockContext
    }
    let context = SwinjectUtility.forceResolve(NSManagedObjectContext.self)
    let newTeam = Team(context: context)
    newTeam.name = "Test team"
    newTeam.image = "https://picsum.photos/1000"
    newTeam.address = "Test address"
    newTeam.code = "TEST"
    return TeamGridItem(team: newTeam)
}
