//
//  SnapshotHeroViewControllerTests.swift
//  DemoAppTests
//
//  Created by HamZa Jerbi on 24/5/24.
//

import XCTest
import Combine
import SnapshotTesting
@testable import DemoApp

final class SnapshotHeroViewControllerTests: XCTestCase {
    
    private var viewModel: HeroViewModel!
    
    override class func setUp() {
    }
    
    func testHeroViewControllerAppearance() {
        givenSUT(mapperResponse: Constants.Responses.full)
        let viewController = HeroViewController(viewModel: viewModel)
        
        viewController.viewDidLoad()
        
        // Force the view to load
        viewController.loadViewIfNeeded()
        
        assertSnapshot(matching: viewController, as: .image)
    }
    
    func givenSUT(mapperResponse: [HeroItemCellViewModel]) {
        let mapperMock = HeroViewModelMappingMock(response: .init(heroes: mapperResponse))
        viewModel = HeroViewModel(heroUseCase: MockHeroUseCase(),
                                  heroViewModelMapper: mapperMock)
    }
    
    private enum Constants {
        enum Responses {
            static let full: [HeroItemCellViewModel] = [
                .init(name: "Name1",
                      description: "Description1",
                      characterImageURL: nil),
                .init(name: "Name2",
                      description: "Description2",
                      characterImageURL: nil),
            ]
        }
    }
}

