import Foundation

extension Date {
    func formattedTimeRange(endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return "\(formatter.string(from: self)) – \(formatter.string(from: endDate))"
    }

    func relativeCountdownText() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        formatter.maximumUnitCount = 1
        if timeIntervalSinceNow <= 0 {
            return "Now"
        }
        return formatter.string(from: timeIntervalSinceNow) ?? "Soon"
    }
}
