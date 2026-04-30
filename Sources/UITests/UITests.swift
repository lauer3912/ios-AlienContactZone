import XCTest

final class AlienContactZoneUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testHomeTab() {
        XCTAssertTrue(app.tabButtons["tab_home"].exists)
    }
}

extension XCUIApplication {
    var tabButtons: XCUIElementQuery {
        return buttons
    }
}