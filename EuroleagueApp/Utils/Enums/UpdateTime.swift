import Foundation

enum UpdateTime {
    case team
    case player(code: String)
    case game(code: String)
    
    var timeInterval: Double {
        switch self {
        case .team:
            return 10
        case .player:
            return 10
        case .game:
            return 10
        }
    }
    
    var cofigurationKey: String {
        switch self {
        case .team:
            return "teamUpdateTime"
        case .player(let code):
            return "\(code)playerUpdateTime"
        case .game(let code):
            return "\(code)gameUpdateTime"
        }
    }
}
