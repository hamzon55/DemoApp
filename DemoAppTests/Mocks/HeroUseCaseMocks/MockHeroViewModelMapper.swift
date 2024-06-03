import XCTest
@testable import DemoApp

final class MockHeroViewModelMapper: HeroViewModelMapping {
    func map(_ input: MarvelResponse) -> HeroScreenViewModel {
        return HeroScreenViewModel(heroes: input.data.results.map {
            HeroItemCellViewModel(name: $0.name,
                                  description: $0.descriptionText,
                                  characterImageURL: URL(string: "\($0.thumbnail.path).\($0.thumbnail.thumbnailExtension)"))
        })
    }
}

