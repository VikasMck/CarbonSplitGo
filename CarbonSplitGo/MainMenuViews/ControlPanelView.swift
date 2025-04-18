import SwiftUI

enum UserChoiceDriverPassenger{
        case passenger, driver
}


struct ControlPanelView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @StateObject private var routeGroupViewModel = RouteGroupViewModel()
    @ObservedObject var feedbackViewModel: FeedbackViewModel
    @StateObject var socialViewModel = SocialViewModel()
    @State private var userChoiceDriverPassenger: UserChoiceDriverPassenger = .driver
    @State private var unreadMessages: [(whichUser: Int, messageCount: Int)]? = []
    @State private var unreadFeedback: [(whichDriver: Int, driverName: String)]? = []
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                HStack {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 30,
                        bottomLeading: 0,
                        bottomTrailing: 0,
                        topTrailing: 30
                    ))
                    .stroke(AppColours.customDarkGrey, lineWidth: 2)
                    .fill(AppColours.customDarkGrey)
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            CustomTextWithIconView(
                                icon: unreadMessages?.isEmpty ?? true ? "person.2.fill" : "bell.and.waves.left.and.right.fill", text: "Friends", destination: SocialView().navigationBarBackButtonHidden(true), iconColor: unreadMessages?.isEmpty ?? true ? AppColours.customLightGrey : AppColours.customLightGreen
                            )
                            Spacer()
                            CustomTextWithIconView(icon: "person.fill", text: "Profile", destination: ProfileView().navigationBarBackButtonHidden(true))
                            Spacer()
                            CustomTextWithIconView(icon: "gearshape.fill", text: "Settings", destination: SettingsView().navigationBarBackButtonHidden(true))
                            
                        }
                            .padding(20)
                    )
                }
                
                VStack {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 30,
                        bottomTrailing: 30,
                        topTrailing: 0
                    ))
                    .stroke(AppColours.customDarkGrey, lineWidth: 2)
                    .fill(AppColours.customLightGreen)
                    .frame(height: 300)
                    .overlay(
                        VStack(spacing: 15) {
                            NavigationLink(destination: SearchLocationsView()) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(AppColours.customDarkGrey)
                                    Text("I'm going to...")
                                        .foregroundColor(AppColours.customDarkGrey)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(AppColours.customDarkGrey)
                                    
                                }
                                .padding()
                                .background(AppColours.customLightGrey)
                                .cornerRadius(30)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                UnevenRoundedRectangle(cornerRadii: .init(
                                    topLeading: 30,
                                    bottomLeading: 0,
                                    bottomTrailing: 0,
                                    topTrailing: 30
                                ))
                                .fill(AppColours.customDarkGrey)
                                .frame(height: 25)
                                .overlay {
                                    Text("Saved Locations")
                                        .foregroundColor(AppColours.customLightGrey)
                                }
                                
                                UnevenRoundedRectangle(cornerRadii: .init(
                                    topLeading: 0,
                                    bottomLeading: 30,
                                    bottomTrailing: 30,
                                    topTrailing: 0
                                ))
                                .fill(AppColours.customLightGrey)
                                .frame(height: 70)
                                .overlay(
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 50) {
                                            CustomSavedLocationEntryView(icon: "location.fill", text: "Ongoing")
                                            CustomSavedLocationEntryView(icon: "location.fill", text: "Friends")
                                            CustomSavedLocationEntryView(icon: "location.fill", text: "Work")
                                            CustomSavedLocationEntryView(icon: "location.fill", text: "Uni")
                                            CustomSavedLocationEntryView(icon: "location.fill", text: "Extra")
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                )
                                .clipShape(
                                    UnevenRoundedRectangle(cornerRadii: .init(
                                        topLeading: 0,
                                        bottomLeading: 30,
                                        bottomTrailing: 30,
                                        topTrailing: 0
                                    ))
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            HStack(spacing: 0) {
                                Button(action: { userChoiceDriverPassenger = .driver
                                    Session.shared.setUserRole("Driver")
                                    print("user is now a: " + String(Session.shared.getUserRole()!))}) {
                                    Text("I'm a Driver")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                .background(userChoiceDriverPassenger == .driver ? AppColours.customDarkGrey : AppColours.customLightGrey)
                                .foregroundColor(userChoiceDriverPassenger == .driver ? AppColours.customWhite : AppColours.customBlack)
                                
                                Button(action: { userChoiceDriverPassenger = .passenger
                                    Session.shared.setUserRole("Passenger")
                                    print("user is now a: " + String(Session.shared.getUserRole()!))}) {
                                    Text("I'm a Passenger")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                .background(userChoiceDriverPassenger == .passenger ? AppColours.customDarkGrey : AppColours.customLightGrey)
                                .foregroundColor(userChoiceDriverPassenger == .passenger ? AppColours.customWhite : AppColours.customBlack)
                            }
                            .cornerRadius(30)
                            .padding(.horizontal, 20)
                        }
                    )
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
        }
        .onAppear() {
            suggestionsViewModel.locationForRouteList = ["", ""]
            Task{
                await routeGroupViewModel.clearInvitedPassengers(userId: Session.shared.getUserID() ?? 0)
                
                unreadMessages = await socialViewModel.fetchUnreadMessages(userId: Session.shared.getUserID() ?? 0) ?? []
                
                unreadFeedback = await feedbackViewModel.fetchUnreadFeedbackForDriver(userId: Session.shared.getUserID() ?? 23) ?? []
                
                feedbackViewModel.ifDriverFeedbackShown = !(unreadFeedback?.isEmpty ?? true)
            }
        }
        //this is the most horrible thing to work on. Had to switch to overlay rathan the sheet due to how swift handled States
        .overlay(
            Group {
                if feedbackViewModel.ifDriverFeedbackShown, let feedback = unreadFeedback {
                    FeedbackForDriverView(
                        feedbackViewModel: feedbackViewModel,
                        userId: feedback.first?.whichDriver ?? 0,
                        userName: feedback.first?.driverName ?? ""
                    )
                    .background(AppColours.customWhite)
                    .cornerRadius(20)
                    .padding(40)
                }
            }
        )
    }
}


#Preview {
    ControlPanelView(feedbackViewModel: FeedbackViewModel())
        .environmentObject(SuggestionsViewModel())
}
