import SwiftUI

struct MessagesQueries {
    
    static func retrieveMessagesFromDb(senderId: Int, receiverId: Int) throws -> [(messageText: String, messageTimeSent: String, senderId: Int, receiverId: Int)] {
        var messages: [(messageText: String, messageTimeSent: String, senderId: Int, receiverId: Int)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SSQLMessages.retrieveMessages)
        defer {
            statement.close()
        }
        
        let cursor = try statement.execute(parameterValues: [
            senderId, receiverId, receiverId, senderId
        ])
        
        for row in cursor {
            let columns = try row.get().columns
            let messageText = try columns[0].string()
            let messageTimeSent = try columns[1].string()
            let senderId = try columns[2].int()
            let receiverId = try columns[3].int()

            messages.append((messageText: messageText, messageTimeSent: messageTimeSent, senderId: senderId, receiverId: receiverId))
        }
        
        return messages
    }

    static func sendMessageToDb(senderId: Int, receiverId: Int, messageText: String, messageTimeSent: String) async throws {
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SSQLMessages.sendMessage)
        defer {
            statement.close()
        }
        
       try statement.execute(parameterValues: [senderId, receiverId, messageText, messageTimeSent])
    }
}

