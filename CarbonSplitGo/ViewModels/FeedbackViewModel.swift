import Foundation

@MainActor
class FeedbackViewModel: ObservableObject {
    @Published var errorMessage: String? = nil

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
}
