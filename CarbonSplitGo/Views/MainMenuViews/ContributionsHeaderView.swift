import SwiftUI

struct ContributionsIndividualBoxView: View {
    let text: String
    let value: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.caption)
                .foregroundColor(AppColours.customDarkGrey)
                .bold()
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(height: 30)
                .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(AppColours.customLightGrey, lineWidth: 4)
                        )
                .overlay(
                    Text(value)
                        .foregroundColor(AppColours.customDarkGrey)
                        .padding(.horizontal, 8)
            )
        }
    }
}

struct ContributionsHeaderView: View {
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
                    ContributionsIndividualBoxView(text: "CO₂ Saved", value: "")
                    ContributionsIndividualBoxView(text: "Distance Shared", value: "")
                    ContributionsIndividualBoxView(text: "CarbonPoints", value: "")
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(AppColours.customLightGreen)
                    .stroke(AppColours.customMediumGreen, lineWidth: 4)

            )
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ContributionsHeaderView()
}
