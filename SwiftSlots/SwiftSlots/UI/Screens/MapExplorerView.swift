import SwiftUI
import MapKit

struct MapExplorerView: View {
    @EnvironmentObject private var store: AppStore
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(position: Binding(
            get: { .region(region) },
            set: { newValue in
                if case .region(let newRegion) = newValue { region = newRegion }
            }
        )) {
            ForEach(store.businesses) { business in
                Annotation(business.name, coordinate: business.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(Theme.brandPrimary)
                        Text(String(format: "%.1f★", business.rating))
                            .font(.caption2)
                            .padding(4)
                            .background(Color(.systemBackground))
                            .cornerRadius(6)
                    }
                    .onTapGesture {
                        if let slot = store.feedState.slots.first(where: { $0.businessID == business.id }) {
                            store.presentedSlot = slot
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("\(business.name) rated \(business.rating, specifier: "%.1f") stars"))
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .top) {
            VStack(spacing: 8) {
                Text("Tap a pin to preview an open slot.")
                    .padding(10)
                    .background(.ultraThinMaterial, in: Capsule())
                Spacer().frame(height: 0)
            }
            .padding()
        }
        .navigationTitle("Map Explorer")
    }
}
