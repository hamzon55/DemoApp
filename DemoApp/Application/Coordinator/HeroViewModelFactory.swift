class HeroViewModelFactory {
    
    static func createViewModel() -> HeroViewModel {
        let apiClient = URLSessionAPIClient<HeroeEndpoint>()
        let heroUseCase = DefaultHeroUseCase(apiClient: apiClient)
        let mapper = HeroViewModelMapper()
        return .init(heroUseCase: heroUseCase,
                     heroViewModelMapper: mapper)
    }
}
