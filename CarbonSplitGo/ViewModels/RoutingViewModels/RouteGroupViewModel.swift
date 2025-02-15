import Foundation
import CoreLocation
import MapKit

@MainActor
class RouteGroupViewModel: ObservableObject {
    @Published var passengerCoordinates: [(userID: String, groupName: String, routeDay: String, userRole: String, longitude: Double, latitude: Double, userName: String, userEmail: String)] = []
    @Published var errorMessage: String?

    func insertPlannedRoute(groupName: String, longitude: Double, latitude: Double, routeDate: String) async {
        do {
            try await LocationQueries.insertIntoPlannedRouteToDB(
                groupName: groupName,
                longitude: longitude,
                latitude: latitude,
                routeDate: routeDate
            )
        } catch {
            self.errorMessage = "Error when inserting passenger: \(error.localizedDescription)"
        }
    }

    //only need coordinates with this
    func fetchCoordsWithGroupAndRole(groupName: String, userRole: String) async -> [(longitude: Double, latitude: Double)]? {
        do {
            let userCoordinates = try LocationQueries.retrieveUserInfoFromRouteGroupFromDB(
                groupName: groupName,
                userRole: userRole
            )
            
            guard !userCoordinates.isEmpty else {
                self.errorMessage = "Error, coordinates not found for group \(groupName)."
                return nil
            }
            
            self.passengerCoordinates = userCoordinates
            
            return userCoordinates.map { (longitude: $0.longitude, latitude: $0.latitude) }
            
        } catch {
            self.errorMessage = "Error retrieving passenger coordinates: \(error.localizedDescription)"
            return nil
        }
    }
    
    func fetchAndSetLocation(for group: String, userRole: String, newCoordinateForAnnotation: @escaping (CLLocationCoordinate2D) -> Void) async {

        if let userCoordinates = await fetchCoordsWithGroupAndRole(groupName: group, userRole: userRole) {
                for coordinate in userCoordinates {
                    //I know I can retreive this from db, but I chose to split, so now im combining
                    let newCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    newCoordinateForAnnotation(newCoordinate)
                }
            } else {
                print("No coordinates for group \(group)")
            }
        }

    
}
