import SwiftUI

struct SettingsView: View {
    @AppStorage("remindersEnabled") private var remindersEnabled = false
    @AppStorage("reminderTime") private var reminderTime: Double = 8 * 3600 // Default to 8:00 AM

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tägliche Erinnerung"), footer: Text("Erhalte eine Benachrichtigung, um deinen täglichen Eintrag nicht zu vergessen.")) {
                    Toggle("Erinnerungen aktivieren", isOn: $remindersEnabled)
                        .onChange(of: remindersEnabled) { value in
                            updateNotifications()
                        }

                    if remindersEnabled {
                        DatePicker("Uhrzeit", selection: Binding(get: {
                            Date(timeIntervalSince1970: reminderTime)
                        }, set: { date in
                            reminderTime = date.timeIntervalSince1970
                            updateNotifications()
                        }), displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("Einstellungen")
        }
    }

    private func updateNotifications() {
        if remindersEnabled {
            print("Enabling reminders.")
            NotificationManager.shared.requestAuthorization()
            let date = Date(timeIntervalSince1970: reminderTime)
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            NotificationManager.shared.scheduleDailyReminder(at: components)
        } else {
            print("Disabling reminders.")
            NotificationManager.shared.cancelNotifications()
        }
    }
}

#Preview {
    SettingsView()
}
