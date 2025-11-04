import Foundation
import UserNotifications
import SwiftUI

protocol NotificationHandling {
    func requestAuthorization() async -> Bool
    func scheduleDealAlert(for slot: Slot, business: Business)
    func simulateNotification()
}

final class NotificationService: NotificationHandling {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleDealAlert(for slot: Slot, business: Business) {
        let content = UNMutableNotificationContent()
        content.title = "Swift Slots Alert"
        content.subtitle = "\(business.name) just dropped a deal!"
        content.body = "\(slot.title) starts in \(slot.startDate.relativeCountdownText()). Tap to book before it's gone."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: slot.id.uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func simulateNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Swift Slots Demo"
        content.body = "Stay ready — new last-minute deals are popping up in Austin."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}
