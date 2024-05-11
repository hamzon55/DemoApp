
import UIKit
import Combine

class HeroViewController: UIViewController {
    private var tableView: UITableView!

    private var viewModel = HeroViewModel()
    var coordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.fetchItemsPublisher.send()
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
        viewModel.$state
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: HeroViewState) {
        switch state {
        case .idle:
            // Handle idle state
            break
        case .loading:
            // Handle loading state
            break
        case .loaded(_):
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
    
    // You can implement other UITableViewDelegate methods here as needed
}
