import Foundation
import UserNotifications

final class NotificationService {

    static let shared = NotificationService()

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func scheduleChoreReminder(chore: Chore, memberName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Chore Reminder"
        content.body = "\(chore.title) is due today" + (memberName.isEmpty ? "" : " — \(memberName)'s turn")
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(hour: 9, minute: 0),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "chore-\(chore.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelChoreReminder(choreId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["chore-\(choreId.uuidString)"])
    }

    func scheduleRotationNotification(householdName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Chores Rotated!"
        content.body = "New chore assignments for \(householdName) are ready"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(hour: 8, minute: 0, weekday: 2),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "rotation-\(householdName)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
