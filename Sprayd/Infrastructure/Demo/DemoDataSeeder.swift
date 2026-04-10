//
//  DemoDataSeeder.swift
//  Sprayd
//
//  Seeds realistic local content so the app remains demoable offline.
//

import SwiftData
import UIKit

@MainActor
enum DemoDataSeeder {
    private static let userID = UUID(uuidString: "B22681AD-B398-4E02-8D08-0CF7A97C5C3D")!

    static func seedIfNeeded(in modelContext: ModelContext) {
        guard DemoMode.isEnabled else { return }

        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(userID.uuidString, forKey: "userId")
        UserDefaults.standard.set(DemoMode.email, forKey: "userEmail")

        seedAuthors(in: modelContext)
        seedArtItems(in: modelContext)

        if modelContext.hasChanges {
            try? modelContext.save()
        }
    }

    private static func seedAuthors(in modelContext: ModelContext) {
        for author in demoAuthors {
            upsertAuthor(author, in: modelContext)
        }
    }

    private static func upsertAuthor(_ seed: AuthorSeed, in modelContext: ModelContext) {
        let id = seed.id
        let descriptor = FetchDescriptor<Author>(
            predicate: #Predicate<Author> { author in
                author.id == id
            }
        )

        if let author = try? modelContext.fetch(descriptor).first {
            author.name = seed.name
            author.bio = seed.bio
            author.imageURLString = nil
        } else {
            modelContext.insert(
                Author(
                    id: seed.id,
                    name: seed.name,
                    bio: seed.bio
                )
            )
        }
    }

    private static func seedArtItems(in modelContext: ModelContext) {
        for item in demoItems {
            upsertArtItem(item, in: modelContext)
        }
    }

    private static func upsertArtItem(_ seed: ArtItemSeed, in modelContext: ModelContext) {
        let id = seed.id
        let descriptor = FetchDescriptor<ArtItem>(
            predicate: #Predicate<ArtItem> { item in
                item.id == id
            }
        )
        let imageURL = imageURL(for: seed)

        if let item = try? modelContext.fetch(descriptor).first {
            item.name = seed.name
            item.itemDescription = seed.description
            item.location = seed.location
            item.author = seed.author
            item.uploadedBy = seed.uploadedBy
            item.createdAt = seed.createdAt
            item.createdDate = seed.createdDate
            item.state = seed.state
            item.category = seed.category
            item.isFavorite = seed.isFavorite
            item.latitude = seed.latitude
            item.longitude = seed.longitude
            syncImage(imageURL, for: item)
        } else {
            let item = ArtItem(
                id: seed.id,
                name: seed.name,
                itemDescription: seed.description,
                images: [
                    ArtImage(
                        id: seed.imageID,
                        urlString: imageURL.absoluteString,
                        createdAt: seed.createdAt,
                        timeStamp: seed.createdAt.timeIntervalSince1970,
                        userID: userID
                    )
                ],
                location: seed.location,
                author: seed.author,
                uploadedBy: seed.uploadedBy,
                createdAt: seed.createdAt,
                createdDate: seed.createdDate,
                state: seed.state,
                category: seed.category,
                isFavorite: seed.isFavorite,
                latitude: seed.latitude,
                longitude: seed.longitude
            )
            modelContext.insert(item)
        }
    }

    private static func syncImage(_ imageURL: URL, for item: ArtItem) {
        if let image = item.images.first {
            image.urlString = imageURL.absoluteString
            image.createdAt = item.createdAt
            image.timeStamp = item.createdAt.timeIntervalSince1970
            image.userID = userID
        } else {
            item.images = [
                ArtImage(
                    urlString: imageURL.absoluteString,
                    createdAt: item.createdAt,
                    timeStamp: item.createdAt.timeIntervalSince1970,
                    userID: userID
                )
            ]
        }
    }

    private static func imageURL(for seed: ArtItemSeed) -> URL {
        let directoryURL = URL.applicationSupportDirectory
            .appending(path: "Sprayd", directoryHint: .isDirectory)
            .appending(path: "DemoImages", directoryHint: .isDirectory)

        try? FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        let fileURL = directoryURL.appending(path: "\(seed.slug).png")
        guard !FileManager.default.fileExists(atPath: fileURL.path) else {
            return fileURL
        }

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1200, height: 820))
        let image = renderer.image { context in
            drawDemoImage(seed, in: context.cgContext, size: CGSize(width: 1200, height: 820))
        }
        try? image.pngData()?.write(to: fileURL, options: .atomic)
        return fileURL
    }

    private static func drawDemoImage(_ seed: ArtItemSeed, in context: CGContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        let colors = seed.colors.map(\.cgColor) as CFArray
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors,
            locations: [0, 1]
        )

        if let gradient {
            context.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
        }

        UIColor.black.withAlphaComponent(0.18).setFill()
        context.fill(rect)

        for index in 0..<7 {
            let inset = CGFloat(index) * 62
            let shapeRect = rect.insetBy(dx: inset + 70, dy: inset + 52)
            context.setStrokeColor(UIColor.white.withAlphaComponent(0.16).cgColor)
            context.setLineWidth(18)
            context.strokeEllipse(in: shapeRect)
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        paragraph.lineBreakMode = .byWordWrapping

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 78, weight: .black),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraph
        ]
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 34, weight: .semibold),
            .foregroundColor: UIColor.white.withAlphaComponent(0.82),
            .paragraphStyle: paragraph
        ]

        NSString(string: seed.name.uppercased()).draw(
            in: CGRect(x: 76, y: 560, width: 980, height: 110),
            withAttributes: titleAttributes
        )
        NSString(string: "\(seed.category) / \(seed.author)").draw(
            in: CGRect(x: 82, y: 675, width: 980, height: 54),
            withAttributes: subtitleAttributes
        )
    }
}

private struct AuthorSeed {
    let id: UUID
    let name: String
    let bio: String
}

private struct ArtItemSeed {
    let id: UUID
    let imageID: UUID
    let slug: String
    let name: String
    let description: String
    let location: String
    let author: String
    let uploadedBy: String
    let createdAt: Date
    let createdDate: Date
    let state: ArtState
    let category: String
    let isFavorite: Bool
    let latitude: Double
    let longitude: Double
    let colors: [UIColor]
}

private let demoAuthors: [AuthorSeed] = [
    AuthorSeed(
        id: UUID(uuidString: "85E0EE9D-665D-46FE-AF05-78EBD3B85585")!,
        name: "Nikita Nomerz",
        bio: "Street artist known for character-driven urban interventions."
    ),
    AuthorSeed(
        id: UUID(uuidString: "F53F8A7B-AE8A-45DA-B489-B80C03B04B85")!,
        name: "Masha Somik",
        bio: "Illustrator and muralist working with bright botanical forms."
    ),
    AuthorSeed(
        id: UUID(uuidString: "0A7B6B3D-BE23-4B4A-AE45-935CD8A7E3B8")!,
        name: "Kirill Kto",
        bio: "Text-based street artist exploring city rhythm and memory."
    )
]

private let demoItems: [ArtItemSeed] = [
    ArtItemSeed(
        id: UUID(uuidString: "C6B3C246-7346-4EE4-BC7C-86E7438E7C56")!,
        imageID: UUID(uuidString: "6302DF1B-E8B2-46BC-B292-8F6943516456")!,
        slug: "garden-wall",
        name: "Garden Wall",
        description: "A wide botanical mural that turns a plain courtyard facade into a dense tropical scene.",
        location: "Khlebozavod, Moscow",
        author: "Masha Somik",
        uploadedBy: DemoMode.username,
        createdAt: Date(timeIntervalSince1970: 1_775_347_200),
        createdDate: Date(timeIntervalSince1970: 1_775_347_200),
        state: .exists,
        category: "Mural",
        isFavorite: true,
        latitude: 55.8044,
        longitude: 37.5849,
        colors: [UIColor(red: 0.09, green: 0.43, blue: 0.31, alpha: 1), UIColor(red: 0.96, green: 0.68, blue: 0.25, alpha: 1)]
    ),
    ArtItemSeed(
        id: UUID(uuidString: "566E94DF-B7C1-41BC-861E-616C92F7D7D3")!,
        imageID: UUID(uuidString: "BC7B0312-2F81-460F-A2B5-10D74ECA940C")!,
        slug: "signal-bird",
        name: "Signal Bird",
        description: "A compact stencil near a metro entrance, layered over older posters and tags.",
        location: "Tverskoy District, Moscow",
        author: "Nikita Nomerz",
        uploadedBy: "urban_fox",
        createdAt: Date(timeIntervalSince1970: 1_774_915_200),
        createdDate: Date(timeIntervalSince1970: 1_774_915_200),
        state: .moderated,
        category: "Stencil",
        isFavorite: false,
        latitude: 55.7655,
        longitude: 37.6050,
        colors: [UIColor(red: 0.10, green: 0.18, blue: 0.54, alpha: 1), UIColor(red: 0.95, green: 0.30, blue: 0.20, alpha: 1)]
    ),
    ArtItemSeed(
        id: UUID(uuidString: "A76AF345-D292-4834-9A40-7DE37104C166")!,
        imageID: UUID(uuidString: "A49E23A7-4DF3-499F-A283-25876D5C8062")!,
        slug: "neon-letters",
        name: "Neon Letters",
        description: "A text piece painted across a service gate, visible at night under storefront lights.",
        location: "Sretenka, Moscow",
        author: "Kirill Kto",
        uploadedBy: DemoMode.username,
        createdAt: Date(timeIntervalSince1970: 1_773_705_600),
        createdDate: Date(timeIntervalSince1970: 1_773_705_600),
        state: .exists,
        category: "Graffiti",
        isFavorite: true,
        latitude: 55.7659,
        longitude: 37.6317,
        colors: [UIColor(red: 0.51, green: 0.05, blue: 0.31, alpha: 1), UIColor(red: 0.08, green: 0.86, blue: 0.84, alpha: 1)]
    ),
    ArtItemSeed(
        id: UUID(uuidString: "AD1787C1-E4F9-49B4-A1CB-65524B84B8D7")!,
        imageID: UUID(uuidString: "B00F6DBA-5D61-439A-846C-566169D0E7F3")!,
        slug: "red-courtyard",
        name: "Red Courtyard",
        description: "A geometric wall painting in a residential courtyard, built around bold red blocks.",
        location: "Basmanny District, Moscow",
        author: "Masha Somik",
        uploadedBy: "line_walker",
        createdAt: Date(timeIntervalSince1970: 1_772_928_000),
        createdDate: Date(timeIntervalSince1970: 1_772_928_000),
        state: .new,
        category: "Installation",
        isFavorite: false,
        latitude: 55.7647,
        longitude: 37.6474,
        colors: [UIColor(red: 0.78, green: 0.08, blue: 0.08, alpha: 1), UIColor(red: 0.98, green: 0.80, blue: 0.30, alpha: 1)]
    ),
    ArtItemSeed(
        id: UUID(uuidString: "BF905077-2E60-494C-B063-5A1759E6687F")!,
        imageID: UUID(uuidString: "B7F7FB48-A336-4E70-A23D-ADDB9D4673E0")!,
        slug: "paper-portal",
        name: "Paper Portal",
        description: "A poster collage under a railway bridge, refreshed by local contributors every few weeks.",
        location: "Artplay, Moscow",
        author: "Nikita Nomerz",
        uploadedBy: "pasteup_notes",
        createdAt: Date(timeIntervalSince1970: 1_771_804_800),
        createdDate: Date(timeIntervalSince1970: 1_771_804_800),
        state: .exists,
        category: "Poster",
        isFavorite: false,
        latitude: 55.7523,
        longitude: 37.6684,
        colors: [UIColor(red: 0.19, green: 0.17, blue: 0.13, alpha: 1), UIColor(red: 0.93, green: 0.46, blue: 0.18, alpha: 1)]
    ),
    ArtItemSeed(
        id: UUID(uuidString: "C166222F-B253-46F3-A9B7-C91789987E01")!,
        imageID: UUID(uuidString: "8D81502C-126E-48E4-BA52-2798BBBA23A9")!,
        slug: "blue-window",
        name: "Blue Window",
        description: "A small sticker cluster arranged like a window on a utility cabinet.",
        location: "Zamoskvorechye, Moscow",
        author: "Kirill Kto",
        uploadedBy: DemoMode.username,
        createdAt: Date(timeIntervalSince1970: 1_770_595_200),
        createdDate: Date(timeIntervalSince1970: 1_770_595_200),
        state: .moderated,
        category: "Sticker art",
        isFavorite: true,
        latitude: 55.7390,
        longitude: 37.6250,
        colors: [UIColor(red: 0.04, green: 0.20, blue: 0.45, alpha: 1), UIColor(red: 0.35, green: 0.77, blue: 0.96, alpha: 1)]
    )
]
