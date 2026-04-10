//
//  AppTestingSupport.swift
//  Sprayd
//

import Foundation
import SwiftData

enum AppLaunchArgument: String {
    case uiTesting = "-ui-testing"
    case startFeed = "-ui-testing-start-feed"
}

struct AppTestingConfiguration {
    private let arguments: Set<String>

    init(processInfo: ProcessInfo = .processInfo) {
        self.arguments = Set(processInfo.arguments)
    }

    var isUITesting: Bool {
        arguments.contains(AppLaunchArgument.uiTesting.rawValue)
    }

    var usesInMemoryStore: Bool {
        isUITesting
    }

    var shouldSkipOnboarding: Bool {
        isUITesting
    }

    var shouldDisableLocationRequests: Bool {
        isUITesting
    }

    var shouldDisableAutomaticSync: Bool {
        isUITesting
    }

    var shouldDisableMapLoading: Bool {
        isUITesting
    }

    var initialTab: AppTab {
        arguments.contains(AppLaunchArgument.startFeed.rawValue) ? .feed : .map
    }

    static let current = AppTestingConfiguration()
}

@MainActor
enum AppTestingBootstrapper {
    private static let testSchema = Schema([
        Author.self,
        ArtItem.self,
        ArtImage.self
    ])

    static func applyRuntimeOverrides() {
        guard AppTestingConfiguration.current.shouldSkipOnboarding else { return }

        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "hasCompletedOnboarding")
        defaults.set(true, forKey: "isLoggedIn")
    }

    static func makeModelContainer() -> ModelContainer {
        guard AppTestingConfiguration.current.usesInMemoryStore else {
            return sharedModelContainer
        }

        let configuration = ModelConfiguration(
            schema: testSchema,
            isStoredInMemoryOnly: true
        )

        do {
            let container = try ModelContainer(
                for: testSchema,
                configurations: [configuration]
            )
            seedSampleData(into: container.mainContext)
            return container
        } catch {
            fatalError("Failed to create UI test model container: \(error)")
        }
    }

    private static func seedSampleData(into context: ModelContext) {
        let featuredItem = ArtItem(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            name: "All your walls sing",
            itemDescription: "Large typographic mural on an industrial facade.",
            images: [
                ArtImage(
                    urlString: "https://example.com/feed-featured.jpg",
                    createdAt: Date(timeIntervalSince1970: 1_712_700_000),
                    timeStamp: 1
                )
            ],
            location: "ул. Малышева, 21/4, Yekaterinburg",
            author: "Pokras Lampas",
            uploadedBy: "Team",
            createdAt: Date(timeIntervalSince1970: 1_712_700_000),
            createdDate: Date(timeIntervalSince1970: 1_712_700_000),
            state: .new,
            category: "Mural",
            latitude: 56.8389,
            longitude: 60.6057
        )

        let discoverItem = ArtItem(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            name: "Paper Gesture",
            itemDescription: "Monumental wall piece with a painted hand.",
            images: [
                ArtImage(
                    urlString: "https://example.com/feed-discover.jpg",
                    createdAt: Date(timeIntervalSince1970: 1_712_613_600),
                    timeStamp: 1
                )
            ],
            location: "Ленина 8, Yekaterinburg",
            author: "Case Maclaim",
            uploadedBy: "George",
            createdAt: Date(timeIntervalSince1970: 1_712_613_600),
            createdDate: Date(timeIntervalSince1970: 1_712_613_600),
            state: .new,
            category: "Street Art",
            latitude: 56.8394,
            longitude: 60.6141
        )

        let items = [featuredItem, discoverItem]

        for item in items {
            context.insert(item)
        }

        try? context.save()
    }
}
