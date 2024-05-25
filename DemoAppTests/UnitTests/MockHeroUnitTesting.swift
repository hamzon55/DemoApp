import XCTest
import Combine
@testable import DemoApp

final class MockHeroUseCaseTests: XCTestCase {
    
    func testGetHeroes() {
        
        let test1 = [ Character(id: 1, name: "Hero Name2 ", description: "Genius billionaire playboy philanthropist", thumbnail: Thumbnail(path: "iron_man", thumbnailExtension: "jpg")),
                      Character(id: 1, name: "Hero Name2 ", description: "Genius billionaire playboy philanthropist", thumbnail: Thumbnail(path: "iron_man", thumbnailExtension: "jpg"))
        ]
    
        let mockResponse = MarvelResponse(data: .init(offset: 0, limit: 0, total: 0, count: 0, results: test1))
        
        
        let mockUseCase = MockHeroUseCase()
        mockUseCase.getHeroesResult = Just(mockResponse)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
        let publisher = mockUseCase.getHeroes(query: nil)
        
        XCTAssertTrue(mockUseCase.getHeroesCalled)
        XCTAssertNil(mockUseCase.getHeroesQuery)
        XCTAssertNotNil(publisher)
        XCTAssertNotNil(mockResponse)
        
    }
}
