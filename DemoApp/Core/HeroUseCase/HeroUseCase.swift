import Foundation
import Combine

// MARK: - UseCase

// Create the Protocole And Specify the task to solve
protocol HeroUseCase {
    func getHeroes(query: String?)  -> AnyPublisher<MarvelResponse, Error>
}

final class DefaultHeroUseCase: HeroUseCase {
    
    private var apiClient =  URLSessionAPIClient<HeroeEndpoint>()
    
    init(apiClient:  URLSessionAPIClient<HeroeEndpoint>) {
        self.apiClient = apiClient
    }
    
    func getHeroes(query: String?)  -> AnyPublisher<MarvelResponse, Error>{

        return apiClient.request(HeroeEndpoint.getHeroes(query: query)).mapError { error -> Error in
            return APIError.invalidResponse
        }
        .eraseToAnyPublisher()
    }   
}
