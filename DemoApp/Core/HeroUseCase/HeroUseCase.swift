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
    func getHeroes()  -> AnyPublisher<[SuperHero], Error>
}


final class DefaultHeroUseCase: HeroUseCase {
    
    private var apiClient =  URLSessionAPIClient<HeroeEndpoint>()

    init(apiClient:  URLSessionAPIClient<HeroeEndpoint>) {
        self.apiClient = apiClient
    }
    
    func getHeroes()-> AnyPublisher<[SuperHero], Error> {
        
        return apiClient.request(.getHeroes)
        
    }

}
