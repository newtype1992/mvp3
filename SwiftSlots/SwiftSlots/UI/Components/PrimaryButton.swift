import SwiftUI

struct PrimaryButton: View {
    var title: String
    var icon: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon { Image(systemName: icon).font(.headline) }
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .background(Theme.brandPrimary)
            .cornerRadius(14)
            .shadow(color: Theme.brandPrimary.opacity(0.3), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(title))
    }
}
