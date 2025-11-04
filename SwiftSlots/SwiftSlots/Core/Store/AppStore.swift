import Foundation
import Combine
import SwiftUI
import MapKit
import CoreLocation

@MainActor
final class AppStore: ObservableObject {
    @Published private(set) var categories: [Category] = []
    @Published private(set) var businesses: [Business] = []
    @Published private(set) var feedState = FeedState()
    @Published private(set) var favoritesState = FavoritesState()
    @Published private(set) var checkoutState = CheckoutState()
    @Published private(set) var permissionsState = PermissionsState()
    @Published var settings = SettingsState()
    @Published var route: RootRoute = .onboarding
    @Published var presentedSlot: Slot?
    @Published var isShowingCheckout = false
    @Published var isShowingDebugPanel = false
    @Published var isOffline = false

    let slotService: SlotService
    let locationService: LocationProviding
    let notificationService: NotificationHandling
    let payService: PayHandling

    private var cancellables = Set<AnyCancellable>()

    init(
        slotService: SlotService = MockSlotService(),
        locationService: LocationProviding = MockLocationService(),
        notificationService: NotificationHandling = NotificationService(),
        payService: PayHandling = MockPayService()
    ) {
        self.slotService = slotService
        self.locationService = locationService
        self.notificationService = notificationService
        self.payService = payService

        setupBindings()
    }

    func bootstrap() async {
        guard categories.isEmpty else { return }
        seedData()
        await refreshFeed()
    }

    func handleScenePhaseChange(_ phase: ScenePhase) {
        if phase == .active {
            Task { await refreshFeed() }
        }
    }

    func toggleDemoMode() {
        settings.demoMode.toggle()
        if settings.demoMode {
            settings.selectedCity = "Austin"
            permissionsState.hasAskedForLocation = true
            permissionsState.hasAskedForNotifications = true
            settings.preferredColorScheme = nil
            settings.userPreferences.demoModeEnabled = true
            settings.userPreferences.favoriteCategories = Set(categories.map { $0.id })
            route = .main
        }
    }

    func completeOnboarding(selectedCategories: Set<UUID>) {
        settings.userPreferences.favoriteCategories = selectedCategories
        settings.userPreferences.hasCompletedOnboarding = true
        route = permissionsState.locationStatus == .authorizedWhenInUse ? .main : .permissions
    }

    func requestLocationPermission() async {
        permissionsState.isRequestingLocation = true
        await locationService.requestAccess()
        permissionsState.isRequestingLocation = false
        permissionsState.locationStatus = .authorizedWhenInUse
        settings.userPreferences.hasGrantedLocation = true
        route = permissionsState.notificationsAllowed ? .main : .permissions
    }

    func requestNotificationPermission() async {
        permissionsState.isRequestingNotifications = true
        let granted = await notificationService.requestAuthorization()
        permissionsState.notificationsAllowed = granted
        permissionsState.isRequestingNotifications = false
        settings.userPreferences.receivesNotifications = granted
        route = .main
    }

    func refreshFeed() async {
        guard !isOffline else {
            feedState.isLoading = false
            return
        }
        feedState.isLoading = true
        let slots = await slotService.fetchSlots(
            around: locationService.currentLocation,
            categories: categories,
            businesses: businesses
        )
        feedState.slots = applyFilters(to: slots)
        feedState.lastUpdated = Date()
        feedState.isLoading = false
    }

    func applyFilters(distance: Double? = nil, categories categoryIDs: Set<UUID>? = nil, sort: FeedSortOption? = nil, timeWindow: FeedState.TimeWindow? = nil) {
        if let distance { feedState.filters.distance = distance }
        if let categoryIDs { feedState.filters.categories = categoryIDs }
        if let sort { feedState.sort = sort }
        if let timeWindow { feedState.filters.timeWindow = timeWindow }
        Task { await refreshFeed() }
    }

    func toggleFavorite(businessID: UUID) {
        if favoritesState.favoriteBusinesses.contains(businessID) {
            favoritesState.favoriteBusinesses.remove(businessID)
        } else {
            favoritesState.favoriteBusinesses.insert(businessID)
        }
    }

    func toggleWatch(slot: Slot) {
        if favoritesState.watchedSlots.contains(slot.id) {
            favoritesState.watchedSlots.remove(slot.id)
        } else {
            favoritesState.watchedSlots.insert(slot.id)
            if permissionsState.notificationsAllowed {
                if let business = businesses.first(where: { $0.id == slot.businessID }) {
                    notificationService.scheduleDealAlert(for: slot, business: business)
                }
            }
        }
    }

    func beginCheckout(for slot: Slot) {
        checkoutState.selectedSlot = slot
        checkoutState.isProcessing = false
        checkoutState.errorMessage = nil
        presentedSlot = nil
        isShowingCheckout = true
    }

    func confirmCheckout(customer: CheckoutState.CustomerInfo) async {
        guard let slot = checkoutState.selectedSlot else { return }
        checkoutState.isProcessing = true
        checkoutState.customerInfo = customer
        do {
            try await payService.startCheckout(for: slot)
            checkoutState.isProcessing = false
            checkoutState.isConfirmed = true
            presentedSlot = nil
        } catch {
            checkoutState.isProcessing = false
            checkoutState.errorMessage = "Something went wrong. Please try again."
        }
    }

    func resetCheckout() {
        checkoutState = CheckoutState()
        isShowingCheckout = false
    }

    func simulateCancellation() {
        let slot = slotService.generateNewCancellation(for: businesses, categories: categories)
        feedState.slots.insert(slot, at: 0)
    }

    func simulateNotification() {
        notificationService.simulateNotification()
    }

    func handleDeepLink(url: URL) {
        guard url.scheme == "swiftslots",
              url.host == "slot",
              let slotID = UUID(uuidString: url.lastPathComponent),
              let slot = feedState.slots.first(where: { $0.id == slotID })
        else { return }
        presentedSlot = slot
    }

    private func setupBindings() {
        $route
            .removeDuplicates()
            .sink { [weak self] route in
                if route == .main {
                    self?.locationService.startMonitoring()
                }
            }
            .store(in: &cancellables)
    }

    private func seedData() {
        categories = DemoDataFactory.categories
        businesses = DemoDataFactory.businesses
        feedState.filters.categories = Set(categories.map { $0.id })
    }

    private func applyFilters(to slots: [Slot]) -> [Slot] {
        let window = feedState.filters.timeWindow ?? .all
        return slots
            .filter { slot in
                if feedState.filters.categories.isEmpty { return true }
                return feedState.filters.categories.contains(slot.categoryID)
            }
            .filter { slot in
                switch window {
                case .upToOneHour:
                    return slot.startDate.timeIntervalSinceNow <= Slot.DiscountTier.flash.timeWindow
                case .upToThreeHours:
                    return slot.startDate.timeIntervalSinceNow <= Slot.DiscountTier.hot.timeWindow
                case .upToSixHours:
                    return slot.startDate.timeIntervalSinceNow <= Slot.DiscountTier.quick.timeWindow
                case .all:
                    return true
                }
            }
            .sorted(by: sortingComparator(for: feedState.sort))
    }

    private func sortingComparator(for option: FeedSortOption) -> (Slot, Slot) -> Bool {
        switch option {
        case .soonest:
            return { $0.startDate < $1.startDate }
        case .biggestDiscount:
            return { $0.discountTier.discountPercentage > $1.discountTier.discountPercentage }
        case .highestRated:
            return { lhs, rhs in
                let leftBusiness = businesses.first(where: { $0.id == lhs.businessID })?.rating ?? 0
                let rightBusiness = businesses.first(where: { $0.id == rhs.businessID })?.rating ?? 0
                if leftBusiness == rightBusiness {
                    return lhs.startDate < rhs.startDate
                }
                return leftBusiness > rightBusiness
            }
        }
    }
}

// MARK: - Supporting Types

enum RootRoute {
    case onboarding
    case permissions
    case main
}

struct FeedState {
    struct Filters {
        var distance: Double = 5
        var categories: Set<UUID> = []
        var timeWindow: TimeWindow? = .all
    }

    enum TimeWindow: String, CaseIterable, Identifiable {
        case all = "All"
        case upToSixHours = "Within 6h"
        case upToThreeHours = "Within 3h"
        case upToOneHour = "Within 1h"

        var id: String { rawValue }
    }

    var slots: [Slot] = []
    var filters = Filters()
    var sort: FeedSortOption = .soonest
    var isLoading = false
    var lastUpdated: Date?
}

struct FavoritesState {
    var favoriteBusinesses: Set<UUID> = []
    var watchedSlots: Set<UUID> = []
}

struct CheckoutState {
    struct CustomerInfo {
        var fullName: String = "Avery Swift"
        var email: String = "avery@swiftslots.app"
        var phone: String = "+1 (512) 555-0112"
        var notes: String = ""
    }

    var selectedSlot: Slot?
    var customerInfo = CustomerInfo()
    var isProcessing = false
    var isConfirmed = false
    var errorMessage: String?
}

struct PermissionsState {
    var hasAskedForLocation = false
    var hasAskedForNotifications = false
    var isRequestingLocation = false
    var isRequestingNotifications = false
    var locationStatus: CLAuthorizationStatus = .notDetermined
    var notificationsAllowed = false
}

struct SettingsState {
    var userPreferences = UserPreferences()
    var preferredColorScheme: ColorScheme?
    var selectedCity: String = "Austin"
    var demoMode = false
}
