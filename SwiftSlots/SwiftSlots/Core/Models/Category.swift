import Foundation
import SwiftUI

struct Category: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let symbolName: String
    let color: ColorCodable

    init(id: UUID = UUID(), name: String, symbolName: String, color: Color) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
        self.color = ColorCodable(color: color)
    }
}

struct ColorCodable: Codable, Hashable {
    private enum CodingKeys: String, CodingKey { case red, green, blue, alpha }
    let color: Color

    init(color: Color) {
        self.color = color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let alpha = try container.decode(Double.self, forKey: .alpha)
        self.color = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode(Double(red), forKey: .red)
        try container.encode(Double(green), forKey: .green)
        try container.encode(Double(blue), forKey: .blue)
        try container.encode(Double(alpha), forKey: .alpha)
    }
}
