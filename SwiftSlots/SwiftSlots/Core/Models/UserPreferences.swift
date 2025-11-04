import Foundation
import SwiftUI

struct UserPreferences: Codable {
    var favoriteCategories: Set<UUID>
    var receivesNotifications: Bool
    var preferredDistance: Double
    var preferredSort: FeedSortOption
    var hasCompletedOnboarding: Bool
    var hasGrantedLocation: Bool
    var demoModeEnabled: Bool

    init(favoriteCategories: Set<UUID> = [], receivesNotifications: Bool = false, preferredDistance: Double = 5, preferredSort: FeedSortOption = .soonest, hasCompletedOnboarding: Bool = false, hasGrantedLocation: Bool = false, demoModeEnabled: Bool = false) {
        self.favoriteCategories = favoriteCategories
        self.receivesNotifications = receivesNotifications
        self.preferredDistance = preferredDistance
        self.preferredSort = preferredSort
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.hasGrantedLocation = hasGrantedLocation
        self.demoModeEnabled = demoModeEnabled
    }
}

enum FeedSortOption: String, CaseIterable, Codable, Identifiable {
    case soonest = "Soonest"
    case biggestDiscount = "Biggest Discount"
    case highestRated = "Top Rated"

    var id: String { rawValue }
}
