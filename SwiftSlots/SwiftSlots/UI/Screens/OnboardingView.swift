import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var store: AppStore
    @State private var selectedCategories: Set<UUID> = []

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Swift Slots")
                            .font(.largeTitle.bold())
                            .foregroundColor(Theme.brandPrimary)
                            .accessibilityAddTraits(.isHeader)
                        Text(DemoCopy.onboardingHeadline)
                            .font(.title2.bold())
                        Text(DemoCopy.onboardingSubheadline)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("What do you want to pounce on?")
                            .font(.headline)
                        CategoryPills(categories: store.categories, selected: $selectedCategories)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: Binding(
                            get: { store.settings.demoMode },
                            set: { newValue in
                                if newValue {
                                    store.toggleDemoMode()
                                } else {
                                    store.settings.demoMode = false
                                }
                            })) {
                                Label("Demo Mode", systemImage: "wand.and.stars")
                                    .font(.headline)
                                    .foregroundColor(Theme.brandPrimary)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Theme.brandPrimary))
                        Text("Prefill categories and location so you can explore instantly.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }

            PrimaryButton(title: "Continue") {
                store.completeOnboarding(selectedCategories: selectedCategories.isEmpty ? Set(store.categories.map { $0.id }) : selectedCategories)
            }
            .padding()
        }
        .themed()
        .background(Color(.systemGroupedBackground))
        .onAppear {
            if store.settings.demoMode {
                selectedCategories = Set(store.categories.map { $0.id })
            }
        }
    }
}
