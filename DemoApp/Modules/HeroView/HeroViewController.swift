import UIKit
import Combine
import SVProgressHUD
import SnapKit

final class HeroViewController: UIViewController {
        
    // MARK: - Publishers

    private let onAppearPublisher = PassthroughSubject<Void, Never>()
    private let onSelectionPublisher = PassthroughSubject<Int, Never>()
    private let onSearchPublisher = PassthroughSubject<String, Never>()

    // MARK: - Properties

    private var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HeroViewModel
    var coordinator: MainCoordinator?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    
    init(viewModel: HeroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
        onAppearPublisher.send()
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
        tableView.delegate = self
        tableView.register(HeroItemCell.self,
                           forCellReuseIdentifier: HeroItemCell.cellID)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
                   make.edges.equalToSuperview()
               }
               tableView.backgroundColor = .systemBackground
           }
    
    private func bindViewModel() {
        cancellables.forEach { $0.cancel()}
        cancellables.removeAll()
        
        let input = HeroViewModelInput(
                    appear: onAppearPublisher.eraseToAnyPublisher(),
                    selection: onSelectionPublisher.eraseToAnyPublisher(),
                    search: onSearchPublisher.eraseToAnyPublisher()
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
                SVProgressHUD.show()
            case .success(let heroes):
                SVProgressHUD.dismiss()
                self.viewModel.items = heroes
                self.tableView.reloadData()
            case .failure(_):
                SVProgressHUD.dismiss()
            case .error(_):
                SVProgressHUD.dismiss()

            }
        }
    }
}

extension HeroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroItemCell.cellID, for: indexPath) as! HeroItemCell
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        cell.backgroundColor = UIColor { traitCollection in
                  return traitCollection.userInterfaceStyle == .dark ? .black : .white
              }
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
        onSearchPublisher.send(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onSearchPublisher.send("")
    }
}
