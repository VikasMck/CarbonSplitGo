import SwiftUI

struct ContributionsIndividualBoxView: View {
    let text: String
    let value: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.custom("Sen", size: 13))
                .foregroundColor(AppColours.customDarkGrey)
                .bold()
            RoundedRectangle(cornerRadius: 30)
                .fill(AppColours.customWhite)
                .frame(height: 30)
                .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(AppColours.customLightGrey, lineWidth: 2)
                        )
                .overlay(
                    Text(value)
                        .foregroundColor(AppColours.customDarkGrey)
                        .font(.custom("Sen", size: 15))
                        .padding(.horizontal, 8)
            )
        }
    }
}

struct ContributionsHeaderView: View {
    @StateObject private var userLocationViewModel = UserLocationViewModel()
    @State private var userStats: [(userSavedCO2: Double, userDistanceShared: Double, userCarbonCredits: Double)] = []
    
    var body: some View {
        VStack() {
            VStack {
                Text("You are Making the World a Better Place!")
                    .foregroundColor(AppColours.customDarkGrey)
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
                    .bold()
                
                Divider().frame(width: 300,height: 3).background(AppColours.customDarkGreen)

                HStack {
                    ContributionsIndividualBoxView(text: "CO₂ Saved", value: String(format: "%.2f kg", userStats.first?.userSavedCO2 ?? 0.0))
                    ContributionsIndividualBoxView(text: "Distance Shared", value: String(format: "%.2f km", userStats.first?.userDistanceShared ?? 0.0))
                    ContributionsIndividualBoxView(text: "Carbon Credits", value: String(format: "%.2f", userStats.first?.userCarbonCredits ?? 0.0))
                                    }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(AppColours.customLightGreen)
                    .stroke(AppColours.customMediumGreen, lineWidth: 2)

            )
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            Task {
                userStats = await userLocationViewModel.retrieveUserStats(userId: Session.shared.getUserID() ?? 1) ?? []
                
            }
        }
    }
}

#Preview {
    ContributionsHeaderView()
}
