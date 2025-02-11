import SwiftUI
import PostgresClientKit

struct UserMaintenanceQueries {
    static func changeUserToOnline(email: String) throws -> Bool {
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLQueries.changeUserToOnline)
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
        
        let statement = try connection.prepareStatement(text: SQLQueries.changeUserToOffline)
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

}
