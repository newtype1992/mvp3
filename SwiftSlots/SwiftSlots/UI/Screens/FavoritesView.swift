import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            if store.favoritesState.favoriteBusinesses.isEmpty {
                Section {
                    EmptyState(title: "No favorites yet", message: "Save your go-to studios and clinics to fill their cancellations in seconds.")
                        .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.clear)
            } else {
                Section("Saved Businesses") {
                    ForEach(store.businesses.filter { store.favoritesState.favoriteBusinesses.contains($0.id) }) { business in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(business.name)
                                .font(.headline)
                            Text(business.description)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }

            if !store.favoritesState.watchedSlots.isEmpty {
                Section("Watching") {
                    ForEach(store.feedState.slots.filter { store.favoritesState.watchedSlots.contains($0.id) }) { slot in
                        if let business = store.businesses.first(where: { $0.id == slot.businessID }) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(slot.title)
                                    .font(.headline)
                                Text("at \(business.name)")
                                    .font(.subheadline)
                                Text("Starts in \(slot.startDate.relativeCountdownText())")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Saved & Watchlist")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Simulate Push") { store.simulateNotification() }
            }
        }
    }
}
