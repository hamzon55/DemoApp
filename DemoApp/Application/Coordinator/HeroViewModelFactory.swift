class HeroViewModelFactory {
    
    static func createViewModel() -> HeroViewModel {
        let apiClient = URLSessionAPIClient<HeroeEndpoint>()
        let heroUseCase = DefaultHeroUseCase(apiClient: apiClient)
        return HeroViewModel(heroUseCase: heroUseCase)
    }
}
