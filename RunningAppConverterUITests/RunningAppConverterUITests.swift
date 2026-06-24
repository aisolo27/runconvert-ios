import XCTest

final class RunningAppConverterUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testTabsRenderPrimaryScreens() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Pace Converter"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Distance"].tap()
        XCTAssertTrue(app.staticTexts["Distance Converter"].waitForExistence(timeout: 2))

        app.tabBars.buttons["Time"].tap()
        XCTAssertTrue(app.staticTexts["Time Estimator"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Target Pace"].exists)

        app.tabBars.buttons["Workout"].tap()
        XCTAssertTrue(app.staticTexts["Workout Converter"].waitForExistence(timeout: 2))
    }

    @MainActor
    func testDistanceKeyboardShowsDoneButton() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Distance"].tap()
        XCTAssertTrue(app.staticTexts["Distance Converter"].waitForExistence(timeout: 2))

        let distanceField = app.textFields.firstMatch
        XCTAssertTrue(distanceField.waitForExistence(timeout: 2))
        distanceField.tap()

        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 3))
    }
}
