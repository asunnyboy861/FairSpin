import SwiftData
import Foundation

@Model
final class CompletionRecord {
    @Attribute(.unique) var id: UUID
    var completedAt: Date
    var memberId: UUID
    var chore: Chore

    init(memberId: UUID, chore: Chore) {
        self.id = UUID()
        self.completedAt = Date()
        self.memberId = memberId
        self.chore = chore
    }
}
