import SwiftUI

//this view is a copy, but with changes. The FeedbackView has dimiss as the way to close it. As this is a popup after logging in the dismiss would bring back to login.
struct FeedbackForDriverView: View {
    @ObservedObject var feedbackViewModel: FeedbackViewModel
    @State private var navigateToMainPage = false
    
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
                    await feedbackViewModel.clearFeedbackForDriver(userId: userId)
                    navigateToMainPage = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(AppColours.customMediumGreen)
            .foregroundColor(AppColours.customWhite)
            .cornerRadius(30)
            .frame(maxWidth: .infinity, alignment: .center)
            .navigationDestination(isPresented: $navigateToMainPage) {
                MainPageView()
                    .navigationBarBackButtonHidden(true)
            }
        }
        .padding()
        .frame(width: 300, height: 350)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(AppColours.customLightGrey.opacity(0.5))
                        .frame(width: 40, height: 40)
                        .cornerRadius(15)
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(AppColours.customDarkGrey)
                        .onTapGesture {
                            Task {
                                await feedbackViewModel.clearFeedbackForDriver(userId: userId)
                            }
                            navigateToMainPage = true
                        }
                }
                .position(x: 30, y: 30)
            }
        )
        .navigationDestination(isPresented: $navigateToMainPage) {
            MainPageView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct FeedbackForDriverView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackForDriverView(feedbackViewModel: FeedbackViewModel(), userId: 1, userName: "Admin")
    }
}
