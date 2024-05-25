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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHeroViewControllerAppearance() {
            let viewModel = HeroViewModel(heroUseCase: MockHeroUseCase())
            let viewController = HeroViewController(viewModel: viewModel)
        
            viewController.viewDidLoad()

            // Force the view to load
            viewController.loadViewIfNeeded()

            assertSnapshot(matching: viewController, as: .image)
        }
}
