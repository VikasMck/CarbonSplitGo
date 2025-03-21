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
}

