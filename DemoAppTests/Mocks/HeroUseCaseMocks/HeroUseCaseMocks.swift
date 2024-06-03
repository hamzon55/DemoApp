import XCTest
import UIKit
import Combine
@testable import DemoApp

final class MockHeroUseCase: HeroUseCase {
  
    var getHeroesCalled = false
    var getHeroesQuery: String?
    var getHeroesOffset: Int?
    var getHeroesResult: AnyPublisher<MarvelResponse, APIError>!
    
    func getHeroes(query: String?, offset: Int) -> AnyPublisher<MarvelResponse, APIError> {
    
        getHeroesCalled = true
        getHeroesQuery = query
        getHeroesOffset = offset
        return getHeroesResult
    }
}

