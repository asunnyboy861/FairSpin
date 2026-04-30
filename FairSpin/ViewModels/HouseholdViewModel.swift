import SwiftUI
import SwiftData

@Observable
final class HouseholdViewModel {
    var dataManager: DataManager

    var household: Household?

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.household = dataManager.fetchHousehold()
    }

    var members: [Member] {
        household?.members ?? []
    }

    var chores: [Chore] {
        household?.chores ?? []
    }

    var dueChores: [Chore] {
        chores.filter { $0.isDueToday || $0.isOverdue }
    }

    var overdueChores: [Chore] {
        chores.filter { $0.isOverdue }
    }

    func createHousehold(name: String) {
        household = dataManager.createHousehold(name: name)
    }

    func addMember(name: String, avatarEmoji: String) {
        guard let household = household else { return }
        _ = dataManager.addMember(name: name, avatarEmoji: avatarEmoji, to: household)
    }

    func addChore(title: String, category: ChoreCategory, effortWeight: Int, frequency: ChoreFrequency) {
        guard let household = household else { return }
        _ = dataManager.addChore(title: title, category: category, effortWeight: effortWeight, frequency: frequency, to: household)
    }

    func completeChore(_ chore: Chore, memberId: UUID) {
        dataManager.completeChore(chore, memberId: memberId)
    }

    func deleteChore(_ chore: Chore) {
        dataManager.deleteChore(chore)
    }

    func deleteMember(_ member: Member) {
        dataManager.deleteMember(member)
    }

    func runRotation() {
        guard let household = household else { return }
        dataManager.runRotation(for: household)
    }

    func memberForId(_ id: UUID?) -> Member? {
        guard let id = id, let household = household else { return nil }
        return dataManager.memberForId(id, in: household)
    }

    func completeOnboarding() {
        household?.isOnboarded = true
        try? dataManager.mainContext.save()
    }

    func fairScoreForMember(_ member: Member) -> Double {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentCompletions = member.completions.filter { $0.completedAt >= thirtyDaysAgo }
        return recentCompletions.reduce(0.0) { $0 + Double($1.chore.effortWeight) }
    }

    var totalFairScore: Double {
        members.reduce(0.0) { $0 + fairScoreForMember($1) }
    }

    var isFair: Bool {
        guard members.count >= 2 else { return true }
        let scores = members.map { fairScoreForMember($0) }
        let maxScore = scores.max() ?? 0
        let minScore = scores.min() ?? 0
        return (maxScore - minScore) <= 3
    }
}
