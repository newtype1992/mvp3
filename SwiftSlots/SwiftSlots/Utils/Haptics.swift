import Foundation

#if canImport(UIKit)
import UIKit
#endif

enum Haptics {
    #if canImport(UIKit)
    typealias ImpactStyle = UIImpactFeedbackGenerator.FeedbackStyle
    #else
    enum ImpactStyle {
        case light
        case medium
        case heavy
    }
    #endif

    static func impact(_ style: ImpactStyle = .medium) {
        #if canImport(UIKit)
        UIImpactFeedbackGenerator(style: style).impactOccurred()
        #endif
    }

    static func success() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
}
