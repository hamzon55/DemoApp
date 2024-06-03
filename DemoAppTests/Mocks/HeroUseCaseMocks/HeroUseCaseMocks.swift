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

final class MockHeroViewModelMapper: HeroViewModelMapping {
    func map(_ input: MarvelResponse) -> HeroScreenViewModel {
        return HeroScreenViewModel(heroes: input.data.results.map {
            HeroItemCellViewModel(name: $0.name,
                                  description: $0.descriptionText,
                                  characterImageURL: URL(string: "\($0.thumbnail.path).\($0.thumbnail.thumbnailExtension)"))
        })
    }
}
