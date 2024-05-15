
import UIKit
import Combine
import SVProgressHUD

class HeroViewController: UIViewController {
    
    private var tableView: UITableView!
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private var viewModel = HeroViewModel(heroService: DefaultHeroUseCase(apiClient: URLSessionAPIClient<HeroeEndpoint>()))
    var coordinator: MainCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
        appear.send()
    }
    
    private func configureUI() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        searchController.isActive = true
        
    }
    
    private func setupTableView() {
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(HeroItemCell.self,
                           forCellReuseIdentifier: HeroItemCell.cellID)
        view.addSubview(tableView)
        
        // Define auto layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        
        let input = HeroViewModelInput(
            appear: appear.eraseToAnyPublisher(),
            selection: Publishers.Sequence<[Int], Never>(sequence: []).eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)
        output.sink(receiveValue: { [weak self] state in
            self?.updateUI(state)
        })
        .store(in: &cancellables)
        
    }
    
    private func updateUI(_ state: HeroViewState) {
        DispatchQueue.main.async {
            switch state {
            case .idle:
                print("Idle")
                SVProgressHUD.show()
            case .loading:
                break
            case .success(let heroes):
                SVProgressHUD.dismiss()
                self.viewModel.items = heroes
                self.tableView.reloadData()
            case .failure(_):
                break
            }
        }
    }
}

extension HeroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroItemCell", for: indexPath) as! HeroItemCell
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension HeroViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = viewModel.items[indexPath.row]
        print("Selected item: \(selectedItem)")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
// MARK: - Search Delegate

extension HeroViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.send("")
    }
}
