import CoreLocation

class LocationViewModel: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var locationDelegate: PLocation?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateAuthorisationStatus status: CLAuthorizationStatus) {
        locationDelegate?.locationService(manager, didUpdateAuthorisationStatus: status)
    }
}
