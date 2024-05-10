//
//  HeroServiceProtocol.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 10/5/24.
//

import Foundation
import Combine
import Foundation

protocol HeroGateway {
    func getHeroes() -> AnyPublisher<[SuperHeroCharacter], Error>

}

class HeroService: HeroGateway {
    let apiClient = URLSessionAPIClient<HeroeEndpoint>()
    
    func getHeroes() -> AnyPublisher<[SuperHeroCharacter], Error> {
        return apiClient.request(.getHeroes)
    }
}
