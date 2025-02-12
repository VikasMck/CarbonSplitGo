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
    
    static func retrieveUserGroups(userId: Int) throws -> [String] {
        var groupList: [String] = []
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLSocialQueries.retrieveUserGroups)
        defer {
            statement.close()
        }
        
        let cursor = try statement.execute(parameterValues: [userId])
        defer {
            cursor.close()
        }
        
        for row in cursor {
            let columns = try row.get().columns
            let name = try columns[0].string()
            groupList.append(name)
        }
        
        return groupList
    }

    
    
    static func insertFriendship(userId: Int, friendId: Int) throws {
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLSocialQueries.addFriend)
        defer {
            statement.close()
        }
        
        try statement.execute(parameterValues: [
            userId, friendId, friendId, userId
        ])
    }
    
    static func insertGroup(groupName: String, userId: Int) throws {
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLSocialQueries.joinGroup)
        defer {
            statement.close()
        }
        
        try statement.execute(parameterValues: [
            groupName, userId
        ])
    }
    
}
