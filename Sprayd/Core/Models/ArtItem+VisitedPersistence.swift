import Foundation
import SwiftData

extension ArtItem {
    @MainActor
    func toggleVisited(in modelContext: ModelContext) {
        isVisited.toggle()

        do {
            try modelContext.save()
        } catch {
            isVisited.toggle()
            print("Visited save error:", error)
        }
    }
}
