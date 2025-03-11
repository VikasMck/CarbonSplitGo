import SwiftUI

struct MessageBubbleView: View {
    let messageText: String
    let isFromCurrentUser: Bool
    let messageTimeSent: String
    let showMessageTime: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading) {
                Text(messageText)
                    .padding(15)
                    .font(.custom("Sen", size: 17))
                    .background(isFromCurrentUser ? AppColours.customMediumGreen : AppColours.customLightGreen)
                    .foregroundColor(isFromCurrentUser ? AppColours.customWhite : AppColours.customDarkGrey)
                    .cornerRadius(15)
                
                if showMessageTime {
                    Text(messageTimeSent)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 1) 

            
            if !isFromCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }

}
