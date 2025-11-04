import SwiftUI

struct RatingStars: View {
    let rating: Double
    let reviewCount: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                Image(systemName: index < Int(rating.rounded(.toNearestOrAwayFromZero)) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            Text(String(format: "%.1f", rating))
                .font(.footnote.bold())
            Text("(\(reviewCount))")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Rated \(rating, specifier: "%.1f") out of 5 from \(reviewCount) reviews"))
    }
}
