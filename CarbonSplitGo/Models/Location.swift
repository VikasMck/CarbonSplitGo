import CoreLocation

protocol Location: AnyObject {
    func locationService(_ manager: CLLocationManager, didUpdateAuthorisationStatus status: CLAuthorizationStatus)
}
