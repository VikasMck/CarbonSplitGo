import SwiftUI

struct ContributionsIndividualBoxView: View {
    let text: String
    let value: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.caption)
                .foregroundColor(AppColours.customDarkGrey)
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(height: 30)
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
            )
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ContributionsHeaderView()
}
