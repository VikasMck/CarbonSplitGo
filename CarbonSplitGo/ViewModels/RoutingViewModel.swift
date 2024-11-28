import CoreLocation

class RoutingViewModel: ObservableObject {
    
    //convert addresses into coordinates which can later be used for routing
    func getCoordinatesFromAddress(for userAddress: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let clGeocoder = CLGeocoder()
        clGeocoder.geocodeAddressString(userAddress) { (placemarks, _) in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                completion(nil) 
            }
        }
    }

}
