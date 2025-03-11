import SwiftUI

struct MessageInputView: View {
    @Binding var messageText: String
    var onSend: () -> Void
    
    var body: some View {
        HStack {
            TextField("Message", text: $messageText, prompt: Text("Message").foregroundColor(AppColours.customMediumGreen))
                .font(.custom("Sen", size: 18))
                .padding(12)
                .background(AppColours.customWhite)
                .cornerRadius(20)
                .foregroundColor(AppColours.customBlack)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.custom("Sen", size: 32))
                    .foregroundColor(AppColours.customDarkGreen)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(15)
    }
}
