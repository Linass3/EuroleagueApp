import UIKit

class PlayerDetailsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let navigationBarTitle = "Player"
        static let playerDetailsCellIdentifier = "playerDetailsCell"
        static let stockPlayerImage = "stockPlayerImage.jpg"
        static let gameString = "Game"
        static let segmentTitles = ["Games", "Players"]
    }
    
    // MARK: - UI Elements
    
    private lazy var playerImageView = makeImageView()
    private lazy var playerCardView = UIView()
    private lazy var gradientLayer = makeGradientLayer()
    private lazy var playerNameLabel = makeLabel()
    private lazy var horizontalStackView = makeStackView()
    private lazy var playerAgeLabel = makeLabel(font: .systemFont(ofSize: 18, weight: .medium), allignment: .center)
    private lazy var playerHeightLabel = makeLabel(font: .systemFont(ofSize: 18, weight: .medium), allignment: .center)
    private lazy var playerWeightLabel = makeLabel(font: .systemFont(ofSize: 18, weight: .medium), allignment: .center)
    private lazy var playerDetailsTableView = UITableView()
    
    // MARK: - Properties
    
    private var playerDetailsViewModel: PlayerDetailsViewModel
    
    init(playerDetailsViewModel: PlayerDetailsViewModel) {
        self.playerDetailsViewModel = playerDetailsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPlayerDetailsTableView()
        setupNavigationBar()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = playerCardView.bounds
    }
    
    // MARK: - Private
    
    private func setupNavigationBar() {
        self.navigationItem.title = Constants.navigationBarTitle
    }
    
    private func setupPlayerDetailsTableView() {
        playerDetailsTableView.dataSource = self
        playerDetailsTableView.register(PlayerDetailsCell.self, forCellReuseIdentifier: Constants.playerDetailsCellIdentifier)
    }
    
    private func setupConstraints() {
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        playerCardView.translatesAutoresizingMaskIntoConstraints = false
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        playerAgeLabel.translatesAutoresizingMaskIntoConstraints = false
        playerHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        playerWeightLabel.translatesAutoresizingMaskIntoConstraints = false
        playerDetailsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(playerImageView)
        view.addSubview(playerCardView)
        playerCardView.layer.addSublayer(gradientLayer)
        playerCardView.addSubview(playerNameLabel)
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(playerAgeLabel)
        horizontalStackView.addArrangedSubview(playerHeightLabel)
        horizontalStackView.addArrangedSubview(playerWeightLabel)
        view.addSubview(playerDetailsTableView)
        
        NSLayoutConstraint.activate([
            playerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerImageView.heightAnchor.constraint(equalToConstant: 350),
            
            playerCardView.bottomAnchor.constraint(equalTo: playerImageView.bottomAnchor),
            playerCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerCardView.heightAnchor.constraint(equalToConstant: 70),
            
            playerNameLabel.trailingAnchor.constraint(equalTo: playerCardView.trailingAnchor, constant: -10),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerCardView.bottomAnchor, constant: -10),
            playerNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            horizontalStackView.topAnchor.constraint(equalTo: playerImageView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 70),
            
            playerDetailsTableView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor),
            playerDetailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerDetailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerDetailsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        if playerDetailsViewModel.playerImage != nil {
            playerImageView.loadImage(from: playerDetailsViewModel.playerImage!)
        } else {
            playerImageView.image = UIImage(named: Constants.stockPlayerImage)
        }
        playerNameLabel.text = playerDetailsViewModel.playerName
        playerAgeLabel.text = "Age \n\(playerDetailsViewModel.playerAge)"
        playerHeightLabel.text = "Height \n\(playerDetailsViewModel.playerHeight) cm"
        playerWeightLabel.text = "Weight \n\(playerDetailsViewModel.playerWeight) kg"
        horizontalStackView.backgroundColor = .red
        playerDetailsTableView.allowsSelection = false
    }
    
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    private func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        return gradientLayer
    }

    private func makeLabel(font: UIFont = UIFont.systemFont(ofSize: 22, weight: .bold), allignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textAlignment = allignment
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }

    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }
}

// MARK: - Extensions

extension PlayerDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerDetailsViewModel.labelCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.playerDetailsCellIdentifier, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = playerDetailsViewModel.playerPositionLabel
            cell.detailTextLabel?.text = playerDetailsViewModel.playerPosition
        case 1:
            cell.textLabel?.text = playerDetailsViewModel.playerNumberLabel
            cell.detailTextLabel?.text = playerDetailsViewModel.playerNumber
        case 2:
            cell.textLabel?.text = playerDetailsViewModel.playerCountryLabel
            cell.detailTextLabel?.text = playerDetailsViewModel.playerCountry
        case 3:
            cell.textLabel?.text = playerDetailsViewModel.playerLastTeamLabel
            cell.detailTextLabel?.text = playerDetailsViewModel.playerLastTeam
        default:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
}
