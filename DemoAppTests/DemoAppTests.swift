//
//  DemoAppTests.swift
//  DemoAppTests
//
//  Created by HamZa Jerbi on 5/5/24.
//

import XCTest
@testable import DemoApp

final class DemoAppTests: XCTestCase {


    func testInitializationWithValidData() {
            // Given
            let hero = Character(id: 1, name: "Iron Man", description: "Genius, billionaire, playboy, philanthropist.", thumbnail: Thumbnail(path: "https://example.com/ironman.jpg", thumbnailExtension: "jpg"))
            let heroClass = HeroClass(offset: 0, limit: 1, total: 1, count: 1, results: [hero])

            // When
            let marvelResponse = MarvelResponse(data: heroClass)

            // Then
            XCTAssertEqual(marvelResponse.data.results.count, 1)
            XCTAssertEqual(marvelResponse.data.results.first?.name, "Iron Man")
        }
    }
