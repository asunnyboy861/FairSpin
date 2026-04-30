import SwiftData
import Foundation

@Model
final class RotationRecord {
    @Attribute(.unique) var id: UUID
    var choreId: UUID
    var fromMemberId: UUID?
    var toMemberId: UUID
    var rotatedAt: Date

    init(choreId: UUID, from: UUID?, to: UUID) {
        self.id = UUID()
        self.choreId = choreId
        self.fromMemberId = from
        self.toMemberId = to
        self.rotatedAt = Date()
    }
}
