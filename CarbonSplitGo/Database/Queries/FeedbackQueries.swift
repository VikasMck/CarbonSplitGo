import SwiftUI

struct FeedbackQueries {

    static func insertFeedbackToDb(userId: Int, feedbackRating: Double, feedbackText: String, feedbackTimeSent: String) async throws {
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLFeedback.insertFeedback)
        defer {
            statement.close()
        }
        
       try statement.execute(parameterValues: [userId, feedbackRating, feedbackText, feedbackTimeSent])
    }
    
    static func updateFeedbackStatusForDriverInDb(userId: Int, whichDriver: Int) async throws {
        let connection = try PostgresConnect.getConnection()
        
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLFeedback.updateFeedbackStatusForDriver)
        defer {
            statement.close()
        }
        
        try statement.execute(parameterValues: [userId, whichDriver])
    }
    
    static func retrieveFeedbackForDriverFromDb(userId: Int) throws -> [(whichDriver: Int, driverName: String)] {
        var unreadFeedback: [(whichDriver: Int, driverName: String)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLFeedback.retrieveFeedbackForDriver)
        defer {
            statement.close()
        }
        
        let cursor = try statement.execute(parameterValues: [userId])
        
        for row in cursor {
            let columns = try row.get().columns
            let whichDriver = try columns[0].int()
            let driverName = try columns[1].string()
            
            unreadFeedback.append((whichDriver: whichDriver, driverName: driverName))
        }
        return unreadFeedback
    }

    static func clearFeedbackForDriverFromDb(userId: Int) async throws {
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLFeedback.clearFeedbackForDriver)
        defer {
            statement.close()
        }
        
        try statement.execute(parameterValues: [userId])
    }
    
    static func retrieveUserFeedbackTextFromDb(userId: Int) throws -> [(feedbackText: String, feedbackTimeSent: String)] {
        var feedbackTextList: [(feedbackText: String, feedbackTimeSent: String)] = []
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLFeedback.retrieveUserFeedbackText)
        defer {
            statement.close()
        }
        
        let cursor = try statement.execute(parameterValues: [userId])
        
        for row in cursor {
            let columns = try row.get().columns
            let feedbackText = try columns[0].string()
            let feedbackTimeSent = try columns[1].string()
            
            feedbackTextList.append((feedbackText: feedbackText, feedbackTimeSent: feedbackTimeSent))
        }
        return feedbackTextList
    }
    
}

