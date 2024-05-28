import Combine
import UIKit

typealias HeroViewModelOuput = AnyPublisher<HeroViewState, Never>

class HeroViewModel: HeroesViewModelType {
    @Published private(set) var state: HeroViewState = .idle
    @Published var items: [Character] = []
    
    private var offset = 0
    private let limit = 20

    private var cancellables = Set<AnyCancellable>()
    private let heroUseCase: HeroUseCase
    
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
                self.offset = 0  // Reset offset on appear
                return self.fetchData(query: nil, offset: self.offset, limit: self.limit)
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
                        self.offset = 0  // Reset offset on new search
                        return self.fetchData(query: query, offset: self.offset, limit: self.limit)
                    }
                    .eraseToAnyPublisher()
        
        // MARK: - Handle Load More
               let onLoadMoreAction = input.loadMore
                   .flatMap { [weak self] _ -> AnyPublisher<HeroViewState, Never> in
                       guard let self = self else { return Just(.error("Error")).eraseToAnyPublisher() }
                       return self.fetchData(query: nil, offset: self.offset, limit: self.limit)
                   }
                   .eraseToAnyPublisher()
        
        return Publishers.Merge3(onAppearAction, searchCharacter, onLoadMoreAction)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
            .eraseToAnyPublisher()
    }
    
    private func fetchData(query: String?, offset: Int, limit: Int) -> AnyPublisher<HeroViewState, Never> {
          heroUseCase.getHeroes(query: query, offset: offset, limit: limit)
              .map { [weak self] response in
                  if offset == 0 {
                      self?.items = response.data.results
                  } else {
                      self?.items.append(contentsOf: response.data.results)
                  }
                  let hasMoreItems = response.data.results.count >= limit
                  if hasMoreItems {
                      self?.offset += limit
                  }
                  return .success(self?.items ?? [])
              }
              .catch { error -> AnyPublisher<HeroViewState, Never> in
                  return Just(.error("Error: \(error)")).eraseToAnyPublisher()
              }
              .prepend(.idle)
              .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
              .eraseToAnyPublisher()
      }
  }
