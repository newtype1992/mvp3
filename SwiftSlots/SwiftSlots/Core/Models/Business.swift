import Foundation
import CoreLocation

struct Business: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let rating: Double
    let reviewCount: Int
    let address: String
    let coordinate: CLLocationCoordinate2D
    let phoneNumber: String
    let website: URL?
    let photos: [String]
    let categories: [UUID]

    init(id: UUID = UUID(), name: String, description: String, rating: Double, reviewCount: Int, address: String, coordinate: CLLocationCoordinate2D, phoneNumber: String, website: URL?, photos: [String], categories: [UUID]) {
        self.id = id
        self.name = name
        self.description = description
        self.rating = rating
        self.reviewCount = reviewCount
        self.address = address
        self.coordinate = coordinate
        self.phoneNumber = phoneNumber
        self.website = website
        self.photos = photos
        self.categories = categories
    }
}

extension CLLocationCoordinate2D: Codable {
    private enum CodingKeys: String, CodingKey { case latitude, longitude }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
