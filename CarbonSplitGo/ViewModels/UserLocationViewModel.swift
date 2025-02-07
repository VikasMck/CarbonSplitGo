import SwiftUI
import MapKit

class UserLocationViewModel: ObservableObject {
    @Published var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var isUserLocationOn = false
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationViewModel: LocationViewModel
    
    init(locationService: LocationViewModel = LocationViewModel()) {
        self.locationViewModel = locationService
        self.locationViewModel.locationDelegate = self
    }
    
    func requestLocation() {
        locationViewModel.requestLocation()
        DispatchQueue.main.async {
            NSLog("Location manager requested at \(Date())")
        }
    }
}
//callback for updated location permissions
extension UserLocationViewModel: Location {
    func locationService(_ manager: CLLocationManager, didUpdateAuthorisationStatus status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorisationStatus = status
            self.isUserLocationOn = (status == .authorizedWhenInUse || status == .authorizedAlways)
        }
    }
}
