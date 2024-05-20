//
//  FirstViewModel.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 8/5/24.
//

import Combine
import Foundation
import UIKit

typealias HeroViewModelOuput = AnyPublisher<HeroViewState, Never>

class HeroViewModel: HeroesViewModelType {
    @Published private(set) var state: HeroViewState = .idle
    @Published var items: [Character] = []
    private var cancellables = Set<AnyCancellable>()
    let heroUseCase: HeroUseCase

    init(heroUseCase: HeroUseCase) {
        self.heroUseCase = heroUseCase
    }
    
    func transform(input: HeroViewModelInput) -> HeroViewModelOuput {
        cancellables.forEach { $0.cancel()}
        cancellables.removeAll()
        
        let onAppearAction = input.appear
            .flatMap { [weak self] _ -> AnyPublisher<HeroViewState, Never> in
                guard let self = self else { return Just(.error("Error ")).eraseToAnyPublisher() }
                return self.fetchData(query: "")
            }
            .eraseToAnyPublisher()
        
        let onSearchAction = input.search
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main) // Debounce to reduce rapid consecutive searches
                .removeDuplicates()   
                .flatMap { [weak self] query -> AnyPublisher<HeroViewState, Never> in
                    guard let self = self else { return Just(.error("Error")).eraseToAnyPublisher() }
                    return self.fetchData(query: query)
                }
        
        return Publishers.Merge(onAppearAction, onSearchAction)
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
