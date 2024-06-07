import Combine
import UIKit

typealias HeroViewModelOuput = AnyPublisher<HeroViewState, Never>

class HeroViewModel: HeroesViewModelType {
    @Published private(set) var state: HeroViewState = .idle
    @Published var items: HeroScreenViewModel = .init(heroes: [])
    private let coordinator: MainCoordinator
    
    private enum Constants {
        enum ErrorMessage {
            static let selfError = "Self should not be nil"
            static let searchError = "Search Error"
            static let onLoadMoreActionError = "No more Data"
            static let onSelectionError  =  "Index Error"
        }
        static let timeout = 300
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let heroUseCase: HeroUseCase
    private let heroViewModelMapper: HeroViewModelMapping
    
    required init(heroUseCase: HeroUseCase,
                  heroViewModelMapper: HeroViewModelMapping,
                  coordinator: MainCoordinator) {
        self.heroUseCase = heroUseCase
        self.heroViewModelMapper = heroViewModelMapper
        self.coordinator = coordinator
    }
    
    func transform(input: HeroViewModelInput) -> HeroViewModelOuput {
        cancellables.forEach { $0.cancel()}
        cancellables.removeAll()
        
        // MARK: - on View Appear
        let onAppearAction = input.appear
            .flatMap { [weak self] _ -> AnyPublisher<HeroViewState, Never> in
                guard let self else { return Just(.error(Constants.ErrorMessage.selfError)).eraseToAnyPublisher() }
                return self.fetchData(query: nil, offset: self.items.heroes.count)
            }
            .eraseToAnyPublisher()
        
        // MARK: - Handle Searching
        let onSearchAction = input.search
            .debounce(for: .milliseconds(Constants.timeout), scheduler: RunLoop.main)
            .removeDuplicates()
        
        let searchCharacter = onSearchAction
            .filter({ !$0.isEmpty })
            .flatMap { [weak self] query -> AnyPublisher<HeroViewState, Never> in
                guard let self = self else { return Just(.error(Constants.ErrorMessage.searchError)).eraseToAnyPublisher() }
                return self.fetchData(query: query, offset: self.items.heroes.count)
            }
            .eraseToAnyPublisher()
        
        
        let onSelectionAction = input.selection
            .map { [weak self] index -> HeroViewState in
                guard let self = self else {
                    return .error(Constants.ErrorMessage.onSelectionError)
                }
                self.coordinator.navigateToHeroDetail(hero: self.items.heroes[index])
                return .success(self.items)
            }
            .eraseToAnyPublisher()
        
        // MARK: - Handle Load More
        let onLoadMoreAction = input.loadMore
            .flatMap { [weak self] _ -> AnyPublisher<HeroViewState, Never> in
                guard let self = self else { return Just(.error(Constants.ErrorMessage.onLoadMoreActionError)).eraseToAnyPublisher() }
                return self.fetchData(query: nil, offset: self.items.heroes.count)
            }
            .eraseToAnyPublisher()
        
        return Publishers.Merge4(onAppearAction, searchCharacter, onLoadMoreAction, onSelectionAction)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
            .eraseToAnyPublisher()
    }
    
    private func fetchData(query: String?, offset: Int) -> AnyPublisher<HeroViewState, Never> {
        heroUseCase.getHeroes(query: query, offset: offset)
            .map { [weak self] response in
                guard let self else { return .error(Constants.ErrorMessage.selfError) }
                let newItems = heroViewModelMapper.map(response)
                if response.data.offset == 0 {
                    self.items = newItems
                } else {
                    let items = self.items.heroes + newItems.heroes
                    self.items = .init(heroes: items)
                }
                return .success(self.items)
            }
            .catch { error -> AnyPublisher<HeroViewState, Never> in
                return Just(.error("Error: \(error)")).eraseToAnyPublisher()
            }
            .prepend(.idle)
            .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
            .eraseToAnyPublisher()
    }
}
