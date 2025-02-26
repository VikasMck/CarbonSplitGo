import Foundation
import CoreLocation
@preconcurrency import MapKit
import Combine

@MainActor
class RoutingViewModel: ObservableObject {
    @Published var userCoordinates: [CLLocationCoordinate2D?] = []
    @Published var routes: [MKRoute] = []
    @Published var annotations: [MKPointAnnotation] = []
    @Published var selectedRouteDistance: Double? = nil
    @Published var selectedRouteIndex: Int? = 0
    @Published var selectedRouteTravelTime: Double? = nil
    @Published var selectedRouteHasTolls: Bool? = nil
    @Published var selectedRouteCo2Emissions: Double? = nil

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //publisher to init with latest updates
        $routes.combineLatest($selectedRouteIndex).sink { [weak self] (routes, selectedIndex) in
                self?.updateRouteStatistics()
            }
            .store(in: &cancellables)
    }
    
    //for buttons
    func selectMainRoute() {
        selectedRouteIndex = 0
        updateRouteStatistics()
    }
    
    func selectAlternateRoute() {
        if routes.indices.contains(1) {
            selectedRouteIndex = 1
            updateRouteStatistics()
        }
    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotations.append(annotation)
    }
    
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
            }
        }

        await calculateRoutes()
        self.annotations = generateAnnotations()
    }

    //convert addresses into coordinates which can later be used for routing
    func getCoordinatesFromAddress(for userAddress: String) async -> CLLocationCoordinate2D? {
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

        var routeList: [MKRoute] = []
        for i in 0..<(validCoordinates.count - 1) {
            if let mainRouteOption = await routeOverlayOnMap(from: validCoordinates[i], to: validCoordinates[i + 1], alternate: false),
               let secondaryRouteOption = await routeOverlayOnMap(from: validCoordinates[i], to: validCoordinates[i + 1], alternate: true) {
                routeList.append(mainRouteOption)
                routeList.append(secondaryRouteOption)
            }
        }
        self.routes = routeList
        
        updateRouteStatistics()
    }
    
    func updateRouteStatistics() {
        var totalDistance: Double = 0
        var totalTravelTime: Double = 0

        guard let selectedIndex = selectedRouteIndex, !routes.isEmpty else {
            selectedRouteDistance = nil
            selectedRouteTravelTime = nil
            selectedRouteHasTolls = nil
            selectedRouteCo2Emissions = nil
            return
        }
        
        for (index, route) in routes.enumerated() {
            //even or odd indices for routes, and convert m to km and s to min
            if index % 2 == selectedIndex {
                totalDistance += route.distance / 1000
                totalTravelTime += route.expectedTravelTime / 60
                
                if route.hasTolls {
                    selectedRouteHasTolls = true
                    break
                }
                else {
                    selectedRouteHasTolls = false
                }
            }
        }
        
        selectedRouteDistance = totalDistance
        selectedRouteTravelTime = totalTravelTime
        
        //https://www.acea.auto/figure/average-co2-emissions-from-new-passenger-cars-by-eu-country/
        //in ireland co2 per km is 110.7g co2/km, converted from g to kg
        let co2KgPerKm: Double = 110.7 / 1000
        selectedRouteCo2Emissions = totalDistance * co2KgPerKm
    }

    //add an overlay of the route to the map
    private func routeOverlayOnMap(from routeStart: CLLocationCoordinate2D, to routeEnd: CLLocationCoordinate2D, alternate: Bool) async -> MKRoute? {
        let mkRequest = MKDirections.Request()
        mkRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: routeStart))
        mkRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: routeEnd))
        mkRequest.transportType = .automobile //think that was default, but adding this anyway

        if alternate {
            mkRequest.requestsAlternateRoutes = true
        }

        do {
            let response = try await MKDirections(request: mkRequest).calculate()
            return alternate ? response.routes.last : response.routes.first
        } catch {
            print("Error when getting a route: \(error)")
            return nil
        }
    }

    private func generateAnnotations() -> [MKPointAnnotation] {
        let fetchedUserCoordinates = userCoordinates.compactMap { $0 }
        var pointAnnotations: [MKPointAnnotation] = []
        
        for coordinate in fetchedUserCoordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            pointAnnotations.append(annotation)
        }
        
        return pointAnnotations
    }
}
