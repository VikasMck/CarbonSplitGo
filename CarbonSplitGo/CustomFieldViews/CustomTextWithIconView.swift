import SwiftUI

struct CustomTextWithIconView<Destination: View>: View {
    let icon: String
    let text: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .foregroundColor(AppColours.customLightGrey)
        }
    }
}
