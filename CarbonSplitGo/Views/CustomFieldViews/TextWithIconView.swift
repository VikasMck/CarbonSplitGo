import SwiftUI

struct TextWithIconView: View {
    let icon: String
    let text: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .foregroundColor(AppColours.customLightGrey)
        }
    }
}
