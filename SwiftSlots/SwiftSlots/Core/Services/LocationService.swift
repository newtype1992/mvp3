import Foundation
import Combine
import CoreLocation

protocol LocationProviding {
    var currentLocation: CLLocationCoordinate2D? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestAccess() async
    func startMonitoring()
}

final class MockLocationService: NSObject, LocationProviding, CLLocationManagerDelegate, ObservableObject {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var currentLocation: CLLocationCoordinate2D?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestAccess() async {
        await MainActor.run {
            authorizationStatus = .authorizedWhenInUse
            currentLocation = CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431)
        }
    }

    func startMonitoring() {
        currentLocation = CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
