import SwiftUI

struct FeedbackTextView: View {
    let userId: Int
    let userName: String
    let feedbackRating: Double
    let feedbackRatingCount: Int
    @StateObject private var feedbackViewModel = FeedbackViewModel()
    @State private var feedbackTextList: [(feedbackText: String, feedbackTimeSent: String)] = []
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                Text("\(userName)")
                    .font(.custom("Sen", size: 50))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack(spacing: 0){
                
                ForEach(1...5, id: \.self) { index in
                    if Double(index) <= feedbackRating {
                        Image(systemName: "rectangle.fill")
                            .foregroundColor(AppColours.customBlack)
                    } else if Double(index) - 0.5 == feedbackRating {
                        Image(systemName: "rectangle.lefthalf.filled")
                            .foregroundColor(AppColours.customBlack)
                    } else {
                        Image(systemName: "rectangle")
                            .foregroundColor(AppColours.customBlack)
                    }
                }

                Text(" (\(feedbackRatingCount))")
                        .font(.custom("Sen", size: 25))
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Divider().frame(width: 300, height: 3).background(AppColours.customWhite).frame(maxWidth: .infinity)
                
                ScrollView {
                    if feedbackTextList.isEmpty {
                        Text("No feedback yet")
                            .font(.custom("Sen", size: 30))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(feedbackTextList, id: \.feedbackTimeSent) { review in
                            VStack(alignment: .leading) {
                                Text(review.feedbackText.isEmpty ? "No text" : review.feedbackText)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(AppColours.customWhite)
                                    .cornerRadius(30)
                                    .font(.custom("Sen", size: 20))
                                Text(review.feedbackTimeSent)
                                    .font(.custom("Sen", size: 15))
                                    .foregroundColor(AppColours.customBlack)
                            }
                        }
                    }
                    .padding()
                }
            }
            .task {
                feedbackTextList = await feedbackViewModel.retrieveUserFeedbackTextFromDb(userId: userId) ?? []
            }
        }
        .background(AppColours.customMediumGreen)
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 30, y: 0)
            }
        )
    }
}

#Preview {
    FeedbackTextView(userId: 20, userName: "Admin", feedbackRating: 5, feedbackRatingCount: 2)
}
