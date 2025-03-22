import SwiftUI
import MapKit

@MainActor
class UserLocationViewModel: ObservableObject {
    @Published var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var isUserLocationOn = false
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    @Published var userStatsInfo: [(userSavedCO2: Double, userDistanceShared: Double, userCarbonCredits: Double)] = []
    @Published var errorMessage: String?
    
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
    
    func updateUserRouteRewards(userSavedCO2: Double, userDistanceShared: Double, userCarbonCredits: Double, userId: Int) async {
        do {
            try UserMaintenanceQueries.updateUserRouteRewards(
                userSavedCO2: userSavedCO2,
                userDistanceShared: userDistanceShared,
                userCarbonCredits: userCarbonCredits,
                userId: userId
            )
        } catch {
            self.errorMessage = "Error updating user route rewards: \(error.localizedDescription)"
        }
    }

    func retrieveUserStats(userId: Int) async -> [(userSavedCO2: Double, userDistanceShared: Double, userCarbonCredits: Double)]? {
        do {
            let userStats = try UserMaintenanceQueries.retrieveUserStatsFromDb(userId: userId)
            
            guard !userStats.isEmpty else {
                self.errorMessage = "Error nothing found for user ID \(userId)."
                return nil
            }
            
            self.userStatsInfo = userStats
            
            return userStats.map { (userSavedCO2: $0.userSavedCO2, userDistanceShared: $0.userDistanceShared, userCarbonCredits: $0.userCarbonCredits) }
            
        } catch {
            self.errorMessage = "Error when retrieving user stats: \(error.localizedDescription)"
            return nil
        }
    }
    
}
//callback for updated location permissions
extension UserLocationViewModel: Location {
    nonisolated func locationService(_ manager: CLLocationManager, didUpdateAuthorisationStatus status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorisationStatus = status
            self.isUserLocationOn = (status == .authorizedWhenInUse || status == .authorizedAlways)
        }
    }
}
