import SwiftUI
import MapKit

struct RouteView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @StateObject var userLocationViewModel = UserLocationViewModel()
    @StateObject var routingViewModel = RoutingViewModel()
    @State private var userCoordinates: [CLLocationCoordinate2D?] = [nil, nil, nil]
    @State private var route: MKRoute?

    var body: some View {
        VStack {
            CustomMapView(mkRoute: $route, clCoordinates: $userCoordinates)
            
            ForEach(0..<3, id: \.self) { index in
                if let coordinate = userCoordinates[index] {
                    Text("Coordinates \(index + 1): \(coordinate.latitude), \(coordinate.longitude)")
                }
            }
        }
        .onAppear {
            fetchCoordinates()
        }
    }
    
    //fetch coordinates them asynchronously
    private func fetchCoordinates() {
        let locationsSaved = [
            suggestionsViewModel.startingLocationSaved,
            suggestionsViewModel.middleLocationSaved,
            suggestionsViewModel.endLocationSaved
        ]
        for (index, location) in locationsSaved.enumerated() {
            routingViewModel.getCoordinatesFromAddress(for: location) { coordinate in
                self.userCoordinates[index] = coordinate
                
                guard let coordinate = coordinate else {
                    print("error for this coordinate: \(index)")
                    return
                }
                updateRoutes()
                //save them into db
                Task {
                    do {
                        try await LocationQueries.insertCoordinateToDB(
                            longitude: coordinate.longitude,
                            latitude: coordinate.latitude
                        )
                        print("coordinate \(index) saved successfully.")
                    } catch {
                        print("error for coordinate \(index): \(error)")
                    }
                }
            }
        }
    }

    private func updateRoutes() {
        //due to MKDirections limitation and not having a middle destination, I am able to compensate for it via segments.
        func calculateRouteSegment(from index: Int) {
            guard index < userCoordinates.count - 1 else { return }
            guard let start = userCoordinates[index], let end = userCoordinates[index + 1] else { return }
            
            calculateRoute(from: start, to: end) { route in
                if let route = route {
                    self.route = route
                    calculateRouteSegment(from: index + 1)
                }
            }
        }
        calculateRouteSegment(from: 0)
    }

    //calculating the route with MKDirections
    private func calculateRoute(from routeStart: CLLocationCoordinate2D, to routeEnd: CLLocationCoordinate2D, mkCompletion: @escaping (MKRoute?) -> Void) {
        let mkRequest = MKDirections.Request()
        mkRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: routeStart))
        mkRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: routeEnd))
        
        MKDirections(request: mkRequest).calculate { mkResponse, error in
            mkCompletion(mkResponse?.routes.first)
        }
    }
}

#Preview{
    RouteView()
        .environmentObject(SuggestionsViewModel())
}
