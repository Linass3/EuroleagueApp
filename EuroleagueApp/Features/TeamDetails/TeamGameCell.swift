import UIKit

class TeamGameCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let vsString: String = "VS"
    }
    
    // MARK: - UI Elements

    private lazy var mainTeamLabel = makeLabel()
    private lazy var opponentTeamLabel = makeLabel()
    private lazy var vsLabel = makeLabel(font: .systemFont(ofSize: 12), color: .lightGray)
    private lazy var dateLabel = makeLabel(font: .systemFont(ofSize: 12), color: .gray, allignment: .left)
    private lazy var horizontalStackView = makeStackView()
    
    // MARK: - Private

    private func setupUI(with game: Game) {
        mainTeamLabel.text = game.team
        opponentTeamLabel.text = game.opponent
        vsLabel.text = Constants.vsString
        dateLabel.text = game.gameDate
    }
    
    private func setupConstrains() {
        mainTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        opponentTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        vsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(mainTeamLabel)
        horizontalStackView.addArrangedSubview(vsLabel)
        horizontalStackView.addArrangedSubview(opponentTeamLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            dateLabel.heightAnchor.constraint(equalToConstant: 15),
            
            horizontalStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 40),

            mainTeamLabel.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.45),
            opponentTeamLabel.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.45),
            vsLabel.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.1)
        ])
    }
    
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }
    
    private func makeLabel(font: UIFont = UIFont.systemFont(ofSize: 16), color: UIColor = .black, allignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textAlignment = allignment
        label.textColor = color
        label.numberOfLines = 2
        return label
    }
    
    // MARK: - Methods
    
    func configure(with game: Game) {
        setupUI(with: game)
        setupConstrains()
    }
}
