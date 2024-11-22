import CoreLocation


protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationService, didUpdateAuthorizationStatus status: CLAuthorizationStatus)
    func locationManager(_ manager: LocationService, didFailWithError error: Error)
}
