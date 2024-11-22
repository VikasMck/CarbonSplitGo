import CoreLocation

protocol PLocation: AnyObject {
    func locationService(_ manager: CLLocationManager, didUpdateAuthorisationStatus status: CLAuthorizationStatus)
}
