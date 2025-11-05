import SwiftUI

struct DiscountBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption).bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.red.opacity(0.9))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .accessibilityLabel(Text("Discount \(text)"))
    }
}
