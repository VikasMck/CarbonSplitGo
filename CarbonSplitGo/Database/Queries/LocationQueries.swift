import SwiftUI
import PostgresClientKit

struct LocationQueries {
    static func insertCoordinateToDB(longitude: Double, latitude: Double) async throws {
        let connection = try PostgresConnect.getConnection()
       defer { connection.close() }
       
       let statement = try connection.prepareStatement(
        text: SQLRouteQueries.insertUserCoordinates)
       defer { statement.close() }
       
       try statement.execute(parameterValues: [
           Session.shared.getUserID(),
           longitude,
           latitude,
       ])
    }
    
    static func insertIntoPlannedRouteToDB(groupName: String, longitude: Double, latitude: Double) async throws {
        let connection = try PostgresConnect.getConnection()
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(
            text: SQLRouteQueries.insertIntoPlannedRoute)
        defer { statement.close() }
        
        try statement.execute(parameterValues: [
            groupName,
            Session.shared.getUserID(),
            Session.shared.getUserRole(),
            longitude,
            latitude
        ])
    }

    
    
}
