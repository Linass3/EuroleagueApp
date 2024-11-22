import Foundation

protocol PlayerDetailsViewModel {
    var playerName: String { get }
    var playerImage: String? { get }
    var playerAge: Int { get }
    var playerHeight: Int16 { get }
    var playerWeight: Int16 { get }
    var playerPosition: String { get }
    var playerNumber: String { get }
    var playerCountry: String { get }
    var playerLastTeam: String { get }
}

struct DefaultPlayerDetailsViewModel: PlayerDetailsViewModel {
    
    // MARK: - Properties
    
    private let player: Player
    
    var playerName: String {
        player.name
    }
    var playerImage: String? {
        player.image
    }
    var playerAge: Int {
        player.age
    }
    var playerHeight: Int16 {
        player.height
    }
    var playerWeight: Int16 {
        player.weight
    }
    var playerPosition: String {
        player.position
    }
    var playerNumber: String {
        player.number
    }
    var playerCountry: String {
        player.country
    }
    var playerLastTeam: String {
        player.lastTeam
    }
    
    init(player: Player) {
        self.player = player
    }
}
