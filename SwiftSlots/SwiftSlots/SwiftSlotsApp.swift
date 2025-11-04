import SwiftUI
import Combine

@main
struct SwiftSlotsApp: App {
    @StateObject private var appStore = AppStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appStore)
                .preferredColorScheme(appStore.settings.preferredColorScheme)
                .environment(\.locale, .init(identifier: "en_US"))
                .task {
                    await appStore.bootstrap()
                }
                .onOpenURL { url in
                    appStore.handleDeepLink(url: url)
                }
        }
        .onChange(of: scenePhase) { _, newValue in
            appStore.handleScenePhaseChange(newValue)
        }
    }
}
