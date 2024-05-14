
import UIKit
import Combine

class HeroViewController: UIViewController {
  
    private var tableView: UITableView!
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()

    private var viewModel = HeroViewModel(heroService: DefaultHeroUseCase(apiClient: URLSessionAPIClient<HeroeEndpoint>()))
    
    var coordinator: MainCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send()
    }
    
    private func setupTableView() {
        // Initialize UITableView
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        
        // Register custom cell class
        tableView.register(HeroItemCell.self, forCellReuseIdentifier: "HeroItemCell")
        
        // Add UITableView as subview
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
        
      //  let input = HeroViewModelInput(appear: appear.eraseToAnyPublisher(),
      //                                 selection: selection.eraseToAnyPublisher())
        viewModel.$state
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables) 
        
            viewModel.getCharacters()
    }
    
    private func handleState(_ state: HeroViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            break
        case .success(_):
            tableView.reloadData()
            
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
        // Handle selection
        print("Selected item: \(selectedItem)")
    }
}
