import SwiftUI

struct DebugPanelView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Live Tools") {
                    Button("Spawn Cancellation") {
                        store.simulateCancellation()
                    }
                    Button("Simulate Push Notification") {
                        store.simulateNotification()
                    }
                    Toggle("Offline Mode", isOn: $store.isOffline)
                }

                Section("App State") {
                    LabeledContent("Slots Loaded", value: "\(store.feedState.slots.count)")
                    LabeledContent("Favorites", value: "\(store.favoritesState.favoriteBusinesses.count)")
                    LabeledContent("Watched", value: "\(store.favoritesState.watchedSlots.count)")
                    Toggle("Dark Mode", isOn: Binding(
                        get: { store.settings.preferredColorScheme == .dark },
                        set: { store.settings.preferredColorScheme = $0 ? .dark : nil }
                    ))
                }
            }
            .navigationTitle("Debug Toolkit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
