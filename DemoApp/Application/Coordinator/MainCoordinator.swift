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
    
    func navigateToHeroDetail(hero: HeroItemCellViewModel) {
        let heroViewModel = HeroDetailViewModel(heroItem: hero)
        let detailViewController =  HeroDetailsViewController(viewModel: heroViewModel)
        navigationController.pushViewController(detailViewController, animated: true)
      }
}
