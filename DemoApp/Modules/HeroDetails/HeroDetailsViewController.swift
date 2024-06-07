import UIKit
import Combine
import SVProgressHUD

class HeroDetailsViewController: UIViewController {
    
    private let viewModel: HeroDetailViewModel
    private let onAppearPublisher = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    private var customView: HeroHeaderView!

    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    
    private func setupUI() {
        self.view.backgroundColor = .white
        customView = HeroHeaderView()
        
        view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
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
            SVProgressHUD.dismiss()
        case .success(let heroDetail):
            customView.apply(viewModel: heroDetail)
        case .error(let message):
            SVProgressHUD.dismiss()

        }
    }
}
