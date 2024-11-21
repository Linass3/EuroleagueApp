import SwiftUI
import CoreData

struct TeamListItem: View {
    
    // MARK: - Properties
    
    let team: Team
    
    // MARK: - Body
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: team.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        Color.clear
                            .frame(width: 30, height: 30)
                    }

                    Text(team.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
                Text(team.address)
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(.black)
                    .lineLimit(3)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
            )
            .padding(.vertical, 10)
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
    newTeam.image = "https://picsum.photos/200"
    newTeam.address = "Test address"
    newTeam.code = "TEST"
    return TeamListItem(team: newTeam)
}
