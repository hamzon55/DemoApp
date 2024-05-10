//
//  File.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 10/5/24.
//

import Foundation
import Combine

// MARK: - UseCase

protocol HeroUseCase {
    func getHeroes() -> AnyPublisher<[SuperHeroCharacter], Error>
}

final class DefaultCharacterUseCase {
    private let gateway: HeroGateway

    init(gateway: HeroGateway) {
        self.gateway = gateway
    }
}

