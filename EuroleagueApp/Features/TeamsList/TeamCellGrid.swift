import Foundation
import UIKit

class TeamCellGrid: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private lazy var cardView = UIView()
    private lazy var imageView = UIImageView()
    
    // MARK: - Private
    
    private func setupConstraints () {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        cardView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupUI(with teamDetails: Team) {
        backgroundColor = .clear
        imageView.loadImage(from: teamDetails.image)
        imageView.contentMode = .scaleAspectFit
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 10
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // MARK: - Methods
    
    func configure(with teamDetails: Team) {
        setupUI(with: teamDetails)
        setupConstraints()
    }
}
