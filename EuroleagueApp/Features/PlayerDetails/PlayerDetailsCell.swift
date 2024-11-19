import UIKit

class PlayerDetailsCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let playerDetailsCellIdentifier = "playerDetailsCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: Constants.playerDetailsCellIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
