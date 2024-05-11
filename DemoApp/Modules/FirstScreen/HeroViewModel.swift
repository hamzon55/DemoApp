//
//  FirstViewModel.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 8/5/24.
//

import Combine
import Foundation
import UIKit

class HeroViewModel {
    
    // Input
    var fetchItemsPublisher = PassthroughSubject<Void, Never>()
    
    // Output
    @Published var state: HeroViewState = .idle
    @Published var items: [SuperHero] = []

    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        fetchItemsPublisher
            .map { self.fetchItems() }
            .sink { items in
                self.fetchItems()
            }
            .store(in: &cancellables)
    }
    
    private func fetchItems() {
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.items = [
                SuperHero(name: "Item 1"),
                SuperHero(name: "Item 2"),
                SuperHero(name: "Item 3")
            ]
            self.state = .loaded(self.items)
        }
    }
}
