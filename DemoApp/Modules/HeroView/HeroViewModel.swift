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
    
    // Input
    var fetchItemsPublisher = PassthroughSubject<Void, Never>()
    
    // Output
    @Published var state: HeroViewState = .idle
    @Published var items: [Character] = []
    let heroService: HeroUseCase

    private var cancellables = Set<AnyCancellable>()
    
    init(heroService: HeroUseCase) {
           self.heroService = heroService
    }
    
     func getCharacters() {
        state = .loading
            heroService.getHeroes()
                   .receive(on: RunLoop.main)
                   .sink(receiveCompletion: { data in
                   
               }, receiveValue: {[weak self] data in
                   self?.items = data.data.results
                   self?.state = .success(data.data.results)
               }).store(in: &cancellables)
    }
}
