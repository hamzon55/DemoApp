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

struct HeroViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let selection: AnyPublisher<Int, Never>
}

protocol HeroesViewModelType {
    func transform(input: HeroViewModelInput) -> HeroViewModelOuput
}

class HeroViewModel {
    
    var fetchItemsPublisher = PassthroughSubject<Void, Never>()
    
    // Output
    @Published var state: HeroViewState = .idle
    @Published var items: [Character] = []
    let heroService: HeroUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(heroService: HeroUseCase) {
        self.heroService = heroService
    }
    
    func transform(input: HeroViewModelInput) -> HeroViewModelOuput {
            let fetchItemsTrigger = input.appear
                .merge(with: input.selection.map { _ in () })
                .eraseToAnyPublisher()
            
            let statePublisher = fetchItemsTrigger
                .flatMap { [weak self] _ -> AnyPublisher<HeroViewState, Never> in
                    guard let self = self else {
                        return Empty<HeroViewState, Never>().eraseToAnyPublisher()
                    }
                    
                    return self.heroService.getHeroes()
                        .map { characters in
                            self.items = characters.data.results
                            return .success(characters.data.results)
                        }
                        .catch { error -> Just<HeroViewState> in
                            return Just(.failure(error))
                        }
                        .prepend(.loading)
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
            
            return statePublisher
        }
}
