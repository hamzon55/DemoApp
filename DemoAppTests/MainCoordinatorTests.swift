import XCTest
@testable import DemoApp

final class MainCoordinatorTests: XCTestCase {
    
    var navigationController: UINavigationController!
    var coordinator: MainCoordinator!
    let numberOfViewController = 1
    
    override func tearDown() {
        navigationController = nil
        coordinator = nil
        super.tearDown()
    }
    
    func testStart() {
        
        // GIVEN
        navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navigationController)
        
        // WHEN
        coordinator.start()
        
        // THEN
        XCTAssertEqual(navigationController.viewControllers.count, numberOfViewController)
        XCTAssertTrue(navigationController.viewControllers.first is HeroViewController, "The first view controller should be of type HeroViewController.")
        
    }
}
