import Foundation

protocol PayHandling {
    func startCheckout(for slot: Slot) async throws
}

enum PayServiceError: Error {
    case failed
}

final class MockPayService: PayHandling {
    func startCheckout(for slot: Slot) async throws {
        try await Task.sleep(nanoseconds: 700_000_000)
    }
}
