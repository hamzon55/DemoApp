//
//  HeroViewModelMapper.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 2/6/24.
//

import Foundation

protocol HeroViewModelMapping {
    func map(_ input: MarvelResponse) -> HeroScreenViewModel
}

final class HeroViewModelMapper: HeroViewModelMapping {
    func map(_ input: MarvelResponse) -> HeroScreenViewModel {
        .init(heroes: input.data.results.map { .init(name: $0.name,
                                                     description: $0.descriptionText,
                                                     characterImageURL: $0.thumbnail.url) })
    }
}
