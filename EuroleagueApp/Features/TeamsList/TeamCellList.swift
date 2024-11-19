import UIKit

class TeamCellList: UITableViewCell {
    
    // MARK: - UI Elements
    
    private lazy var horizontalStackView = makeStackView()
    private lazy var iconView = makeIconView()
    private lazy var teamNameLabel = makeLabel()
    private lazy var teamDescriptionLabel = makeLabel(font: UIFont.systemFont(ofSize: 16, weight: .light))
    private lazy var cardView = UIView()
    
    // MARK: - Private
    
    private func setupUI(with teamDetails: Team) {
        backgroundColor = .clear
        iconView.loadImage(from: teamDetails.image)
        teamNameLabel.text = teamDetails.name
        teamDescriptionLabel.text = teamDetails.address
        teamDescriptionLabel.numberOfLines = 3
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 10
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupConstrains() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        teamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        teamDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cardView)
        cardView.addSubview(horizontalStackView)
        cardView.addSubview(teamDescriptionLabel)
        horizontalStackView.addArrangedSubview(iconView)
        horizontalStackView.addArrangedSubview(teamNameLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            horizontalStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            horizontalStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            
            iconView.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            iconView.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            iconView.bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            
            teamNameLabel.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            teamNameLabel.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor),
            teamNameLabel.bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor),
            
            teamDescriptionLabel.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10),
            teamDescriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            teamDescriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            teamDescriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])
    }
    
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }
    
    private func makeIconView() -> UIImageView {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        iconView.layer.masksToBounds = true
        return iconView
    }
    
    private func makeLabel(font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)) -> UILabel {
        let label = UILabel()
        label.font = font
        label.numberOfLines = 0
        return label
    }
    
    // MARK: - Methods
    
    func configure(with teamDetails: Team) {
        setupUI(with: teamDetails)
        setupConstrains()
    }
}
