import XCTest
import SnapshotTesting
@testable import DemoApp // Replace with your app module name

class HeroItemCellTests: XCTestCase {

    override func setUp() {
        super.setUp()
         SnapshotTesting.isRecording = true
    }

    func testHeroItemCellLayout() {
        // Create an instance of HeroItemCell
        let cell = HeroItemCell(style: .default, reuseIdentifier: "HeroItemCell")
        cell.frame = CGRect(x: 0, y: 0, width: 320, height: 100) // Set a frame for the cell

        // Configure the cell with test data
        cell.nameLabel.text = "Iron Man"
        cell.descriptionLabel.text = "Genius, billionaire, playboy, philanthropist."

        // Manually trigger layout
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        // Verify that the rendered cell matches the reference snapshot
        assertSnapshot(matching: cell, as: .image)
    }
}
