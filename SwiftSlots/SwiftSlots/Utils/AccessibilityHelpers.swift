import SwiftUI

extension View {
    func voiceOverHint(_ hint: String) -> some View {
        accessibilityHint(Text(hint))
    }
}
