import SwiftUI
import PostgresClientKit

struct UserMaintenanceQueries {
    static func changeUserToOnline(email: String) throws -> Bool {
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLUserQueries.changeUserToOnline)
        defer {
            statement.close()
        }
        
        let result = try statement.execute(parameterValues: [email])
        
        //just check if any rows updated
        if let rowCount = result.rowCount, rowCount > 0 {
            return true
        }
        return false
    }
    
    static func changeUserToOffline(email: String) throws -> Bool {
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLUserQueries.changeUserToOffline)
        defer {
            statement.close()
        }
        
        let result = try statement.execute(parameterValues: [email])
        
        //just check if any rows updated
        if let rowCount = result.rowCount, rowCount > 0 {
            return true
        }
        return false

    }
    
    static func updateUserRouteRewards(userSavedCO2: Double, userDistanceShared: Double, userCarbonCredits: Double, userId: Int) throws {
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLUserQueries.updateUserRouteRewards)
        defer {
            statement.close()
        }
        
        try statement.execute(parameterValues: [userSavedCO2, userDistanceShared, userCarbonCredits, userId])
    }

    
    static func retrieveUserStatsFromDb(userId: Int) throws -> [(userSavedCO2: Double, userDistanceShared: Double, userCarbonCredits: Double)] {
        var userStats: [(userSavedCO2: Double, userDistanceShared: Double, userCarbonCredits: Double)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLUserQueries.retrieveUserStats)
        defer {
            statement.close()
        }
        
        let cursor = try statement.execute(parameterValues: [userId])
        
        for row in cursor {
            let columns = try row.get().columns
            let userSavedCO2 = try columns[0].double()
            let userDistanceShared = try columns[1].double()
            let userCarbonCredits = try columns[2].double()

            userStats.append((userSavedCO2: userSavedCO2, userDistanceShared: userDistanceShared, userCarbonCredits: userCarbonCredits))
        }
        
        return userStats
    }
}
