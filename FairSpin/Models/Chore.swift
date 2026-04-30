import SwiftData
import Foundation

@Model
final class Chore {
    @Attribute(.unique) var id: UUID
    var title: String
    var categoryRaw: String
    var effortWeight: Int
    var frequencyRaw: String
    var customIntervalDays: Int
    var isRotationEnabled: Bool
    var assignedMemberId: UUID?
    var household: Household?
    var createdAt: Date

    @Relationship(deleteRule: .cascade)
    var completions: [CompletionRecord]

    var category: ChoreCategory {
        get { ChoreCategory(rawValue: categoryRaw) ?? .cleaning }
        set { categoryRaw = newValue.rawValue }
    }

    var frequency: ChoreFrequency {
        get { ChoreFrequency(rawValue: frequencyRaw) ?? .weekly }
        set { frequencyRaw = newValue.rawValue }
    }

    var nextDueDate: Date {
        guard let lastCompletion = completions.sorted(by: { $0.completedAt > $1.completedAt }).first else {
            return createdAt
        }
        let interval: TimeInterval
        switch frequency {
        case .daily: interval = 86400
        case .weekly: interval = 604800
        case .biweekly: interval = 1209600
        case .monthly: interval = 2592000
        case .custom: interval = Double(customIntervalDays) * 86400
        }
        return lastCompletion.completedAt.addingTimeInterval(interval)
    }

    var isOverdue: Bool {
        nextDueDate < Date()
    }

    var isDueToday: Bool {
        Calendar.current.isDateInToday(nextDueDate)
    }

    init(title: String, category: ChoreCategory = .cleaning, effortWeight: Int = 1, frequency: ChoreFrequency = .weekly) {
        self.id = UUID()
        self.title = title
        self.categoryRaw = category.rawValue
        self.effortWeight = effortWeight
        self.frequencyRaw = frequency.rawValue
        self.customIntervalDays = 7
        self.isRotationEnabled = true
        self.completions = []
        self.createdAt = Date()
    }
}
