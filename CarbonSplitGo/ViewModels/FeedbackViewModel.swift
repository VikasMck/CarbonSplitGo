import Foundation

@MainActor
class FeedbackViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var ifDriverFeedbackShown = false

    func insertFeedback(userId: Int, feedbackRating: Double, feedbackText: String, feedbackTimeSent: String) async {
        do {
            try await FeedbackQueries.insertFeedbackToDb(
                userId: userId,
                feedbackRating: feedbackRating,
                feedbackText: feedbackText,
                feedbackTimeSent: feedbackTimeSent
            )
        } catch {
            self.errorMessage = "Error when sending a message: \(error.localizedDescription)"
        }
    }
    
    func updateFeedbackStatusForDriver(userId: Int, whichDriver: Int) async {
        do{
            try await FeedbackQueries.updateFeedbackStatusForDriverInDb(
                userId: userId,
                whichDriver: whichDriver)
        } catch {
            self.errorMessage = "Error when updating feedback status for driver: \(error.localizedDescription)"
        }
        await MainActor.run {
           ifDriverFeedbackShown = false
       }
    }
    
    func fetchUnreadFeedbackForDriver(userId: Int) async -> [(whichDriver: Int, driverName: String)]? {
        do {
            let unreadFeedback = try FeedbackQueries.retrieveFeedbackForDriverFromDb(userId: userId)
            
            guard !unreadFeedback.isEmpty else {
                print("Error, no unread messages found for user \(userId).")
                return []
            }
            
            return unreadFeedback.map { (whichDriver: $0.whichDriver, driverName: $0.driverName) }
            
        } catch {
            self.errorMessage = "Error retrieving unread messages: \(error.localizedDescription)"
            return nil
        }
    }

    func clearFeedbackForDriver(userId: Int) async {
        do {
            try await FeedbackQueries.clearFeedbackForDriverFromDb(userId: userId)
        } catch {
            self.errorMessage = "Error clearing unread messages: \(error.localizedDescription)"
        }
        await MainActor.run {
            ifDriverFeedbackShown = false
        }
    }
    
    func retrieveUserFeedbackTextFromDb(userId: Int) async -> [(feedbackText: String, feedbackTimeSent: String)]? {
        do {
            let feedbackTextList = try FeedbackQueries.retrieveUserFeedbackTextFromDb(userId: userId)
            
            guard !feedbackTextList.isEmpty else {
                print("Error, no unread messages found for user \(userId).")
                return []
            }
            
            return feedbackTextList.map { (feedbackText: $0.feedbackText, feedbackTimeSent: $0.feedbackTimeSent) }
            
        } catch {
            self.errorMessage = "Error retrieving unread messages: \(error.localizedDescription)"
            return nil
        }
    }
}
