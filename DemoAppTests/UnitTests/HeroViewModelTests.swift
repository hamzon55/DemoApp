import XCTest
import Combine
@testable import DemoApp

final class HeroViewModelTests: XCTestCase {
    
    var viewModel: HeroViewModel!
    var mockHeroUseCase: MockHeroUseCase!
    var mockHeroViewModelMapper: MockHeroViewModelMapper!
    var cancellables: Set<AnyCancellable>!
    
    
    override func setUp() {
        super.setUp()
        mockHeroUseCase = MockHeroUseCase()
        mockHeroViewModelMapper = MockHeroViewModelMapper()
        viewModel = HeroViewModel(heroUseCase: mockHeroUseCase,
                                  heroViewModelMapper: mockHeroViewModelMapper)
        cancellables = []
    }
    
    override func tearDown() {
           cancellables.forEach { $0.cancel() }
           cancellables.removeAll()
           super.tearDown()
       }
    
    func testFetchHeroesOnAppear() {
           let expectation = XCTestExpectation(description: "Fetch heroes on appear")
           
           let response = MarvelResponse(data: HeroClass(offset: 0, limit: 20, total: 100, count: 20, results: [
            Character(id: 0, name: "Hero 1", description: "Description 1", thumbnail: Thumbnail(path: "path1", thumbnailExtension: "jpg")),
            Character(id: 1, name: "Hero 2", description: "Description 2", thumbnail: Thumbnail(path: "path2", thumbnailExtension: "jpg"))
           ]))
           mockHeroUseCase.getHeroesResult = Just(response)
               .setFailureType(to: APIError.self)
               .eraseToAnyPublisher()
           
           let input = HeroViewModelInput(
            appear: Just(()).eraseToAnyPublisher(),
            selection:  PassthroughSubject<Int, Never>().eraseToAnyPublisher(),
            search: PassthroughSubject<String, Never>().eraseToAnyPublisher(),
            loadMore: PassthroughSubject<Void, Never>().eraseToAnyPublisher()
           )
           
           let expectedItems = HeroScreenViewModel(heroes: [
               HeroItemCellViewModel(name: "Hero 1", description: "Description 1", characterImageURL: URL(string: "path1.jpg")),
               HeroItemCellViewModel(name: "Hero 2", description: "Description 2", characterImageURL: URL(string: "path2.jpg"))
           ])
           
           viewModel.transform(input: input)
               .sink(receiveCompletion: { _ in }, receiveValue: { state in
                   if case .success(let items) = state {
                       XCTAssertEqual(items, expectedItems)
                       expectation.fulfill()
                   }
               })
               .store(in: &cancellables)
           
           wait(for: [expectation], timeout: 1.0)
       }
    
    func testLoadMoreHeroes() {
         let expectation = XCTestExpectation(description: "Load more heroes")
         
         let initialResponse = MarvelResponse(data: HeroClass(offset: 0, limit: 20, total: 100, count: 20, results: [
            Character(id: 0, name: "Hero 1", description: "Description 1", thumbnail: Thumbnail(path: "path1", thumbnailExtension: "jpg")),
            Character(id: 0, name: "Hero 2", description: "Description 2", thumbnail: Thumbnail(path: "path2", thumbnailExtension: "jpg")),
         ]))
         let loadMoreResponse = MarvelResponse(data: HeroClass(offset: 20, limit: 20, total: 100, count: 20, results: [
            Character(id: 0, name: "Hero 3", description: "Description 3", thumbnail: Thumbnail(path: "path3", thumbnailExtension: "jpg")),
            Character(id: 0, name: "Hero 4", description: "Description 4", thumbnail: Thumbnail(path: "path4", thumbnailExtension: "jpg")),
         ]))
         
         mockHeroUseCase.getHeroesResult = Just(initialResponse)
             .setFailureType(to: APIError.self)
             .eraseToAnyPublisher()
         
         let loadMoreSubject = PassthroughSubject<Void, Never>()
         
         let input = HeroViewModelInput(
            appear: Just(()).eraseToAnyPublisher(),
            selection: PassthroughSubject<Int, Never>().eraseToAnyPublisher(),
             search: PassthroughSubject<String, Never>().eraseToAnyPublisher(),
             loadMore: loadMoreSubject.eraseToAnyPublisher()
         )
         
         viewModel.transform(input: input)
             .sink(receiveCompletion: { _ in }, receiveValue: { state in
                 if case .success(let items) = state, items.heroes.count == 4 {
                     XCTAssertEqual(items.heroes[0].name, "Hero 1")
                     XCTAssertEqual(items.heroes[1].name, "Hero 2")
                     XCTAssertEqual(items.heroes[2].name, "Hero 3")
                     XCTAssertEqual(items.heroes[3].name, "Hero 4")
                     expectation.fulfill()
                 }
             })
             .store(in: &cancellables)
         
         // Send the initial appear event
         viewModel.transform(input: input)
             .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
             .store(in: &cancellables)
         
         // Update the result to the load more response
         mockHeroUseCase.getHeroesResult = Just(loadMoreResponse)
             .setFailureType(to: APIError.self)
             .eraseToAnyPublisher()
         
         // Send the load more event
         loadMoreSubject.send(())
         
         wait(for: [expectation], timeout: 2.0)
     }
 }
