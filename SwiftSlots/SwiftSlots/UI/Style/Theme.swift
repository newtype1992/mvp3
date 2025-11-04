import SwiftUI

enum Theme {
    static let brandPrimary = Color(hex: "#5D5FEF")
    static let background = Color("Background")
    static let surface = Color("Surface")
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")

    static func gradient(for category: Category) -> LinearGradient {
        LinearGradient(
            colors: [category.color.color.opacity(0.8), Theme.brandPrimary.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ThemeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .tint(Theme.brandPrimary)
    }
}

extension View {
    func themed() -> some View { modifier(ThemeModifier()) }
}
