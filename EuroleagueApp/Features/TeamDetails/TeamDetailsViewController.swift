import UIKit

class TeamDetailsViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Constants
    
    private enum Constants {
        static let teamListViewAccessibilityIdentifier = "teamListView"
        static let teamDetailsViewAccessibilityIdentifier = "teamDetailsView"
        static let teamGamesViewAccessibilityIdentifier = "teamGamesView"
        static let teamPlayersViewAccessibilityIdentifier = "teamPlayersView"
        static let teamGameCellIdentifier = "teamGameCell"
        static let teamPlayerCellIdentifier = "teamPlayerCell"
        static let teamString = "Team"
        static let gameString = "Game"
        static let segmentTitles = ["Games", "Players"]
    }
    
    // MARK: - UI Elements

    private lazy var teamImageView = makeImageView()
    private lazy var teamCardView = UIView()
    private lazy var teamNameLabel = makeLabel()
    private lazy var gradientLayer = makeGradientLayer()
    private lazy var segmentedControl = makeSegmentedControl()
    private lazy var teamGamesView = UIView()
    private lazy var teamPlayersView = UIView()
    private lazy var teamPlayersTableView = UITableView()
    private lazy var teamGamesTableView = UITableView()
    private lazy var refreshControl = UIRefreshControl()
    private lazy var loadingView = ScreenLoadingIndicatorView(style: .large)
    
    // MARK: - Properties

    private var viewModel: TeamDetailsViewModel

    init(viewModel: TeamDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupTeamGamesTableView()
        setupTeamPlayersTableView()
        setupNavigationBar()
        setupConstraints()
        setupRefreshControl()
        
        Task { @MainActor in
            await loadData()
            teamGamesTableView.reloadData()
            teamPlayersTableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = teamCardView.bounds
    }
    
    // MARK: - Private
    
    private func setupNavigationBar() {
        self.navigationItem.title = Constants.teamString
    }
    
    private func setupUI() {
        view.accessibilityIdentifier = Constants.teamDetailsViewAccessibilityIdentifier
        teamGamesView.accessibilityIdentifier = Constants.teamGamesViewAccessibilityIdentifier
        teamPlayersView.accessibilityIdentifier = Constants.teamPlayersViewAccessibilityIdentifier
        self.view.backgroundColor = .white
        teamImageView.loadImage(from: viewModel.team.image)
        teamNameLabel.text = viewModel.team.name
        teamPlayersView.isHidden = true
        teamPlayersTableView.rowHeight = 50
        teamGamesTableView.rowHeight = 70
        teamGamesTableView.allowsSelection = false
    }
    
    private func setupTeamGamesTableView() {
        teamGamesTableView.dataSource = self
        teamGamesTableView.register(TeamGameCell.self, forCellReuseIdentifier: Constants.teamGameCellIdentifier)
    }
    
    private func setupTeamPlayersTableView() {
        teamPlayersTableView.dataSource = self
        teamPlayersTableView.delegate = self
        teamPlayersTableView.register(TeamPlayerCell.self, forCellReuseIdentifier: Constants.teamPlayerCellIdentifier)
    }
    
    private func setupConstraints() {
        teamCardView.translatesAutoresizingMaskIntoConstraints = false
        teamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        teamImageView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        teamGamesView.translatesAutoresizingMaskIntoConstraints = false
        teamPlayersView.translatesAutoresizingMaskIntoConstraints = false
        teamPlayersTableView.translatesAutoresizingMaskIntoConstraints = false
        teamGamesTableView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(teamImageView)
        view.addSubview(teamCardView)
        view.addSubview(segmentedControl)
        view.addSubview(teamGamesView)
        view.addSubview(teamPlayersView)
        view.addSubview(loadingView)
        teamCardView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = teamCardView.bounds
        teamCardView.addSubview(teamNameLabel)
        teamPlayersView.addSubview(teamPlayersTableView)
        teamGamesView.addSubview(teamGamesTableView)
        
        NSLayoutConstraint.activate([
            teamImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            teamImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teamImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teamImageView.heightAnchor.constraint(equalToConstant: 350),
            
            teamCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teamCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teamCardView.bottomAnchor.constraint(equalTo: teamImageView.bottomAnchor),
            teamCardView.heightAnchor.constraint(equalToConstant: 70),
            
            teamNameLabel.bottomAnchor.constraint(equalTo: teamCardView.bottomAnchor, constant: -10),
            teamNameLabel.trailingAnchor.constraint(equalTo: teamCardView.trailingAnchor, constant: -10),
            teamNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            segmentedControl.topAnchor.constraint(equalTo: teamCardView.bottomAnchor, constant: 25),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            teamGamesView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 25),
            teamGamesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teamGamesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teamGamesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            teamGamesTableView.topAnchor.constraint(equalTo: teamGamesView.topAnchor),
            teamGamesTableView.leadingAnchor.constraint(equalTo: teamGamesView.leadingAnchor),
            teamGamesTableView.trailingAnchor.constraint(equalTo: teamGamesView.trailingAnchor),
            teamGamesView.bottomAnchor.constraint(equalTo: teamGamesTableView.bottomAnchor),
            
            teamPlayersView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 25),
            teamPlayersView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teamPlayersView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teamPlayersView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            teamPlayersTableView.topAnchor.constraint(equalTo: teamPlayersView.topAnchor),
            teamPlayersTableView.leadingAnchor.constraint(equalTo: teamPlayersView.leadingAnchor),
            teamPlayersTableView.trailingAnchor.constraint(equalTo: teamPlayersView.trailingAnchor),
            teamPlayersTableView.bottomAnchor.constraint(equalTo: teamPlayersView.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func loadData() async {
        if viewModel.gamesNeedUpdate() || viewModel.playersNeedUpdate() {
            loadingView.startAnimating()
        }
        
        await viewModel.checkGamesData(forceUpdate: false)
        await viewModel.checkPlayersData()
        
        loadingView.stopAnimating()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        teamGamesTableView.addSubview(refreshControl)
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
        
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        return label
    }

    private func makeSegmentedControl() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: Constants.segmentTitles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged),
            for: .valueChanged
        )
        return segmentedControl
    }
    
    @objc private func segmentedControlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            teamGamesView.isHidden = false
            teamPlayersView.isHidden = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            teamGamesView.isHidden = true
            teamPlayersView.isHidden = false
        }
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        Task { @MainActor in
            await viewModel.checkGamesData(forceUpdate: true)
            teamGamesTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - Extensions

extension TeamDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == teamGamesTableView {
            return viewModel.gamesList.count
        } else if tableView == teamPlayersTableView {
            return viewModel.playersList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == teamGamesTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamGameCellIdentifier, for: indexPath) as? TeamGameCell else {
                fatalError("Could not dequeue teamGameCell")
            }
            cell.configure(with: viewModel.gamesList[indexPath.row])
            return cell
        } else if tableView == teamPlayersTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamPlayerCellIdentifier, for: indexPath) as? TeamPlayerCell else {
                fatalError("Could not dequeue teamPlayerCell")
            }
            cell.configure(with: viewModel.playersList[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == teamPlayersTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            let player = viewModel.playersList[indexPath.row]
            let destinationViewModel = DefaultPlayerDetailsViewModel(player: player)
            let destinationViewController = PlayerDetailsViewController(playerDetailsViewModel: destinationViewModel)
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}
