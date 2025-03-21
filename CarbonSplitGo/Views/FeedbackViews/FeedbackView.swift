import SwiftUI

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var feedbackViewModel: FeedbackViewModel
    
    let userId: Int
    let userName: String
    @State private var rating: Double = 5
    @State private var feedbackText: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Feedback for \(userName)")
                .font(.custom("Sen", size: 23))
            
            RatingView(rating: $rating)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(("\(rating, specifier: "%.1f")"))
                .font(.custom("Sen", size: 20))
            
            TextEditor(text: $feedbackText)
                .frame(height: 100)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColours.customLightGreen, lineWidth: 1)
                )

            Button("Submit") {
                Task {
                    await feedbackViewModel.insertFeedback(
                        userId: userId,
                        feedbackRating: rating,
                        feedbackText: feedbackText,
                        feedbackTimeSent: DateFormat.dateFormatDayAndTime(Date())
                    )
                    dismiss()
                }

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(AppColours.customMediumGreen)
            .foregroundColor(AppColours.customWhite)
            .cornerRadius(30)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: 300, height: 350)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 30, y: 30)
            }
        )
    }
    
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(feedbackViewModel: FeedbackViewModel(), userId: 1, userName: "Admin")
    }
}
