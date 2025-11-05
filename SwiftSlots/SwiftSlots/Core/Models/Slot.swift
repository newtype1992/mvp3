import Foundation
import CoreLocation

struct Slot: Identifiable, Codable, Hashable {
    enum DiscountTier: String, CaseIterable, Codable {
        case flash = "Flash 50%"
        case hot = "Hot 35%"
        case quick = "Quick 20%"

        var discountPercentage: Double {
            switch self {
            case .flash: return 0.5
            case .hot: return 0.35
            case .quick: return 0.2
            }
        }

        var timeWindow: TimeInterval {
            switch self {
            case .flash: return 60 * 60
            case .hot: return 3 * 60 * 60
            case .quick: return 6 * 60 * 60
            }
        }

        var badgeText: String {
            "\(Int(discountPercentage * 100))% OFF"
        }
    }

    let id: UUID
    let businessID: UUID
    let categoryID: UUID
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    let originalPrice: Decimal
    let seatsRemaining: Int
    let maxSeats: Int
    let isNew: Bool
    let createdDate: Date

    var discountTier: DiscountTier

    var discountedPrice: Decimal {
        originalPrice * (1 - Decimal(discountTier.discountPercentage))
    }

    var isSoldOut: Bool {
        seatsRemaining <= 0
    }

    var timeUntilStart: TimeInterval {
        startDate.timeIntervalSince(Date())
    }
}
