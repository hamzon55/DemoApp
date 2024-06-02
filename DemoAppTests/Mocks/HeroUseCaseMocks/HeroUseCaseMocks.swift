//
//  HeroUseCaseMocks.swift
//  DemoAppTests
//
//  Created by HamZa Jerbi on 24/5/24.
//

import XCTest
import UIKit
import Combine
@testable import DemoApp

final class MockHeroUseCase: HeroUseCase {
  
    
    var getHeroesCalled = false
    var getHeroesQuery: String?
    var getHeroesResult: AnyPublisher<MarvelResponse, APIError>!
    
    func getHeroes(query: String?, offset: Int) -> AnyPublisher<DemoApp.MarvelResponse, DemoApp.APIError> {
    
        getHeroesCalled = true
        getHeroesQuery = query
        return getHeroesResult
    }
}
