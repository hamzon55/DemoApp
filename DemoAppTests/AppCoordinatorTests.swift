//
//  AppCoordinatorTests.swift
//  DemoAppTests
//
//  Created by HamZa Jerbi on 10/5/24.
//

import XCTest
@testable import DemoApp

final class AppCoordinatorTests: XCTestCase {
    
    var window: UIWindow!
    var coordinator: AppCoordinator!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        coordinator = AppCoordinator(window: window)
    }
    
    override func tearDown() {
          window = nil
          coordinator = nil
          super.tearDown()
      }
 
    func testInitSetsWindowRootViewController() {
          XCTAssertTrue(window.rootViewController is UINavigationController)
      }
 
    func testStartSetsCharacterListViewController() {
        coordinator.start()
        
        XCTAssertTrue(coordinator.firstViewController != nil)
        XCTAssertTrue(coordinator.navigationController.topViewController is FirstViewController)
        XCTAssertTrue(coordinator.navigationController.viewControllers.count == 1)
    }
    
}
