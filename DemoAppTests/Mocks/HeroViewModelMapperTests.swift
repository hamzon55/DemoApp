import XCTest
@testable import DemoApp 
class HeroViewModelMapperTests: XCTestCase {

func testMap() {
    // Given
    let mapper: HeroViewModelMapping = HeroViewModelMapper()
    // Create mock MarvelResponse
    
    let mockThumbnail = Thumbnail(path: "path/to/image", thumbnailExtension: "jpg")
    let mockCharacter = Character(id: 1,
                                  name: "Spider-Man",
                                  description: "Your friendly neighborhood Spider-Man",
                                  thumbnail: mockThumbnail)
    let mockHeroClass = HeroClass(offset: 0,
                                  limit: 20,
                                  total: 100,
                                  count: 1,
                                  results: [mockCharacter])
    let mockResponse = MarvelResponse(data: mockHeroClass)
    
    // When
    let viewModel = mapper.map(mockResponse)
    
    // Then
    XCTAssertEqual(viewModel.heroes.count, 1)
    
    let firstHeroViewModel = viewModel.heroes.first
    XCTAssertEqual(firstHeroViewModel?.name, "Spider-Man")
    XCTAssertEqual(firstHeroViewModel?.description, "Your friendly neighborhood Spider-Man")
    XCTAssertEqual(firstHeroViewModel?.characterImageURL, URL(string: "path/to/image.jpg"))
    
    // Verify HeroItemCellViewModel properties
    let expectedHeroItemCellViewModel = HeroItemCellViewModel(name: "Spider-Man", description: "Your friendly neighborhood Spider-Man", characterImageURL: URL(string: "path/to/image.jpg"))
    XCTAssertEqual(firstHeroViewModel, expectedHeroItemCellViewModel)
}
}
