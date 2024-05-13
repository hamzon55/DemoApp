//
//  AppCoordinatorTests.swift
//  DemoAppTests
//
//  Created by HamZa Jerbi on 10/5/24.
//

import XCTest
@testable import DemoApp

final class MainCoordinatorTests: XCTestCase {
    
  
    var navigationController: UINavigationController!
    var coordinator: MainCoordinator!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navigationController)
    }
    
    override func tearDown() {
            navigationController = nil
           coordinator = nil
           super.tearDown()
      }
 
    func testStart() {
        coordinator.start()
        XCTAssertTrue(navigationController.viewControllers.first is HeroViewController)

      }
 
    func testStartSetsCharacterListViewController() {
        coordinator.start()
        
        XCTAssertTrue(coordinator.navigationController.topViewController is HeroViewController)
        XCTAssertTrue(navigationController.viewControllers.last is HeroViewController)
    }
    
}
