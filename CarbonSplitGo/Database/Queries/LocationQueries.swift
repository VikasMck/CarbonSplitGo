import SwiftUI
import PostgresClientKit

struct LocationQueries {
    
    static func insertCoordinateToDB(longitude: Double, latitude: Double) async throws {
        let connection = try PostgresConnect.getConnection()
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(text: SQLRouteQueries.insertUserCoordinates)
        
        defer { statement.close() }
        
        try statement.execute(parameterValues: [
            Session.shared.getUserID(),
            longitude,
            latitude,
        ])
    }
    
    static func insertIntoPlannedRouteToDB(groupName: String, longitude: Double, latitude: Double, routeDate: String) async throws {
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
            latitude,
            routeDate
        ])
    }
    
    static func retrieveUserCoordsFromRouteGroupFromDB(groupName: String, userRole: String) throws -> [(longitude: Double, latitude: Double)] {
        var userCoordinatesFromRouteGroup: [(Double, Double)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(text: SQLRouteQueries.retrieveUserCoordsFromRouteGroup)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [groupName, userRole])
        defer { cursor.close() }
        
        for rowResult in cursor {
            let row = try rowResult.get()
            let columns = row.columns
            let longitude = try columns[0].double()
            let latitude = try columns[1].double()
            
            userCoordinatesFromRouteGroup.append((longitude, latitude))
        }
        return userCoordinatesFromRouteGroup
    }}
