import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    func scheduleMissionReminder(at date: Date, missionTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "🚀 Alien Mission Awaits!"
        content.body = missionTitle
        content.sound = .default
        content.badge = 1

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: false)

        let request = UNNotificationRequest(identifier: "mission_\(UUID().uuidString)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling mission notification: \(error)")
            }
        }
    }

    func scheduleHabitReminder(at date: Date, habitName: String) {
        let content = UNMutableNotificationContent()
        content.title = "👽 Habit Check-in"
        content.body = "Don't forget: \(habitName)"
        content.sound = .default
        content.badge = 1

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: false)

        let request = UNNotificationRequest(identifier: "habit_\(UUID().uuidString)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling habit notification: \(error)")
            }
        }
    }

    func scheduleAchievementNotification(achievementName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🏆 Achievement Unlocked!"
        content.body = achievementName
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "achievement_\(UUID().uuidString)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling achievement notification: \(error)")
            }
        }
    }

    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}