import XCTest
import SnapshotTesting
@testable import DemoApp 

class HeroItemCellTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testHeroItemCellLayout() {
        // Create an instance of HeroItemCell
        let cell = HeroItemCell(style: .default, reuseIdentifier: "HeroItemCell")
        cell.frame = CGRect(x: 0, y: 0, width: 320, height: 176) // Set a frame for the cell

        // Configure the cell with test data
        cell.configure(with: .init(name: "Iron Man", 
                                   description: "Genius, billionaire, playboy, philanthropist.",
                                   characterImageURL: nil))

        // Manually trigger layout
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        // Verify that the rendered cell matches the reference snapshot
        assertSnapshot(matching: cell, as: .image)
    }
}
