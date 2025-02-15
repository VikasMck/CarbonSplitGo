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
    
    static func retrieveUserInfoFromRouteGroupFromDB(groupName: String, userRole: String) throws -> [(userID: String, groupName: String, routeDay: String, userRole: String, longitude: Double, latitude: Double, userName: String, userEmail: String)] {
        var userInformationFromRouteGroup: [(String, String, String, String, Double, Double, String, String)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(text: SQLRouteQueries.retrieveUserInfoFromRouteGroup)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [groupName, userRole])
        defer { cursor.close() }
        
        for rowResult in cursor {
            let row = try rowResult.get()
            let columns = row.columns
            let userID = try columns[0].string()
            let groupName = try columns[1].string()
            let routeDay = try columns[2].string()
            let userRole = try columns[3].string()
            let longitude = try columns[4].double()
            let latitude = try columns[5].double()
            let userName = try columns[6].string()
            let userEmail = try columns[7].string()
            
            userInformationFromRouteGroup.append((userID, groupName, routeDay, userRole, longitude, latitude, userName, userEmail))
        }
        return userInformationFromRouteGroup
    }
}
