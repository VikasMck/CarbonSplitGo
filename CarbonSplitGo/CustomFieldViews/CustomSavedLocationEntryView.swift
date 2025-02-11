import SwiftUI


struct CustomSavedLocationEntryView: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.caption2)
                .foregroundColor(.black)
            Circle()
                .fill(AppColours.customDarkGrey)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(AppColours.customLightGrey)
                )
        }
    }
}
