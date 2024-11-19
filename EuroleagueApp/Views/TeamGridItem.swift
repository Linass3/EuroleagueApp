import SwiftUI

struct TeamGridItem: View {
    let team: Team

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: team.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Color.clear
            }
//            .frame(width: 90, height: 90)
            Text(team.name)
                .fontWeight(.bold)
                .font(.footnote)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding(10)
        .frame(width: 170, height: 150)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
