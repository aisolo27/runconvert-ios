import XCTest
import UIKit

final class RunningAppConverterUITests: XCTestCase {
    @MainActor
    func testStoreScreenshotsShowRealConversions() throws {
        let app = XCUIApplication()
        app.launch()
        func capture(_ name: String) {
            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = name
            attachment.lifetime = .keepAlways
            add(attachment)
        }
        func enter(_ field: XCUIElement, _ value: String) {
            field.tap()
            field.typeText(value)
            app.buttons["Done"].tap()
        }
        XCTAssertTrue(app.staticTexts["Pace Converter"].waitForExistence(timeout: 5))
        enter(app.textFields.firstMatch, "500")
        app.buttons["Convert"].tap()
        XCTAssertTrue(app.staticTexts["8:03"].waitForExistence(timeout: 3))
        capture("01-pace")
        app.tabBars.buttons["Distance"].tap()
        enter(app.textFields.firstMatch, "10")
        app.buttons["Convert"].tap()
        XCTAssertTrue(app.staticTexts["6.21"].waitForExistence(timeout: 3))
        capture("02-distance")
        app.tabBars.buttons["Time"].tap()
        enter(app.textFields.element(boundBy: 0), "10")
        enter(app.textFields.element(boundBy: 1), "500")
        app.buttons["Estimate"].tap()
        XCTAssertTrue(app.staticTexts["50:00"].waitForExistence(timeout: 3))
        capture("03-time")
        app.tabBars.buttons["Workout"].tap()
        app.buttons["Convert"].tap()
        capture("04-workout")
    }

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

    @MainActor
    func testPrivacyPolicyAvailableWithoutLeavingApp() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Privacy Policy"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "RunConvert works offline")).firstMatch.waitForExistence(timeout: 3))
        app.buttons["Done"].tap()
        XCTAssertTrue(app.staticTexts["Pace Converter"].waitForExistence(timeout: 3))
    }

    @MainActor
    func testDistanceResultClearsWhenInputChanges() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Distance"].tap()
        let field = app.textFields.firstMatch
        field.tap()
        field.typeText("10")
        app.buttons["Done"].tap()
        app.buttons["Convert"].tap()
        XCTAssertTrue(app.staticTexts["6.21"].waitForExistence(timeout: 3))
        field.tap()
        field.typeText("0")
        XCTAssertFalse(app.staticTexts["6.21"].exists)
    }

    @MainActor
    func testLargestTextPaceRangeCanConvertAndClear() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Pace Converter"].waitForExistence(timeout: 5))
        app.buttons["Pace Range"].tap()
        enterVisible(app.textFields["Faster (min/km)"], text: "600", in: app)
        enterVisible(app.textFields["Slower (min/km)"], text: "630", in: app)

        let convert = app.buttons["Convert"]
        reveal(convert, in: app)
        XCTAssertGreaterThanOrEqual(convert.frame.height, 44)
        convert.tap()
        XCTAssertTrue(app.staticTexts["9:39-10:28"].waitForExistence(timeout: 3))

        let clear = app.buttons["Clear"]
        reveal(clear, in: app)
        XCTAssertGreaterThanOrEqual(clear.frame.height, 44)
        XCTAssertGreaterThanOrEqual(clear.frame.minY, convert.frame.maxY)
        capture(app, name: "accessibility-pace-range-actions")
        clear.tap()
        XCTAssertFalse(app.staticTexts["9:39-10:28"].exists)
        XCTAssertEqual(app.textFields["Faster (min/km)"].value as? String, "m:ss")
    }

    @MainActor
    func testLargestTextTimeAndWorkoutRemainUsable() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        app.tabBars.buttons["Time"].tap()
        enterVisible(app.textFields.matching(identifier: "Distance (km)").firstMatch, text: "10", in: app)
        enterVisible(app.textFields["Pace (min/km)"], text: "500", in: app)
        reveal(app.buttons["Estimate"], in: app)
        app.buttons["Estimate"].tap()
        XCTAssertTrue(app.staticTexts["50:00"].waitForExistence(timeout: 3))
        capture(app, name: "accessibility-time")

        app.tabBars.buttons["Workout"].tap()
        reveal(app.buttons["Convert"], in: app)
        app.buttons["Convert"].tap()
        let total = app.staticTexts["4.97 mi total"]
        XCTAssertTrue(total.waitForExistence(timeout: 3))
        reveal(total, in: app)
        capture(app, name: "accessibility-workout")
    }

    @MainActor
    func testBrandHeaderDoesNotResetInputAfterBackgroundReturn() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["runconvert.brand"].waitForExistence(timeout: 5))
        XCTAssertGreaterThanOrEqual(app.buttons["Change unit, currently /km"].frame.height, 44)
        enterVisible(app.textFields.firstMatch, text: "500", in: app)
        app.buttons["Convert"].tap()
        XCTAssertTrue(app.staticTexts["8:03"].waitForExistence(timeout: 3))
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(app.staticTexts["8:03"].waitForExistence(timeout: 3))
        app.tabBars.buttons["Distance"].tap()
        app.tabBars.buttons["Pace"].tap()
        XCTAssertTrue(app.staticTexts["8:03"].exists)
        capture(app, name: "brand-return-pace")
    }

    @MainActor
    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        let scroll = app.scrollViews.firstMatch
        for _ in 0..<12 {
            if element.isHittable { return }
            // Small, bidirectional drags avoid jumping past a large-text field.
            let isAbove = element.frame.midY < scroll.frame.midY
            let start = scroll.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: isAbove ? 0.35 : 0.7))
            let end = scroll.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: isAbove ? 0.7 : 0.35))
            start.press(forDuration: 0.05, thenDragTo: end)
        }
        XCTAssertTrue(element.isHittable, "Could not reach \(element)")
    }

    @MainActor
    private func enterVisible(_ field: XCUIElement, text: String, in app: XCUIApplication) {
        reveal(field, in: app)
        field.tap()
        field.typeText(text)
        app.buttons["Done"].tap()
        let keyboardDismissed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: app.keyboards.firstMatch)
        XCTAssertEqual(XCTWaiter.wait(for: [keyboardDismissed], timeout: 3), .completed)
    }

    @MainActor
    private func capture(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

}

final class RunConvertUXAuditTests: XCTestCase {
    @MainActor
    func testUpdatedStoreGraphicsUseVerifiedConversions() {
        let app = launch(tab: "Pace")
        let pace = app.otherElements["pace.card"]
        enter(pace.textFields["Input (min/km)"], "500", app)
        tap(pace.buttons["Convert"], app)
        expectOutput(pace, "8:03")
        mark("store-01-pace", app)

        app.tabBars.buttons["Distance"].tap()
        let distance = app.otherElements["distance.card"]
        enter(distance.textFields["Input (km)"], "10", app)
        tap(distance.buttons["Convert"], app)
        expectOutput(distance, "6.21")
        mark("store-02-distance", app)

        app.tabBars.buttons["Time"].tap()
        let target = app.otherElements["time.target"]
        tap(target.buttons["Half Marathon"], app)
        enterDuration(target, label: "Target Time", hours: "1", minutes: "35", seconds: "0", app)
        tap(target.buttons["Find Pace"], app)
        expectOutput(target, "4:30")
        mark("store-03-time", app)

        app.tabBars.buttons["Workout"].tap()
        let workout = app.otherElements["workout.card"]
        tap(workout.buttons["Convert"], app)
        XCTAssertEqual(app.staticTexts["workout.total"].label, "4.97 mi total")
        mark("store-04-workout", app)

        choose(workout, "Workout mode", "Intervals", app)
        choose(workout, "workout.output.unit", "Miles", app)
        tap(workout.buttons["Convert"], app)
        XCTAssertEqual(app.staticTexts["workout.total"].label, "1.87 mi total")
        reveal(app.staticTexts["workout.total"], app)
        app.scrollViews.firstMatch.swipeUp()
        mark("store-05-intervals", app)
    }

    override func setUpWithError() throws { continueAfterFailure = false }

    @MainActor
    func testHalfMarathonHoursAndMinutesAreExplicit() {
        let app = launch(tab: "Time")
        let target = app.otherElements["time.target"]
        for unit in ["km", "mi"] {
            clear(target, app)
            choose(target, "Target distance mode", "Distance", app)
            choose(target, "Target time mode", "Time", app)
            setUnit(target, unit, pace: false, app)
            tap(target.buttons["Half Marathon"], app)
            enterDuration(target, label: "Target Time", hours: "1", minutes: "35", seconds: "0", app)
            tap(target.buttons["Find Pace"], app)
            expectOutput(target, unit == "km" ? "4:30" : "7:15")
            mark("half-marathon-95-min-\(unit)", app)
            clear(target, app)
            tap(target.buttons["Marathon"], app)
            enterDuration(target, label: "Target Time", hours: "4", minutes: "30", seconds: "0", app)
            tap(target.buttons["Find Pace"], app)
            expectOutput(target, unit == "km" ? "6:24" : "10:18")
            mark("marathon-270-min-\(unit)", app)
        }
    }

    @MainActor
    func testPaceAndDistanceModesInBothUnits() {
        let app = launch(tab: "Pace")
        let pace = app.otherElements["pace.card"]
        for unit in ["km", "mi"] {
            for range in [false, true] {
                clear(pace, app)
                choose(pace, "Pace mode", range ? "Pace Range" : "Pace", app)
                setUnit(pace, unit, pace: true, app)
                if range {
                    enter(pace.textFields["Faster (min/\(unit))"], "600", app)
                    enter(pace.textFields["Slower (min/\(unit))"], "630", app)
                } else {
                    enter(pace.textFields["Input (min/\(unit))"], "500", app)
                }
                tap(pace.buttons["Convert"], app)
                expectOutput(pace, range ? (unit == "km" ? "9:39-10:28" : "3:44-4:02") : (unit == "km" ? "8:03" : "3:06"))
                mark("pace-\(range ? "range" : "single")-\(unit)", app)
            }
        }
        app.tabBars.buttons["Distance"].tap()
        let distance = app.otherElements["distance.card"]
        for unit in ["km", "mi"] {
            for range in [false, true] {
                clear(distance, app)
                choose(distance, "Distance mode", range ? "Range" : "Distance", app)
                setUnit(distance, unit, pace: false, app)
                if range {
                    enter(distance.textFields["From (\(unit))"], "10", app)
                    enter(distance.textFields["To (\(unit))"], "12", app)
                } else {
                    enter(distance.textFields["Input (\(unit))"], "10.5", app)
                }
                tap(distance.buttons["Convert"], app)
                expectOutput(distance, range ? (unit == "km" ? "6.21-7.46" : "16.09-19.31") : (unit == "km" ? "6.52" : "16.90"))
                mark("distance-\(range ? "range" : "single")-\(unit)", app)
            }
        }
    }

    @MainActor
    func testTimeEstimatorAllRangeCombinationsAndUnits() {
        let app = launch(tab: "Time")
        let scope = app.otherElements["time.estimate"]
        for unit in ["km", "mi"] {
            for distanceRange in [false, true] {
                for paceRange in [false, true] {
                    clear(scope, app)
                    choose(scope, "Distance estimate mode", distanceRange ? "Range" : "Distance", app)
                    choose(scope, "Pace estimate mode", paceRange ? "Pace Range" : "Pace", app)
                    setUnit(scope, unit, pace: false, app)
                    if distanceRange {
                        enter(scope.textFields["From (\(unit))"], "10", app)
                        enter(scope.textFields["To (\(unit))"], "12", app)
                    } else { enter(scope.textFields["Distance (\(unit))"], "10", app) }
                    if paceRange {
                        enter(scope.textFields["Faster (min/\(unit))"], "500", app)
                        enter(scope.textFields["Slower (min/\(unit))"], "600", app)
                    } else { enter(scope.textFields["Pace (min/\(unit))"], "500", app) }
                    tap(scope.buttons["Estimate"], app)
                    let expected = distanceRange && paceRange ? "50:00 - 1:12:00" : (distanceRange || paceRange ? "50:00 - 1:00:00" : "50:00")
                    expectOutput(scope, expected)
                    mark("estimate-d\(distanceRange ? 2 : 1)-p\(paceRange ? 2 : 1)-\(unit)", app)
                }
            }
        }
    }

    @MainActor
    func testTargetPaceAllTimeDistanceCombinationsAndUnits() {
        let app = launch(tab: "Time")
        let scope = app.otherElements["time.target"]
        for unit in ["km", "mi"] {
            for distanceRange in [false, true] {
                for timeRange in [false, true] {
                    clear(scope, app)
                    choose(scope, "Target distance mode", distanceRange ? "Range" : "Distance", app)
                    choose(scope, "Target time mode", timeRange ? "Range" : "Time", app)
                    setUnit(scope, unit, pace: false, app)
                    if distanceRange {
                        enter(scope.textFields["From (\(unit))"], "5", app)
                        enter(scope.textFields["To (\(unit))"], "10", app)
                    } else { enter(scope.textFields["Distance (\(unit))"], "5", app) }
                    enterDuration(scope, label: timeRange ? "From Time" : "Target Time", minutes: "25", app)
                    if timeRange { enterDuration(scope, label: "To Time", minutes: "30", app) }
                    tap(scope.buttons["Find Pace"], app)
                    let expected = distanceRange && timeRange ? "2:30 - 6:00" : (distanceRange ? "2:30 - 5:00" : (timeRange ? "5:00 - 6:00" : "5:00"))
                    expectOutput(scope, expected)
                    mark("target-d\(distanceRange ? 2 : 1)-t\(timeRange ? 2 : 1)-\(unit)", app)
                }
            }
        }
    }

    @MainActor
    func testNormalRunAllEffortsAndUnits() {
        let app = launch(tab: "Workout")
        let scope = app.otherElements["workout.card"]
        for unit in ["km", "mi"] {
            for effort in ["None", "Single Pace", "Pace Range"] {
                clear(scope, app)
                menu(scope.buttons["workout.normal.unit"], unit == "km" ? "Kilometers" : "Miles", app)
                choose(scope, "Effort", effort, app)
                enter(scope.textFields["Distance"], "8", app)
                if effort == "Single Pace" { enter(scope.textFields["Pace"], "600", app) }
                if effort == "Pace Range" {
                    enter(scope.textFields["Faster Pace"], "600", app)
                    enter(scope.textFields["Slower Pace"], "630", app)
                }
                tap(scope.buttons["Convert"], app)
                XCTAssertEqual(app.staticTexts["workout.total"].label, unit == "km" ? "4.97 mi total" : "12.87 km total")
                mark("normal-\(effort)-\(unit)", app)
            }
        }
    }

    @MainActor
    func testIntervalsDistanceUnitsEffortsAndOutputUnits() {
        let app = launch(tab: "Workout")
        let scope = app.otherElements["workout.card"]
        let cases: [(String, String, String, String, String)] = [
            ("km", "Meters", "400", "None", "3.00 km total"),
            ("mi", "Meters", "400", "Single Pace", "1.87 mi total"),
            ("km", "Kilometers", "1.5", "Pace Range", "8.50 km total"),
            ("mi", "Kilometers", "1.5", "Pace Range", "5.27 mi total"),
            ("km", "Miles", "1.5", "Single Pace", "13.05 km total"),
            ("mi", "Miles", "1.5", "None", "8.12 mi total")
        ]
        for (outputUnit, distanceUnit, value, effort, expected) in cases {
            clear(scope, app)
            choose(scope, "Workout mode", "Intervals", app)
            choose(scope, "workout.output.unit", outputUnit == "km" ? "Kilometers" : "Miles", app)
            let work = section("Work", app)
            menu(work.buttons["interval.unit"], distanceUnit, app)
            choose(work, "Effort", effort, app)
            enter(work.textFields["Distance"], value, app)
            if effort == "Single Pace" || effort == "Pace Range" {
                let paceUnit = outputUnit == "mi" || distanceUnit == "Miles" ? "mi" : "km"
                setUnit(work, paceUnit, pace: true, app)
                if effort == "Single Pace" { enter(work.textFields["Pace"], "600", app) }
                else {
                    enter(work.textFields["Faster Pace"], "600", app)
                    enter(work.textFields["Slower Pace"], "630", app)
                }
            }
            tap(scope.buttons["Convert"], app)
            XCTAssertEqual(app.staticTexts["workout.total"].label, expected)
            mark("interval-distance-\(distanceUnit)-\(effort)-out-\(outputUnit)", app)
        }
    }

    @MainActor
    func testAllIntervalTimeFieldsHaveDoneAndExplicitComponents() {
        let app = launch(tab: "Workout")
        let scope = app.otherElements["workout.card"]
        for unit in ["km", "mi"] {
            clear(scope, app)
            choose(scope, "Workout mode", "Intervals", app)
            choose(scope, "workout.output.unit", unit == "km" ? "Kilometers" : "Miles", app)
            for name in ["Warm-up", "Work", "Recovery", "Cool-down"] {
                let s = section(name, app)
                choose(s, "Goal Type", "Time", app)
                choose(s, "Effort", "None", app)
                enterDuration(s, label: "\(name) Time", hours: name == "Cool-down" ? "1" : "0", minutes: name == "Cool-down" ? "35" : "2", seconds: "15", app)
            }
            tap(scope.buttons["Convert"], app)
            XCTAssertEqual(app.staticTexts["workout.total"].label, "0.00 \(unit) total")
            XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Cool-down: 1:35:15")).firstMatch.exists)
            mark("interval-all-time-\(unit)", app)
        }
    }

    @MainActor
    func testInvalidAndReversedInputsGiveSpecificErrors() {
        let app = launch(tab: "Pace")
        let pace = app.otherElements["pace.card"]
        enter(pace.textFields["Input (min/km)"], "0", app)
        tap(pace.buttons["Convert"], app)
        XCTAssertTrue(pace.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "greater than zero")).firstMatch.exists)
        clear(pace, app)
        choose(pace, "Pace mode", "Pace Range", app)
        enter(pace.textFields["Faster (min/km)"], "630", app)
        enter(pace.textFields["Slower (min/km)"], "600", app)
        tap(pace.buttons["Convert"], app)
        XCTAssertTrue(pace.staticTexts["Faster pace must be at or below Slower pace."].exists)
        mark("reject-zero-and-reversed-pace", app)

        app.tabBars.buttons["Distance"].tap()
        let distance = app.otherElements["distance.card"]
        choose(distance, "Distance mode", "Range", app)
        enter(distance.textFields["From (km)"], "12", app)
        enter(distance.textFields["To (km)"], "10", app)
        tap(distance.buttons["Convert"], app)
        XCTAssertTrue(distance.staticTexts["From distance must be at or below To distance."].exists)
        mark("reject-reversed-distance", app)

        app.tabBars.buttons["Time"].tap()
        let target = app.otherElements["time.target"]
        enter(target.textFields["Distance (km)"], "5", app)
        enter(target.textFields["Target Time, Minutes"], "135", app)
        tap(target.buttons["Find Pace"], app)
        XCTAssertTrue(target.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Minutes must be 0–59")).firstMatch.exists)
        clear(target, app)
        enter(target.textFields["Distance (km)"], "5", app)
        enter(target.textFields["Target Time, Seconds"], "72", app)
        tap(target.buttons["Find Pace"], app)
        XCTAssertTrue(target.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Seconds must be 0–59")).firstMatch.exists)
        mark("reject-135-minutes-and-72-seconds", app)
        clear(target, app)
        enter(target.textFields["Distance (km)"], "5", app)
        tap(target.buttons["Find Pace"], app)
        XCTAssertTrue(target.staticTexts["Enter a target time using Hours, Minutes, and Seconds."].exists)
        choose(target, "Target time mode", "Range", app)
        enterDuration(target, label: "From Time", minutes: "30", app)
        enterDuration(target, label: "To Time", minutes: "25", app)
        tap(target.buttons["Find Pace"], app)
        XCTAssertTrue(target.staticTexts["From Time must be at or below To Time."].exists)
        mark("reject-empty-and-reversed-target-time", app)
    }

    @MainActor
    func testOpenIntervalGoalsAndEditingControls() {
        let app = launch(tab: "Workout")
        let scope = app.otherElements["workout.card"]
        for unit in ["km", "mi"] {
            clear(scope, app)
            choose(scope, "Workout mode", "Intervals", app)
            choose(scope, "workout.output.unit", unit == "km" ? "Kilometers" : "Miles", app)
            for name in ["Warm-up", "Work", "Recovery", "Cool-down"] {
                let s = section(name, app)
                choose(s, "Goal Type", "Open", app)
                choose(s, "Effort", "None", app)
                XCTAssertEqual(s.textFields.count, 0)
            }
            tap(scope.buttons["Convert"], app)
            XCTAssertEqual(app.staticTexts["workout.total"].label, "0.00 \(unit) total")
            mark("interval-all-open-\(unit)", app)

            tap(scope.buttons["Add Step"], app)
            let newWork = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH %@", "workout.section.Work.")).element(boundBy: 1)
            enter(newWork.textFields["Distance"], "500", app)
            choose(newWork, "Step Role", "Recovery", app)
            let newRecovery = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH %@", "workout.section.Recovery.")).element(boundBy: 1)
            enterDuration(newRecovery, label: "Recovery Time", minutes: "2", seconds: "30", app)
            tap(newRecovery.buttons["Delete step"], app)
            XCTAssertEqual(app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH %@", "workout.section.Recovery.")).count, 1)
            tap(scope.buttons["Add Repeat Block"], app)
            XCTAssertEqual(scope.buttons.matching(identifier: "Delete").count, 2)
            tap(scope.buttons.matching(identifier: "Delete").element(boundBy: 1), app)
            XCTAssertEqual(scope.buttons.matching(identifier: "Delete").count, 0)
            mark("interval-add-role-delete-block-\(unit)", app)
        }
    }

    @MainActor
    func testDurationComponentsAtLargestTextSize() {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        app.tabBars.buttons["Time"].tap()
        let scope = app.otherElements["time.target"]
        tap(scope.buttons["Half Marathon"], app)
        enterDuration(scope, label: "Target Time", hours: "1", minutes: "35", seconds: "0", app)
        tap(scope.buttons["Find Pace"], app)
        expectOutput(scope, "4:30")
        mark("largest-text-half-marathon-95-min", app)
    }

    @MainActor
    func testRemovingAnEditingFieldDoesNotStrandTheKeyboard() {
        let app = launch(tab: "Pace")
        let pace = app.otherElements["pace.card"]
        tap(pace.textFields["Input (min/km)"], app)
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 2))
        choose(pace, "Pace mode", "Pace Range", app)
        if app.keyboards.firstMatch.exists {
            XCTAssertTrue(app.buttons["Done"].isHittable)
            app.buttons["Done"].tap()
        }
        app.tabBars.buttons["Workout"].tap()
        let workout = app.otherElements["workout.card"]
        tap(workout.textFields["Faster Pace"], app)
        choose(workout, "Effort", "None", app)
        XCTAssertEqual(XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: app.keyboards.firstMatch)], timeout: 3), .completed)
        XCTAssertFalse(app.buttons["Done"].exists)
        mark("focused-field-mode-removal", app)
    }

    @MainActor
    private func launch(tab: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", UIContentSizeCategory.large.rawValue]
        app.launch()
        XCTAssertTrue(app.staticTexts["Pace Converter"].waitForExistence(timeout: 5))
        if tab != "Pace" { app.tabBars.buttons[tab].tap() }
        return app
    }

    @MainActor
    private func section(_ name: String, _ app: XCUIApplication) -> XCUIElement {
        app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH %@", "workout.section.\(name).")).firstMatch
    }

    @MainActor
    private func reveal(_ element: XCUIElement, _ app: XCUIApplication) {
        let scroll = app.scrollViews.firstMatch
        // Lazy preset rows aren't instantiated until their panel comes into view.
        for _ in 0..<8 {
            if element.exists { break }
            scroll.swipeUp()
        }
        XCTAssertTrue(element.waitForExistence(timeout: 3))
        for _ in 0..<24 {
            if element.isHittable { return }
            let above = element.frame.midY < scroll.frame.midY
            scroll.coordinate(withNormalizedOffset: CGVector(dx: 0.94, dy: above ? 0.3 : 0.75))
                .press(forDuration: 0.05, thenDragTo: scroll.coordinate(withNormalizedOffset: CGVector(dx: 0.94, dy: above ? 0.75 : 0.3)))
        }
        XCTAssertTrue(element.isHittable, "Could not reach \(element)")
    }

    @MainActor private func tap(_ element: XCUIElement, _ app: XCUIApplication) { reveal(element, app); element.tap() }
    @MainActor private func clear(_ scope: XCUIElement, _ app: XCUIApplication) { tap(scope.buttons["Clear"], app) }
    @MainActor private func choose(_ scope: XCUIElement, _ picker: String, _ value: String, _ app: XCUIApplication) {
        tap(scope.segmentedControls[picker].buttons[value], app)
    }

    @MainActor
    private func setUnit(_ scope: XCUIElement, _ unit: String, pace: Bool, _ app: XCUIApplication) {
        let b = scope.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Change unit, currently ")).firstMatch
        let suffix = pace ? "/\(unit)" : unit.uppercased()
        if !b.label.hasSuffix(suffix) { tap(b, app) }
        XCTAssertTrue(b.label.hasSuffix(suffix))
    }

    @MainActor
    private func menu(_ picker: XCUIElement, _ value: String, _ app: XCUIApplication) {
        tap(picker, app)
        // The popup's collection also has labels used by the background output picker.
        let option = app.collectionViews.buttons[value]
        if option.waitForExistence(timeout: 1) { option.tap() }
        else { app.menuItems[value].tap() }
    }

    @MainActor
    private func enter(_ field: XCUIElement, _ text: String, _ app: XCUIApplication) {
        tap(field, app)
        let old = field.value as? String ?? ""
        field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: old.count) + text)
        let done = app.buttons["Done"]
        XCTAssertTrue(done.waitForExistence(timeout: 2))
        XCTAssertTrue(done.isHittable)
        done.tap()
        XCTAssertEqual(XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: app.keyboards.firstMatch)], timeout: 3), .completed)
    }

    @MainActor
    private func enterDuration(_ scope: XCUIElement, label: String, hours: String = "0", minutes: String, seconds: String = "0", _ app: XCUIApplication) {
        enter(scope.textFields["\(label), Hours"], hours, app)
        enter(scope.textFields["\(label), Minutes"], minutes, app)
        enter(scope.textFields["\(label), Seconds"], seconds, app)
    }

    @MainActor
    private func expectOutput(_ scope: XCUIElement, _ value: String) {
        let output = scope.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@", "converter.value.")).firstMatch
        XCTAssertTrue(output.waitForExistence(timeout: 3))
        XCTAssertEqual(output.label, value)
    }

    @MainActor
    private func mark(_ name: String, _ app: XCUIApplication) {
        print("AUDIT PASS: \(name)")
        let a = XCTAttachment(screenshot: app.screenshot()); a.name = name; a.lifetime = .keepAlways; add(a)
    }
}
