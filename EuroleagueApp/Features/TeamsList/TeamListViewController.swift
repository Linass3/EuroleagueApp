import UIKit

class TeamListViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let gridString: String = "Grid"
        static let listString: String = "List"
        static let teamListViewAccessibilityIdentifier: String = "teamListView"
        static let teamCellListIdentifier: String = "teamCellList"
        static let teamCellGridIdentifier: String = "teamCellGrid"
        static let navigationBarTitle: String = "Euroleague"
        static let stockPlayerImage: String = "stockPlayerImage.jpg"
    }
    
    // MARK: - UI Elements
    
    private lazy var tableView = UITableView()
    private lazy var collectionView = UICollectionView()
    private lazy var loadingView = ScreenLoadingIndicatorView(style: .large)
    
    // MARK: - Properties
    
    private var viewModel: TeamListViewModel
    
    init(viewModel: TeamListViewModel) {
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
        setupTableView()
        setupCollectionView()
        setupNavigationBar()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task { @MainActor in
            await loadData()
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        view.accessibilityIdentifier = Constants.teamListViewAccessibilityIdentifier
    }
    
    private func setupConstrains() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.isHidden = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TeamCellList.self, forCellReuseIdentifier: Constants.teamCellListIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: view.frame.width / 2 - 5, height: 180)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TeamCellGrid.self, forCellWithReuseIdentifier: Constants.teamCellGridIdentifier)
    }
    
    @objc private func action(_ sender: UIBarButtonItem) {
        switch sender.title {
        case Constants.gridString:
            collectionView.isHidden = false
            tableView.isHidden = true
            sender.title = Constants.listString
        case Constants.listString:
            collectionView.isHidden = true
            tableView.isHidden = false
            sender.title = Constants.gridString
        default:
            break
        }
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = Constants.navigationBarTitle
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.gridString,
            style: .plain,
            target: self,
            action: #selector(self.action(_:))
        )
    }
    
    private func loadData() async {
        Task { @MainActor in
            if viewModel.teamsNeedUpdate() {
                loadingView.startAnimating()
            }
        }
        
        await viewModel.checkTeamsData()
        loadingView.stopAnimating()
    }
}

// MARK: - Extensions

extension TeamListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.teamsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamCellListIdentifier, for: indexPath) as? TeamCellList else {
            fatalError("Could not dequeue cell")
        }
        cell.configure(with: viewModel.teamsList[indexPath.row])
        return cell
    }
}

extension TeamListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTeam = viewModel.teamsList[indexPath.row]
        let destinationViewModel = DefaultTeamDetailsViewModel(team: selectedTeam)
        let destinationViewController = TeamDetailsViewController(viewModel: destinationViewModel)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

extension TeamListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.teamsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.teamCellGridIdentifier, for: indexPath) as? TeamCellGrid else {
            fatalError("Could not dequeue cell")
        }
        cell.configure(with: viewModel.teamsList[indexPath.row])
        return cell
    }
}

extension TeamListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTeam = viewModel.teamsList[indexPath.item]
        let destinationViewModel = DefaultTeamDetailsViewModel(team: selectedTeam)
        let destinationViewController = TeamDetailsViewController(viewModel: destinationViewModel)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
