import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var isShowingUserLocation = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension MapViewModel: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateAuthorizationStatus status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            isShowingUserLocation = true
        }
    }
    
    func locationManager(_ manager: LocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
