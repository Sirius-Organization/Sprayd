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

        let mapTab = app.tabBars.buttons["Map"]
        XCTAssertTrue(
            mapTab.waitForExistence(timeout: 30),
            "Expected 'Map' tab to appear after launch"
        )

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
