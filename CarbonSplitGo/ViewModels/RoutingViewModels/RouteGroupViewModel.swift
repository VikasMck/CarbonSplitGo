import Foundation
import CoreLocation
import MapKit

@MainActor
class RouteGroupViewModel: ObservableObject {
    @Published var passengerCoordinates: [(longitude: Double, latitude: Double)] = []
    @Published var userDetails: [(userId: Int, groupName: String, routeDay: String, userName: String, feedbackRating: Double, feedbackRatingCount: Int)] = []
    @Published var annotationPopupInfo: [(groupName: String, routeDay: String, userName: String, isVerified: Bool, userPhoneNumber: String, feedbackRating: Double, feedbackRatingCount: Int, userId: Int)] = []
    
    @Published var errorMessage: String?

    func insertPlannedRoute(groupName: String, longitude: Double, latitude: Double, routeDate: String, whichDriverInvited: Int) async {
        do {
            try await LocationQueries.insertIntoPlannedRouteToDB(
                groupName: groupName,
                longitude: longitude,
                latitude: latitude,
                routeDate: routeDate,
                whichDriverInvited: whichDriverInvited
            )
        } catch {
            self.errorMessage = "Error when inserting passenger: \(error.localizedDescription)"
        }
    }

    //only need coordinates with this
    func fetchCoordsWithGroupAndRole(groupName: String, userRole: String, routeDay: String) async -> [(longitude: Double, latitude: Double)]? {
        do {
            let userCoordinates = try LocationQueries.retrieveUserCoordsFromRouteGroupFromDB(
                groupName: groupName,
                userRole: userRole,
                routeDay: routeDay
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
    
    func fetchUserInfoFromRouteGroup(groupName: String, userRole: String, routeDay: String, longitude: Double, latitude: Double, maxDistance: Int
    ) async -> [(userId: Int, groupName: String, routeDay: String, userName: String, feedbackRating: Double, feedbackRatingCount: Int)]? {
        do {
            let userInfo = try LocationQueries.retrieveUserInfoFromRouteGroupFromDB(groupName: groupName, userRole: userRole, routeDay: routeDay, longitude: longitude, latitude: latitude, maxDistance: maxDistance)
            
            guard !userInfo.isEmpty else {
                self.errorMessage = "Error, user info not found for group \(groupName)."
                return nil
            }
            
            self.userDetails = userInfo
            
            return userInfo.map { (userId: $0.userId, groupName: $0.groupName, routeDay: $0.routeDay, userName: $0.userName, feedbackRating: $0.feedbackRating, feedbackRatingCount: $0.feedbackRatingCount) }
            
        } catch {
            self.errorMessage = "Error retrieving user info: \(error.localizedDescription)"
            return nil
        }
    }

    
    func fetchAnnotationPopupInfo(longitude: Double, latitude: Double) async -> [(groupName: String, routeDay: String, userName: String, isVerified: Bool, userPhoneNumber: String, feedbackRating: Double, feedbackRatingCount: Int, userId: Int)]? {
        do {
            
            let annotationInfo = try LocationQueries.retreiveAnnotationPopupInfoFromRouteGroupDB(
                longitude: longitude,
                latitude: latitude
            )
            guard !annotationInfo.isEmpty else {
                self.errorMessage = "Error, annotation info found for coordinates (\(longitude), \(latitude))."
                return nil
            }
            
            self.annotationPopupInfo = annotationInfo
            
            return annotationInfo.map { (groupName: $0.groupName, routeDay: $0.routeDay, userName: $0.userName, isVerified: $0.isVerified, userPhoneNumber: $0.userPhoneNumber, feedbackRating: $0.feedbackRating, feedbackRatingCount: $0.feedbackRatingCount, userId: $0.userId) }
            
        } catch {
            self.errorMessage = "Error retrieving annotation popup info: \(error.localizedDescription)"
            return nil
        }
    }

    
    func fetchAndSetLocation(for group: String, userRole: String, routeDay: String, newCoordinateForAnnotation: @escaping (CLLocationCoordinate2D) -> Void) async {

        if let userCoordinates = await fetchCoordsWithGroupAndRole(groupName: group, userRole: userRole, routeDay: routeDay) {
                for coordinate in userCoordinates {
                    //I know I can retreive this from db, but I chose to split, so now im combining
                    let newCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    newCoordinateForAnnotation(newCoordinate)
                }
            } else {
                print("No coordinates for group \(group)")
            }
        }
    
    func updatePassengerIncludedStatus(passengerIncluded: Bool, whichDriverInvited: Int, longitude: Double, latitude: Double) async {
        do {
            try await LocationQueries.updatePassengerIncludedStatusDB(
                passengerIncluded: passengerIncluded,
                whichDriverInvited: whichDriverInvited,
                longitude: longitude,
                latitude: latitude
            )
        } catch {
            self.errorMessage = "Error when updating passenger status: \(error.localizedDescription)"
        }
    }
    
    func deleteUserEndTrip(userId: Int) async {
        do {
            try await LocationQueries.deleteUserEndTripFromDb(userId: userId)
        } catch {
            self.errorMessage = "Error when deleting user end trip: \(error.localizedDescription)"
        }
    }
    
    func clearInvitedPassengers(userId: Int) async {
        do {
            try await LocationQueries.clearInvitedPassengersStatusDB(userId: userId)
        } catch {
            self.errorMessage = "Error when clearing invited passengers: \(error.localizedDescription)"
        }
    }
    
    func fetchInvitedPassengerInfo(driverId: Int) async -> [(userId: Int, groupName: String, routeDay: String, userName: String)]? {
        do {
            let invitedPassengers = try LocationQueries.retrieveInvitedPassengersFromDb(driverId: driverId)
            
            guard !invitedPassengers.isEmpty else {
                self.errorMessage = "Error, no invited passengers found for driver \(driverId)."
                return nil
            }
            
            return invitedPassengers.map { (userId: $0.userId, groupName: $0.groupName, routeDay: $0.routeDay, userName: $0.userName) }
            
        } catch {
            self.errorMessage = "Error retrieving invited passengers: \(error.localizedDescription)"
            return nil
        }
    }

}
