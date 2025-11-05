import SwiftUI

struct SlotDetailView: View {
    @EnvironmentObject private var store: AppStore
    let slot: Slot

    var business: Business? {
        store.businesses.first { $0.id == slot.businessID }
    }

    var category: Category? {
        store.categories.first { $0.id == slot.categoryID }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    detailsSection
                    pricingSection
                    actionButtons
                    policiesSection
                }
                .padding()
            }
            .navigationTitle(business?.name ?? "Slot Detail")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        store.toggleWatch(slot: slot)
                    } label: {
                        Label("Watch", systemImage: "bell")
                    }
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let category {
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(Theme.brandPrimary)
            }
            Text(slot.title)
                .font(.title.bold())
            HStack(spacing: 12) {
                DiscountBadge(text: slot.discountTier.badgeText)
                TimeRemainingChip(timeText: slot.startDate.relativeCountdownText())
            }
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let business {
                RatingStars(rating: business.rating, reviewCount: business.reviewCount)
                Text(business.description)
                    .font(.body)
            }
            HStack(alignment: .top) {
                Label(slot.startDate.formattedTimeRange(endDate: slot.endDate), systemImage: "calendar")
                Spacer()
                Label("\(slot.seatsRemaining) of \(slot.maxSeats) spots", systemImage: "person.3.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }

    private var pricingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Rate")
                .font(.headline)
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(slot.discountedPrice.currencyString())
                    .font(.title.bold())
                Text(slot.originalPrice.currencyString())
                    .font(.callout)
                    .strikethrough()
                    .foregroundColor(.secondary)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton(title: "Book Now", icon: "creditcard.fill") {
                store.beginCheckout(for: slot)
            }
            Button {
                if let business { store.toggleFavorite(businessID: business.id) }
            } label: {
                HStack {
                    Image(systemName: "heart")
                    Text("Save business")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(14)
            }
            .buttonStyle(.plain)
        }
    }

    private var policiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cancel Policy")
                .font(.headline)
            Text("Free cancellation up to 2 hours before start. 50% credit issued within 2 hours. No-shows forfeit the promo rate.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}
