import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showFilters = false

    var body: some View {
        VStack(spacing: 0) {
            feedHeader
            if store.feedState.slots.isEmpty {
                ScrollView {
                    EmptyState(
                        title: "No last-minute wins",
                        message: "Try widening your filters or peeking at a different category — hot deals move fast in Austin!",
                        actionTitle: "Reset Filters"
                    ) {
                        store.applyFilters(categories: Set(store.categories.map { $0.id }), timeWindow: .all)
                    }
                    .padding(.top, 80)
                }
            } else {
                List {
                    ForEach(store.feedState.slots) { slot in
                        if let business = store.businesses.first(where: { $0.id == slot.businessID }),
                           let category = store.categories.first(where: { $0.id == slot.categoryID }) {
                            Button {
                                store.presentedSlot = slot
                            } label: {
                                SlotCard(slot: slot, business: business, category: category) {
                                    store.toggleWatch(slot: slot)
                                }
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .refreshable {
                    await store.refreshFeed()
                }
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterSheet(isPresented: $showFilters)
        }
        .overlay(alignment: .top) {
            if store.isOffline {
                HStack {
                    Image(systemName: "wifi.exclamationmark")
                    Text("Limited connectivity — showing last known deals")
                        .font(.footnote)
                }
                .padding(10)
                .background(Color.orange.opacity(0.9))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()
                .transition(.move(edge: .top))
            }
        }
        .task { await store.refreshFeed() }
        .navigationTitle("Last-Minute Slots")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showFilters.toggle()
                } label: {
                    Label("Filters", systemImage: "slider.horizontal.3")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.isShowingDebugPanel = true
                } label: {
                    Image(systemName: "ladybug")
                }
            }
        }
    }

    private var feedHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Austin • Within \(Int(store.feedState.filters.distance)) mi")
                .font(.footnote)
                .foregroundColor(.secondary)
            Picker("Sort", selection: Binding(
                get: { store.feedState.sort },
                set: { store.applyFilters(sort: $0) }
            )) {
                ForEach(FeedSortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding([.horizontal, .top])
    }
}

private struct FilterSheet: View {
    @EnvironmentObject private var store: AppStore
    @Binding var isPresented: Bool
    @State private var selectedCategories: Set<UUID> = []
    @State private var selectedWindow: FeedState.TimeWindow = .all
    @State private var distance: Double = 5

    var body: some View {
        NavigationStack {
            Form {
                Section("Distance") {
                    Slider(value: Binding(
                        get: { distance },
                        set: { distance = $0 }
                    ), in: 1...15, step: 1) {
                        Text("Distance")
                    }
                    Text("Within \(Int(distance)) miles")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Section("Categories") {
                    ForEach(store.categories) { category in
                        let isSelected = selectedCategories.contains(category.id)
                        Button {
                            if isSelected {
                                selectedCategories.remove(category.id)
                            } else {
                                selectedCategories.insert(category.id)
                            }
                        } label: {
                            HStack {
                                Label(category.name, systemImage: category.symbolName)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Theme.brandPrimary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("Time Window") {
                    Picker("Window", selection: $selectedWindow) {
                        ForEach(FeedState.TimeWindow.allCases) { window in
                            Text(window.rawValue).tag(window)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        store.applyFilters(distance: distance, categories: selectedCategories, timeWindow: selectedWindow)
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            selectedCategories = store.feedState.filters.categories
            selectedWindow = store.feedState.filters.timeWindow ?? .all
            distance = store.feedState.filters.distance
        }
    }
}
