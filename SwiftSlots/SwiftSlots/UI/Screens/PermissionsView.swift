import SwiftUI
import CoreLocation

struct PermissionsView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text("Almost there!")
                    .font(.largeTitle.bold())
                Text("Enable smart matchmaking so we can surface last-minute deals near you and alert you when prices drop.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)

            VStack(alignment: .leading, spacing: 20) {
                PermissionRow(
                    title: "Location",
                    subtitle: "Unlock hyper-local cancellations across Austin.",
                    icon: "location.fill",
                    statusText: store.permissionsState.locationStatus == .authorizedWhenInUse ? "Enabled" : "Tap to allow",
                    isLoading: store.permissionsState.isRequestingLocation
                ) {
                    Task { await store.requestLocationPermission() }
                }

                PermissionRow(
                    title: "Notifications",
                    subtitle: "Get pinged when a watched slot drops in price.",
                    icon: "bell.badge.fill",
                    statusText: store.permissionsState.notificationsAllowed ? "Enabled" : "Tap to allow",
                    isLoading: store.permissionsState.isRequestingNotifications
                ) {
                    Task { await store.requestNotificationPermission() }
                }
            }

            PrimaryButton(title: "Continue to Discover") {
                store.route = .main
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .themed()
    }
}

private struct PermissionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let statusText: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Theme.brandPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if isLoading {
                    ProgressView()
                } else {
                    Text(statusText)
                        .font(.footnote.bold())
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
