import UIKit

class TeamPlayerCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let stockPlayerImage: String = "stockPlayerImage.jpg"
    }
    
    // MARK: - UI Elements

    private lazy var nameLabel = makeUILabel()
    private lazy var playerIconView = makeUIImage()
    
    // MARK: - Private
    
    private func setupConstrains() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerIconView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(playerIconView)
        
        NSLayoutConstraint.activate([
            playerIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            playerIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playerIconView.heightAnchor.constraint(equalToConstant: 30),
            playerIconView.widthAnchor.constraint(equalTo: playerIconView.heightAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: playerIconView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalTo: playerIconView.heightAnchor)
        ])
    }
    
    private func makeUILabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }
    
    private func makeUIImage() -> UIImageView {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 15
        iconView.layer.masksToBounds = true
        return iconView
    }
    
    // MARK: - Methods
    
    func configure(with player: Player) {
        nameLabel.text = player.name
        self.accessoryType = .disclosureIndicator
        if player.image != nil {
            playerIconView.loadImage(from: player.image!)
        } else {
            playerIconView.image = UIImage(named: Constants.stockPlayerImage)
        }
        setupConstrains()
    }
}
