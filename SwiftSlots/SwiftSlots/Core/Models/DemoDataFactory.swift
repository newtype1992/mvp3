import Foundation
import SwiftUI
import CoreLocation

enum DemoDataFactory {
    static let categories: [Category] = [
        Category(name: "HIIT & Bootcamp", symbolName: "bolt.fill", color: Color(hex: "#FF6B6B")),
        Category(name: "Spin Cycling", symbolName: "bicycle", color: Color(hex: "#6BCB77")),
        Category(name: "Hot Yoga", symbolName: "flame.fill", color: Color(hex: "#FFD93D")),
        Category(name: "Boxing & Muay Thai", symbolName: "figure.boxing", color: Color(hex: "#4D96FF")),
        Category(name: "Haircut & Styling", symbolName: "scissors", color: Color(hex: "#C4A7E7")),
        Category(name: "Blowout Bar", symbolName: "wind", color: Color(hex: "#FFB5A7")),
        Category(name: "Massage Therapy", symbolName: "hands.sparkles.fill", color: Color(hex: "#3AA6B9")),
        Category(name: "Facial & Skincare", symbolName: "sparkles", color: Color(hex: "#FF9F1C")),
        Category(name: "Dental Cleaning", symbolName: "mouth.fill", color: Color(hex: "#9BF6FF")),
        Category(name: "Sports Physio", symbolName: "figure.run", color: Color(hex: "#8338EC")),
        Category(name: "Cryotherapy Lounge", symbolName: "snowflake", color: Color(hex: "#48CAE4"))
    ]

    static var businesses: [Business] {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 30.26694, longitude: -97.74278),
            CLLocationCoordinate2D(latitude: 30.2700, longitude: -97.7500),
            CLLocationCoordinate2D(latitude: 30.2630, longitude: -97.7350),
            CLLocationCoordinate2D(latitude: 30.2740, longitude: -97.7390),
            CLLocationCoordinate2D(latitude: 30.2675, longitude: -97.7490),
            CLLocationCoordinate2D(latitude: 30.2620, longitude: -97.7430)
        ]

        let names = [
            "Pulse Society Austin",
            "Torque Lab Spin Studio",
            "NovaGlow Wellness Club",
            "Forge Muay Thai Loft",
            "Downtown Fade Factory",
            "Lumen Recovery Spa"
        ]

        return names.enumerated().map { index, name in
            let description = DemoCopy.businessDescriptions[index % DemoCopy.businessDescriptions.count]
            let rating = 4.5 + Double(index) * 0.1
            let reviewCount = 120 + index * 24
            let photos = ["placeholder-\(index+1)"]
            let categoryIDs = Array(categories.map { $0.id }).shuffled().prefix(3)
            return Business(
                name: name,
                description: description,
                rating: min(4.9, rating),
                reviewCount: reviewCount,
                address: "\(Int.random(in: 200...700)) Congress Ave, Austin, TX",
                coordinate: coordinates[index % coordinates.count],
                phoneNumber: "+1 (512) 555-0\(110 + index)",
                website: URL(string: "https://swiftslots.app/demo/\(index)"),
                photos: photos,
                categories: Array(categoryIDs)
            )
        }
    }
}

enum DemoCopy {
    static let businessDescriptions = [
        "Austin's go-to studio for high-intensity intervals with pro coaches and concert-level lighting.",
        "Signature rhythm rides with live DJs, power tracking, and cold eucalyptus towels on exit.",
        "Infrared saunas, guided breathwork, and curated botanicals for a complete glow reboot.",
        "World-class striking coaches with conditioning circuits built for serious fighters and first-timers alike.",
        "Award-winning grooming collective specializing in modern fades, beard styling, and scalp care rituals.",
        "Next-gen recovery hub with contrast therapy, compression boots, and whole-body cryo chambers."
    ]

    static let onboardingHeadline = "Instantly fill your downtime with discounted greatness."
    static let onboardingSubheadline = "Snag last-minute gym, beauty, and wellness cancellations around Austin at up to 50% off."
}
