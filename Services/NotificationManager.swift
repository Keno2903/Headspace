import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleDailyReminder(at time: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Dein täglicher Check-in"
        content.body = "Nimm dir einen Moment Zeit, um deine Stimmung und Gedanken festzuhalten."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(identifier: "EUNOIA_DAILY_REMINDER", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled successfully for \(time.hour!):\(time.minute!)")
            }
        }
    }

    func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["EUNOIA_DAILY_REMINDER"])
        print("Cancelled all scheduled reminders.")
    }
}
