import SwiftUI

struct SlotCard: View {
    let slot: Slot
    let business: Business
    let category: Category
    var onWatch: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [category.color.color.opacity(0.75), Theme.brandPrimary.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 160)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 42))
                            .foregroundColor(.white.opacity(0.35))
                            .padding()
                    }
                VStack(alignment: .leading, spacing: 10) {
                    DiscountBadge(text: slot.discountTier.badgeText)
                    Spacer()
                    Text(slot.title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text(business.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding()
            }

            HStack {
                TimeRemainingChip(timeText: slot.startDate.relativeCountdownText())
                Spacer()
                if let onWatch {
                    Button(action: onWatch) {
                        Label("Watch", systemImage: "bell")
                            .font(.footnote.bold())
                    }
                    .buttonStyle(.borderless)
                    .tint(Theme.brandPrimary)
                }
            }

            HStack(alignment: .firstTextBaseline) {
                Text(slot.discountedPrice.currencyString())
                    .font(.title3.bold())
                Text(slot.originalPrice.currencyString())
                    .font(.footnote)
                    .strikethrough()
                    .foregroundColor(.secondary)
                Spacer()
                RatingStars(rating: business.rating, reviewCount: business.reviewCount)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 12)
        .accessibilityElement(children: .combine)
    }
}
