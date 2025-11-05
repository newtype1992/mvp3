import SwiftUI

struct ConfirmationView: View {
    let slot: Slot
    let business: Business

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 56))
                .foregroundColor(.green)
            Text("Booked!")
                .font(.title.bold())
            Text("You're locked in for \(slot.title) at \(business.name).").multilineTextAlignment(.center)
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Reservation Code")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(slot.id.uuidString.prefix(8).uppercased())
                        .font(.title2.monospacedDigit())
                }
                Spacer()
                Button {
                    // add to calendar placeholder
                } label: {
                    Label("Add to Calendar", systemImage: "calendar.badge.plus")
                }
            }
            HStack {
                PrimaryButton(title: "Get Directions", icon: "map") {}
                PrimaryButton(title: "Share", icon: "square.and.arrow.up") {}
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        .accessibilityElement(children: .combine)
    }
}
