import Foundation
import Combine

// MARK: - UseCase

// Create the Protocole And Specify the task to solve
protocol HeroUseCase {
    func getHeroes()  -> AnyPublisher<MarvelResponse, Error>
}

final class DefaultHeroUseCase: HeroUseCase {
    
    private var apiClient =  URLSessionAPIClient<HeroeEndpoint>()
    
    init(apiClient:  URLSessionAPIClient<HeroeEndpoint>) {
        self.apiClient = apiClient
    }
    
    func getHeroes()-> AnyPublisher<MarvelResponse, Error> {
        
        return apiClient.request(.getHeroes)
        
    }
}
