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
                return self.fetchaData()
            }
            .eraseToAnyPublisher()
        
        return onAppearAction
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
            .eraseToAnyPublisher()
    }
    
    private func fetchaData() -> AnyPublisher<HeroViewState, Never> {
        heroUseCase.getHeroes()
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
