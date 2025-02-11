import SwiftUI
import PostgresClientKit

struct SocialQueries {
    
    static func retrieveUserFriends(userId: Int) throws -> [String] {
        var friendList: [String] = []
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLSocialQueries.retrieveUserFriends)
        defer {
            statement.close()
        }
        
        let cursor = try statement.execute(parameterValues: [userId])
        defer {
            cursor.close()
        }
        
        //hate using cursor for this. Seems like each time I need new way to do it
        for row in cursor {
            let columns = try row.get().columns
            let name = try columns[0].string()
            friendList.append(name)
        }
        
        return friendList
    }
}
