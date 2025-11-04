import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        Form {
            Section("Preferences") {
                Toggle(isOn: Binding(
                    get: { store.settings.userPreferences.receivesNotifications },
                    set: { store.settings.userPreferences.receivesNotifications = $0 }
                )) {
                    Label("Push Notifications", systemImage: "bell.fill")
                }

                Toggle(isOn: Binding(
                    get: { store.settings.demoMode },
                    set: { _ in store.toggleDemoMode() }
                )) {
                    Label("Demo Mode", systemImage: "wand.and.stars")
                }
            }

            Section("Favorite Categories") {
                ForEach(store.categories) { category in
                    let isFavorite = store.settings.userPreferences.favoriteCategories.contains(category.id)
                    Button {
                        if isFavorite {
                            store.settings.userPreferences.favoriteCategories.remove(category.id)
                        } else {
                            store.settings.userPreferences.favoriteCategories.insert(category.id)
                        }
                    } label: {
                        HStack {
                            Label(category.name, systemImage: category.symbolName)
                            Spacer()
                            if isFavorite { Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.brandPrimary) }
                        }
                    }
                }
            }

            Section("Payment & Legal") {
                Label("Apple Pay", systemImage: "creditcard")
                Link("Privacy Policy", destination: URL(string: "https://swiftslots.app/privacy")!)
                Link("Terms of Service", destination: URL(string: "https://swiftslots.app/terms")!)
            }

            Section("Support") {
                Button("Contact Concierge") {}
                Button("Share Feedback") {}
            }
        }
        .navigationTitle("Profile")
    }
}
