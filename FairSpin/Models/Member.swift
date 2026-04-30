import SwiftData
import Foundation

@Model
final class Member {
    @Attribute(.unique) var id: UUID
    var name: String
    var avatarEmoji: String
    var isOwner: Bool
    var colorHex: String
    var household: Household?

    @Relationship(deleteRule: .cascade)
    var completions: [CompletionRecord]

    var fairScore: Double {
        completions.reduce(0.0) { $0 + Double($1.chore.effortWeight) }
    }

    init(name: String, avatarEmoji: String = "👤", isOwner: Bool = false) {
        self.id = UUID()
        self.name = name
        self.avatarEmoji = avatarEmoji
        self.isOwner = isOwner
        self.colorHex = "#007AFF"
        self.completions = []
    }
}
