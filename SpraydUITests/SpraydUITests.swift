//
//  SpraydUITests.swift
//  SpraydUITests
//
//  Created by Егор Мальцев on 31.03.2026.
//

import XCTest

final class SpraydUITests: XCTestCase {
    private enum Timeout {
        static let feedLoad: TimeInterval = 12
    }

    private func makeApp(startOnFeed: Bool = true) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-ui-testing"]

        if startOnFeed {
            app.launchArguments += ["-ui-testing-start-feed"]
        }

        return app
    }

    private func featuredCard(in app: XCUIApplication) -> XCUIElement {
        app.buttons["feed.featuredCard"].firstMatch
    }

    private func artObjectRoot(in app: XCUIApplication) -> XCUIElement {
        app.scrollViews["artObject.root"].firstMatch
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testFeedLaunchShowsSearchFieldAndFeaturedCard() throws {
        let app = makeApp()
        app.launch()

        XCTAssertTrue(app.scrollViews["feed.root"].waitForExistence(timeout: Timeout.feedLoad))
        XCTAssertTrue(app.textFields["searchBar.textField"].exists)
        XCTAssertTrue(featuredCard(in: app).waitForExistence(timeout: Timeout.feedLoad))
    }

    @MainActor
    func testTappingFeaturedCardOpensArtObjectScreen() throws {
        let app = makeApp()
        app.launch()

        let featuredCard = featuredCard(in: app)
        XCTAssertTrue(featuredCard.waitForExistence(timeout: Timeout.feedLoad))

        featuredCard.tap()

        XCTAssertTrue(artObjectRoot(in: app).waitForExistence(timeout: Timeout.feedLoad))
    }

    @MainActor
    func testFeedLaunchCapturesScreenshot() throws {
        let app = makeApp()
        app.launch()

        XCTAssertTrue(featuredCard(in: app).waitForExistence(timeout: Timeout.feedLoad))

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "FeedLaunch"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
