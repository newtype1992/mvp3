import SwiftUI

struct BusinessDetailView: View {
    let business: Business
    let slots: [Slot]
    let categoryLookup: (UUID) -> Category?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(business.name)
                    .font(.largeTitle.bold())
                RatingStars(rating: business.rating, reviewCount: business.reviewCount)
                Text(business.description)
                    .font(.body)
                Divider()
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upcoming cancellations")
                        .font(.headline)
                    ForEach(slots) { slot in
                        if let category = categoryLookup(slot.categoryID) {
                            SlotCard(slot: slot, business: business, category: category)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
