#if canImport(UIKit)
import UIKit

enum Haptics {
    typealias ImpactStyle = UIImpactFeedbackGenerator.FeedbackStyle

    static func impact(_ style: ImpactStyle = .medium) {
import Foundation
import UIKit

enum Haptics {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
#else
import Foundation

enum Haptics {
    enum ImpactStyle {
        case light
        case medium
        case heavy
    }

    static func impact(_ style: ImpactStyle = .medium) {}

    static func success() {}
}
#endif
