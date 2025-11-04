import SwiftUI
import MapKit

struct RootView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        Group {
            switch store.route {
            case .onboarding:
                OnboardingView()
            case .permissions:
                PermissionsView()
            case .main:
                MainShellView()
            }
        }
        .animation(.easeInOut, value: store.route)
    }
}

struct MainShellView: View {
    @EnvironmentObject private var store: AppStore
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                FeedView()
            }
            .tabItem { Label("Discover", systemImage: "sparkles") }
            .tag(0)

            NavigationStack {
                MapExplorerView()
            }
            .tabItem { Label("Map", systemImage: "map") }
            .tag(1)

            NavigationStack {
                FavoritesView()
            }
            .tabItem { Label("Watchlist", systemImage: "heart") }
            .tag(2)

            NavigationStack {
                ProfileSettingsView()
            }
            .tabItem { Label("Profile", systemImage: "person.crop.circle") }
            .tag(3)
        }
        .sheet(item: $store.presentedSlot) { slot in
            SlotDetailView(slot: slot)
        }
        .sheet(isPresented: $store.isShowingCheckout) {
            CheckoutView()
        }
        .sheet(isPresented: $store.isShowingDebugPanel) {
            DebugPanelView()
        }
    }
}
