import SwiftData
import Foundation

@Model
final class Household {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var rotationDayRaw: Int
    var notifyBeforeDue: Bool
    var notifyOnRotation: Bool
    var fairModeEnabled: Bool
    var isOnboarded: Bool

    @Relationship(deleteRule: .cascade, inverse: \Member.household)
    var members: [Member]

    @Relationship(deleteRule: .cascade, inverse: \Chore.household)
    var chores: [Chore]

    @Relationship(deleteRule: .cascade)
    var rotationHistory: [RotationRecord]

    var rotationDay: Int {
        get { rotationDayRaw }
        set { rotationDayRaw = newValue }
    }

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.rotationDayRaw = 1
        self.notifyBeforeDue = true
        self.notifyOnRotation = true
        self.fairModeEnabled = true
        self.isOnboarded = false
        self.members = []
        self.chores = []
        self.rotationHistory = []
    }
}
