import Combine
import UIKit

typealias HeroViewModelOuput = AnyPublisher<HeroViewState, Never>

class HeroViewModel: HeroesViewModelType {
    @Published private(set) var state: HeroViewState = .idle
    private var cancellables = Set<AnyCancellable>()
    let heroUseCase: HeroUseCase
    
    @Published var items: [Character] = []
    
    init(heroUseCase: HeroUseCase) {
        self.heroUseCase = heroUseCase
    }
    
    func transform(input: HeroViewModelInput) -> HeroViewModelOuput {
        cancellables.forEach { $0.cancel()}
        cancellables.removeAll()
        
        // MARK: - on View Appear
        let onAppearAction = input.appear
            .flatMap { [weak self] _ -> AnyPublisher<HeroViewState, Never> in
                guard let self = self else { return Just(.error("Error ")).eraseToAnyPublisher() }
                return self.fetchData(query: nil)
            }
            .eraseToAnyPublisher()
        
        // MARK: - Handle Searching
        let onSearchAction = input.search
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
        
        let searchCharacter = onSearchAction
            .filter({ !$0.isEmpty })
            .flatMap { [weak self] query -> AnyPublisher<HeroViewState, Never> in
                guard let self = self else { return Just(.error("Error")).eraseToAnyPublisher() }
                return self.fetchData(query: query)
            }
        
        return Publishers.Merge(onAppearAction, searchCharacter)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
            .eraseToAnyPublisher()
    }
    
    private func fetchData(query: String?) -> AnyPublisher<HeroViewState, Never> {
        heroUseCase.getHeroes(query: query)
            .map { response in
                self.items = response.data.results
                return .success(response.data.results)
            }
            .catch { error -> Just<HeroViewState> in
                Just(.failure(error))
            }
            .prepend(.loading)
            .eraseToAnyPublisher()
    }
}
