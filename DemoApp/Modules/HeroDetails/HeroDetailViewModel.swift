import Combine
import UIKit

typealias HeroDetailViewModelOuput = AnyPublisher<HeroDetailViewState, Never>

class HeroDetailViewModel: HeroeDetailViewModelType {
    
    @Published private(set) var state: HeroViewState = .idle
    private var cancellables = Set<AnyCancellable>()
    private let heroItem: HeroItemCellViewModel    
    private enum Constants {
        enum ErrorMessage {
            static let selfError = "Self should not be nil"
        }
    }
    init(heroItem: HeroItemCellViewModel) {
        self.heroItem = heroItem
    }
    
    func transform(input: HeroDetailViewModelInput) -> HeroDetailViewModelOuput {
        
        let heroDetailModel = input.appear
            .map { [weak self] () -> HeroDetailViewState in
                guard let self = self else { return .error(Constants.ErrorMessage.selfError) }
                let viewModel = HeroItemCellViewModel.init(name: self.heroItem.name, description: self.heroItem.description, characterImageURL: self.heroItem.characterImageURL)
                return .success(viewModel)
            }
            .eraseToAnyPublisher()
        
        return heroDetailModel

    }
    
    
}
