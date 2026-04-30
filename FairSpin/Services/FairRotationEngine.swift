import Foundation
import SwiftData

final class FairRotationEngine {

    struct RotationAssignment: Identifiable {
        let id = UUID()
        let chore: Chore
        let assignedMemberId: UUID
        let reason: String
    }

    static func calculateAssignments(
        chores: [Chore],
        members: [Member],
        history: [CompletionRecord]
    ) -> [RotationAssignment] {
        guard !members.isEmpty else { return [] }

        var assignments: [RotationAssignment] = []
        let memberScores = calculateFairScores(members: members, history: history)
        let sortedMembers = members.sorted {
            (memberScores[$0.id] ?? 0) < (memberScores[$1.id] ?? 0)
        }

        let rotatableChores = chores.filter { $0.isRotationEnabled }
        let sortedChores = rotatableChores.sorted { $0.effortWeight > $1.effortWeight }

        var memberWorkload: [UUID: Double] = [:]
        for member in members {
            memberWorkload[member.id] = 0
        }

        for chore in sortedChores {
            guard let bestMember = findBestMember(
                for: chore,
                members: sortedMembers,
                memberScores: memberScores,
                memberWorkload: memberWorkload
            ) else { continue }

            memberWorkload[bestMember.id] = (memberWorkload[bestMember.id] ?? 0) + Double(chore.effortWeight)

            let scoreDiff = maxScoreDiff(memberScores: memberScores)
            let reason = scoreDiff > 5
                ? "\(bestMember.name) has the lightest load"
                : "Fair rotation"

            assignments.append(RotationAssignment(
                chore: chore,
                assignedMemberId: bestMember.id,
                reason: reason
            ))
        }

        return assignments
    }

    private static func calculateFairScores(
        members: [Member],
        history: [CompletionRecord]
    ) -> [UUID: Double] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentHistory = history.filter { $0.completedAt >= thirtyDaysAgo }

        var scores: [UUID: Double] = [:]
        for member in members {
            let memberCompletions = recentHistory.filter { $0.memberId == member.id }
            let totalWeight = memberCompletions.reduce(0.0) { $0 + Double($1.chore.effortWeight) }
            scores[member.id] = totalWeight
        }
        return scores
    }

    private static func findBestMember(
        for chore: Chore,
        members: [Member],
        memberScores: [UUID: Double],
        memberWorkload: [UUID: Double]
    ) -> Member? {
        members.min { memberA, memberB in
            let scoreA = (memberScores[memberA.id] ?? 0) + (memberWorkload[memberA.id] ?? 0)
            let scoreB = (memberScores[memberB.id] ?? 0) + (memberWorkload[memberB.id] ?? 0)
            if scoreA == scoreB {
                return Bool.random()
            }
            return scoreA < scoreB
        }
    }

    private static func maxScoreDiff(memberScores: [UUID: Double]) -> Double {
        let values = memberScores.values
        guard let minVal = values.min(), let maxVal = values.max() else { return 0 }
        return maxVal - minVal
    }
}
