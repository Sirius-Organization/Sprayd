//
//  SpraydUITestsLaunchTests.swift
//  SpraydUITests
//
//  Created by Егор Мальцев on 31.03.2026.
//

import XCTest

final class SpraydUITestsLaunchTests: XCTestCase {

    override static var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(
            app.wait(for: .runningForeground, timeout: 120),
            "Expected app to reach foreground after launch"
        )
    }
}
