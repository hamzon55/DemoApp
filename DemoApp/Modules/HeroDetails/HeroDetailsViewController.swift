import UIKit
import Combine

class HeroDetailsViewController: UIViewController {
    
    private let viewModel: HeroDetailViewModel
    private let onAppearPublisher = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    
    private func setupUI() {
        view.addSubview(titleLabel)
        self.view.backgroundColor = .white
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppearPublisher.send(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupBindings() {
        let input = HeroDetailViewModelInput(appear:
                                                onAppearPublisher.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        output.sink(receiveValue: { [weak self] state in
            self?.updateUI(state)
        })
        .store(in: &cancellables)
    }
    
    
    private func updateUI(_ state: HeroDetailViewState) {
        // Update UI based on the view state
        switch state {
        case .idle:
            // Handle idle state
            break
        case .success(let heroDetail):
            titleLabel.text = heroDetail.name
        case .error(let message):
            // Handle error state
            // Show error message
            break
        }
    }
}
