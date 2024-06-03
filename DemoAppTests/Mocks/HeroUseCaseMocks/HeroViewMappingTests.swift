import XCTest
@testable import DemoApp

class HeroViewModelMappingMock: HeroViewModelMapping {
  
    private let response: HeroScreenViewModel
    
    init(response: HeroScreenViewModel) {
        self.response = response
    }
    
    func map(_ input: MarvelResponse) -> DemoApp.HeroScreenViewModel {
        response
    }
}
