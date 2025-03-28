import SwiftUI

struct CustomDriverSelectionView: View {
    let userId: Int
    let userName: String
    let groupName: String
    let routeDay: String
    let feedbackRating: Double
    let feedbackRatingCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Driver: \(userName)")
                    .font(.custom("Sen", size: 18))
                    .foregroundColor(AppColours.customDarkGrey)
                Text("Group: \(groupName)")
                    .font(.custom("Sen", size: 18))
                    .foregroundColor(AppColours.customDarkGrey)
                NavigationLink(destination: FeedbackTextView(userId: userId, userName: userName, feedbackRating: feedbackRating, feedbackRatingCount: feedbackRatingCount).navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 0) {
                        Text("Rating: ")
                            .foregroundColor(AppColours.customDarkGrey)
                        ForEach(1...5, id: \.self) { index in
                            if Double(index) <= feedbackRating {
                                Image(systemName: "rectangle.fill")
                                    .foregroundColor(AppColours.customMediumGreen)
                            } else if Double(index) - 0.5 == feedbackRating {
                                Image(systemName: "rectangle.lefthalf.filled")
                                    .foregroundColor(AppColours.customMediumGreen)
                            } else {
                                Image(systemName: "rectangle")
                                    .foregroundColor(AppColours.customMediumGreen)
                            }
                        }
                        Text("(\(feedbackRatingCount))")
                            .foregroundColor(AppColours.customDarkGrey)
                    }
                }
            }
            Spacer()
            
            Text((routeDay.suffix(5)))
                .font(.custom("Sen", size: 25))
                .foregroundColor(AppColours.customDarkGreen)

            Spacer()
            
            Button(action: {
                //later
            }) {
                
                NavigationLink(destination: MessagesView(senderId: Session.shared.getUserID() ?? 0, receiverId: userId, friendName: userName)
                    .navigationBarBackButtonHidden(true)) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColours.customDarkGreen)
                        .font(.custom("Sen", size: 25))
                }                            

            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColours.customWhite)
        .cornerRadius(15)
        .shadow(color: AppColours.customDarkGreen.opacity(0.5), radius: 5, x: 0, y: 0)
        .padding(.horizontal)
    }
}
#Preview {
    CustomDriverSelectionView(userId: 1, userName: "Admin", groupName: "Mastercard", routeDay: "22/02/2025 10:30", feedbackRating: 2.5, feedbackRatingCount: 2)
}
