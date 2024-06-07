class HeroViewModelFactory {
    
    static func createViewModel(coordinator: MainCoordinator) -> HeroViewModel {
        let apiClient = URLSessionAPIClient<HeroeEndpoint>()
        let heroUseCase = DefaultHeroUseCase(apiClient: apiClient)
        let mapper = HeroViewModelMapper()
        return .init(heroUseCase: heroUseCase,
                     heroViewModelMapper: mapper,
                     coordinator: coordinator)
    }
}
