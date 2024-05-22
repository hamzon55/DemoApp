import UIKit

class MainCoordinator: Coordinator {
    
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = HeroViewController(viewModel: HeroViewModelFactory.createViewModel())
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}
