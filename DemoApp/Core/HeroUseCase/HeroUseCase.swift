//
//  File.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 10/5/24.
//

import Foundation
import Combine

// MARK: - UseCase


// Create the Protocole And Specify the task to solve
protocol HeroUseCase {
    func getHeroes() -> AnyPublisher<[SuperHero], Error>
}
