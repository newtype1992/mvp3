import Foundation

extension Decimal {
    func currencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self as NSDecimalNumber) ?? "$0"
    }
}
