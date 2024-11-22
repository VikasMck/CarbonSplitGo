import SwiftUI
import MapKit

class MainPageViewModel: ObservableObject {
    @Published var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var isUserLocationOn = false
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationService: LocationService
    
    init(locationService: LocationService = LocationService()) {
        self.locationService = locationService
        self.locationService.locationDelegate = self
    }
    
    func requestLocation() {
        locationService.requestLocation()
        DispatchQueue.main.async {
            NSLog("Location manager requested at \(Date())")
        }
    }
}
//callback for updated location permissions
extension MainPageViewModel: PLocation {
    func locationService(_ manager: CLLocationManager, didUpdateAuthorisationStatus status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorisationStatus = status
            self.isUserLocationOn = (status == .authorizedWhenInUse || status == .authorizedAlways)
        }
    }
}
