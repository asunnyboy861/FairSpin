import Foundation
import SwiftData

@Observable
final class DataManager {
    var modelContainer: ModelContainer

    init() {
        let schema = Schema([
            Household.self,
            Member.self,
            Chore.self,
            CompletionRecord.self,
            RotationRecord.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        self.modelContainer = try! ModelContainer(for: schema, configurations: [config])
    }

    var mainContext: ModelContext {
        modelContainer.mainContext
    }

    func fetchHousehold() -> Household? {
        let descriptor = FetchDescriptor<Household>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try? mainContext.fetch(descriptor).first
    }

    func createHousehold(name: String) -> Household {
        let household = Household(name: name)
        mainContext.insert(household)
        try? mainContext.save()
        return household
    }

    func addMember(name: String, avatarEmoji: String, to household: Household) -> Member {
        let member = Member(name: name, avatarEmoji: avatarEmoji, isOwner: household.members.isEmpty)
        member.household = household
        household.members.append(member)
        mainContext.insert(member)
        try? mainContext.save()
        return member
    }

    func addChore(title: String, category: ChoreCategory, effortWeight: Int, frequency: ChoreFrequency, to household: Household) -> Chore {
        let chore = Chore(title: title, category: category, effortWeight: effortWeight, frequency: frequency)
        chore.household = household
        household.chores.append(chore)
        mainContext.insert(chore)
        try? mainContext.save()
        return chore
    }

    func completeChore(_ chore: Chore, memberId: UUID) {
        let record = CompletionRecord(memberId: memberId, chore: chore)
        chore.completions.append(record)
        mainContext.insert(record)
        try? mainContext.save()
    }

    func deleteChore(_ chore: Chore) {
        mainContext.delete(chore)
        try? mainContext.save()
    }

    func deleteMember(_ member: Member) {
        mainContext.delete(member)
        try? mainContext.save()
    }

    func runRotation(for household: Household) {
        let assignments = FairRotationEngine.calculateAssignments(
            chores: household.chores,
            members: household.members,
            history: household.chores.flatMap { $0.completions }
        )

        for assignment in assignments {
            let fromId = assignment.chore.assignedMemberId
            assignment.chore.assignedMemberId = assignment.assignedMemberId

            let record = RotationRecord(choreId: assignment.chore.id, from: fromId, to: assignment.assignedMemberId)
            household.rotationHistory.append(record)
            mainContext.insert(record)
        }

        try? mainContext.save()
    }

    func memberForId(_ id: UUID?, in household: Household) -> Member? {
        guard let id = id else { return nil }
        return household.members.first { $0.id == id }
    }
}
