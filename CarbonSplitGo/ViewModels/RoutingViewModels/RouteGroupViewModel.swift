import SwiftUI

class RouteGroupViewModel: ObservableObject {
    @Published var errorMessage: String?

    @MainActor
    func insertPlannedRoute(groupName: String, longitude: Double, latitude: Double) async {
        do {
            try await LocationQueries.insertIntoPlannedRouteToDB(
                groupName: groupName,
                longitude: longitude,
                latitude: latitude
            )
        } catch {
            self.errorMessage = "Failed to insert passenger: \(error.localizedDescription)"
        }
    }
}
