import Foundation
import Combine
import CoreLocation

protocol SlotService {
    func fetchSlots(around coordinate: CLLocationCoordinate2D?, categories: [Category], businesses: [Business]) async -> [Slot]
    func generateNewCancellation(for businesses: [Business], categories: [Category]) -> Slot
}

final class MockSlotService: SlotService {
    private var seed: UInt64
    private let calendar = Calendar.current

    init(seed: UInt64 = 7) {
        self.seed = seed
    }

    func fetchSlots(around coordinate: CLLocationCoordinate2D?, categories: [Category], businesses: [Business]) async -> [Slot] {
        await Task.sleep(milliseconds: 350)
        return generateSlots(businesses: businesses, categories: categories)
    }

    func generateNewCancellation(for businesses: [Business], categories: [Category]) -> Slot {
        generateSlots(businesses: businesses, categories: categories, count: 1).first!
    }

    private func generateSlots(businesses: [Business], categories: [Category], count: Int = 24) -> [Slot] {
        (0..<count).compactMap { index in
            guard let business = businesses.randomElement(using: &seededGenerator),
                  let categoryID = business.categories.randomElement()
            else { return nil }

            let baseStart = Date().addingTimeInterval(Double.random(in: 5...300, using: &seededGenerator) * 60)
            let duration = Double.random(in: 45...90, using: &seededGenerator) * 60
            let tier = determineTier(for: baseStart)
            let title = Self.slotTitles[index % Self.slotTitles.count]
            let description = "Secure a last-minute \(title.lowercased()) with \(business.name). Premium providers, verified results, and exclusive Swift Slots savings."
            let originalPrice = Decimal(Double.random(in: 55...220, using: &seededGenerator))
            let maxSeats = Int.random(in: 1...6, using: &seededGenerator)
            let seatsRemaining = max(1, Int.random(in: 1...maxSeats, using: &seededGenerator))
            return Slot(
                businessID: business.id,
                categoryID: categoryID,
                title: title,
                description: description,
                startDate: baseStart,
                endDate: baseStart.addingTimeInterval(duration),
                originalPrice: originalPrice,
                seatsRemaining: seatsRemaining,
                maxSeats: maxSeats,
                isNew: Bool.random(using: &seededGenerator),
                createdDate: Date().addingTimeInterval(-Double.random(in: 5...180, using: &seededGenerator) * 60),
                discountTier: tier
            )
        }
    }

    private func determineTier(for startDate: Date) -> Slot.DiscountTier {
        let delta = startDate.timeIntervalSince(Date())
        if delta <= Slot.DiscountTier.flash.timeWindow {
            return .flash
        } else if delta <= Slot.DiscountTier.hot.timeWindow {
            return .hot
        } else {
            return .quick
        }
    }

    private var seededGenerator: SeededRandomNumberGenerator {
        get { SeededRandomNumberGenerator(seed: &seed) }
        set { seed = newValue.seed }
    }

    private static let slotTitles = [
        "Power Hour Reset",
        "Peak Performance Tune-Up",
        "Glow Facial Rescue",
        "Velocity Spin Sprint",
        "Mindful Heat Flow",
        "Combat Conditioning",
        "Rapid Recovery Physio",
        "Precision Fade Refresh",
        "Elite Strength Session",
        "Cryo Reboot"
    ]
}

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    var seed: UInt64

    init(seed: inout UInt64) {
        if seed == 0 { seed = 1 }
        self.seed = seed
    }

    mutating func next() -> UInt64 {
        seed = 2862933555777941757 &* seed &+ 3037000493
        return seed
    }
}
