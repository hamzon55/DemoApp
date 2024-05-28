import Combine

// MARK: - UseCase

/// Protocol specifying the task to retrieve heroes.
protocol HeroUseCase {
    func getHeroes(query: String?,offset: Int, limit: Int)  -> AnyPublisher<MarvelResponse, APIError>
}

final class DefaultHeroUseCase: HeroUseCase {
       
    private var apiClient: URLSessionAPIClient<HeroeEndpoint>

    /// - Parameter apiClient: The API client for making network requests.
    init(apiClient: URLSessionAPIClient<HeroeEndpoint>) {
          self.apiClient = apiClient
      }
    
    /// Retrieves heroes based on the provided query.

    /// - Returns: A publisher emitting `MarvelResponse` or a `HeroUseCaseError` if an error occurs.

    func getHeroes(query: String?, offset: Int, limit: Int) -> AnyPublisher<MarvelResponse, APIError> {
        apiClient.request(HeroeEndpoint.getHeroes(query: query, offset: offset, limit: limit))
            .mapError { _ in APIError.invalidResponse }
                       .eraseToAnyPublisher()
    }
}
