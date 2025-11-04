import SwiftUI

struct TimeRemainingChip: View {
    let timeText: String

    var body: some View {
        Label(timeText, systemImage: "clock.fill")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
            .foregroundColor(.primary)
            .accessibilityLabel(Text("Starts in \(timeText)"))
    }
}
