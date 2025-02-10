import Foundation
import CoreLocation
@preconcurrency import MapKit

//major rework
class RoutingViewModel: ObservableObject {
    @Published var userCoordinates: [CLLocationCoordinate2D?] = []
    @Published var routes: [MKRoute] = []
    
    //fetch coordinates them asynchronously, major changes as I didn't know I was hardcoding location thus, limiting myself with the amount of locations
    func fetchCoordinates(from locations: [String]) async {
            self.userCoordinates = Array(repeating: nil, count: locations.count) //to work with more location, need to init it with how many locations to expect
        

        await withTaskGroup(of: (Int, CLLocationCoordinate2D?).self) { group in //actually make it async now
            for (index, location) in locations.enumerated() {
                group.addTask { //add each location to the group task
                    let coordinate = await self.getCoordinatesFromAddress(for: location)
                    return (index, coordinate)
                }
            }

            for await (index, coordinate) in group {
                    self.userCoordinates[index] = coordinate
                
                //check if nil
                guard let coordinate = coordinate else {
                    DispatchQueue.main.async {
                        print("the value of the coord was null at: \(index)")
                    }
                    continue
                }
                do {
                    try await LocationQueries.insertCoordinateToDB(longitude: coordinate.longitude, latitude: coordinate.latitude)
                    print("Coordinate \(index) was saved in the database.")
                } catch {
                    print("error at index: \(index): \(error)")
                }
            }
        }

        await calculateRoutes()
    }

    //convert addresses into coordinates which can later be used for routing
    private func getCoordinatesFromAddress(for userAddress: String) async -> CLLocationCoordinate2D? {
        return await withCheckedContinuation { continuation in
            let clGeocoder = CLGeocoder()
            clGeocoder.geocodeAddressString(userAddress) { placemarks, _ in
                if let placemark = placemarks?.first, let location = placemark.location {
                    continuation.resume(returning: location.coordinate)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    private func calculateRoutes() async {
        let validCoordinates = userCoordinates.compactMap { $0 }
        guard validCoordinates.count > 1 else { return }

        var newRoutes: [MKRoute] = []
        for i in 0..<(validCoordinates.count - 1) {
            if let route = await routeOverlayOnMap(from: validCoordinates[i], to: validCoordinates[i + 1]) {
                newRoutes.append(route)
            }
        }
            self.routes = newRoutes
    }

    //add an overlay of the route to the map
    private func routeOverlayOnMap(from routeStart: CLLocationCoordinate2D, to routeEnd: CLLocationCoordinate2D) async -> MKRoute? {
        let mkRequest = MKDirections.Request()
        mkRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: routeStart))
        mkRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: routeEnd))
        mkRequest.transportType = .automobile //think that was default, but adding this anyway

        do {
            let response = try await MKDirections(request: mkRequest).calculate()
            return response.routes.first
        } catch {
            print("Failed to get route: \(error)")
            return nil
        }
    }
}
