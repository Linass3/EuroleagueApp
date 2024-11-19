import SwiftUI
import CoreData

struct TeamListItem: View {
    
    let team: Team
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: team.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                    } placeholder: {
                        Color.red
                            .frame(width: 35, height: 35)
                    }

                    Text(team.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }

                Text(team.address)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.secondary)
                    .lineLimit(3)

            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
}
