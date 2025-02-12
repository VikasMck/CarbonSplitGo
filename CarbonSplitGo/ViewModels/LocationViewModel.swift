import CoreLocation

class LocationViewModel: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var locationDelegate: Location?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationDelegate?.locationService(manager, didUpdateAuthorisationStatus: status)
        //not sure why I missed this before, this allows for live updates when authorised
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    //not sure how to do this better, likely is, but after each update it calls this and the location is stored in a session variable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
            let coordinateString = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
            
            Session.shared.setUserOriginalLocation(coordinateString)            
    }

    //this was also included in the library, so why not. Easy to set up
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}
