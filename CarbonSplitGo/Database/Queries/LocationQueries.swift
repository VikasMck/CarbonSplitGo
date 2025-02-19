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
    
    static func retrieveUserCoordsFromRouteGroupFromDB(groupName: String, userRole: String, routeDay: String) throws -> [(longitude: Double, latitude: Double)] {
        var userCoordinatesFromRouteGroup: [(Double, Double)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(text: SQLRouteQueries.retrieveUserCoordsFromRouteGroup)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [groupName, userRole, routeDay])
        defer { cursor.close() }
        
        for rowResult in cursor {
            let row = try rowResult.get()
            let columns = row.columns
            let longitude = try columns[0].double()
            let latitude = try columns[1].double()
            
            userCoordinatesFromRouteGroup.append((longitude, latitude))
        }
        return userCoordinatesFromRouteGroup
    }
    
    static func retreiveAnnotationPopupInfoFromRouteGroupDB(longitude: Double, latitude: Double) throws -> [(groupName: String, routeDay: String, userName: String, isVerified: Bool, userPhoneNumber: String)] {
        var annotationPopupInfo: [(groupName: String, routeDay: String, userName: String, isVerified: Bool, userPhoneNumber: String)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(text: SQLRouteQueries.retrieveAnnotationPopUpInfoFromRouteGroup)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [longitude, latitude])
        defer { cursor.close() }
        
        for rowResult in cursor {
            let row = try rowResult.get()
            let columns = row.columns
            let groupName = try columns[0].string()
            let routeDay = try columns[1].string()
            let userName = try columns[2].string()
            let isVerified = try columns[3].bool()
            let userPhoneNumber = try columns[4].string()

            annotationPopupInfo.append((groupName, routeDay, userName, isVerified, userPhoneNumber))
        }
        
        return annotationPopupInfo
    }
    
    
    static func updatePassengerIncludedStatusDB(passengerIncluded: Bool, longitude: Double, latitude: Double) async throws {
        let connection = try PostgresConnect.getConnection()
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(text: SQLRouteQueries.updatePassangerIncludedStatus)
        defer { statement.close() }
        
        try statement.execute(parameterValues: [
            passengerIncluded,
            longitude,
            latitude
        ])
    }


}
